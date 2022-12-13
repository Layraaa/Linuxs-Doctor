# enviarreporte.sh
# Archivo que ejecuta el menú para decidir a donde exportar las
# evidencias y contiene las funciones que comprueban y envian estas
# al destino deseado


# from SO: https://stackoverflow.com/a/54261882/317605 (by https://stackoverflow.com/users/8207842/dols3m)

function multiselect () {
    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()   { printf "$ESC[?25h"; }
    cursor_blink_off()  { printf "$ESC[?25l"; }
    cursor_to()         { printf "$ESC[$1;${2:-1}H"; }
    print_inactive()    { printf "$2   $1 "; }
    print_active()      { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()    { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()         {
      local key
      IFS= read -rsn1 key 2>/dev/null >&2
      if [[ $key = ""      ]]; then echo enter; fi;
      if [[ $key = $'\x20' ]]; then echo space; fi;
      if [[ $key = $'\x1b' ]]; then
        read -rsn2 key
        if [[ $key = [A ]]; then echo up;    fi;
        if [[ $key = [B ]]; then echo down;  fi;
      fi 
    }
    toggle_option()    {
      local arr_name=$1
      eval "local arr=(\"\${${arr_name}[@]}\")"
      local option=$2
      if [[ ${arr[option]} == true ]]; then
        arr[option]=
      else
        arr[option]=true
      fi
      eval $arr_name='("${arr[@]}")'
    }

    local retval=$1
    local options
    local defaults

    IFS=';' read -r -a options <<< "$2"
    if [[ -z $3 ]]; then
      defaults=()
    else
      IFS=';' read -r -a defaults <<< "$3"
    fi
    local selected=()

    for ((i=0; i<${#options[@]}; i++)); do
      selected+=("${defaults[i]:-false}")
      printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - ${#options[@]}))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for option in "${options[@]}"; do
            local prefix="[ ]"
            if [[ ${selected[idx]} == true ]]; then
              prefix="[x]"
            fi

            cursor_to $(($startrow + $idx))
            if [ $idx -eq $active ]; then
                print_active "$option" "$prefix"
            else
                print_inactive "$option" "$prefix"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            space)  toggle_option selected $active;;
            enter)  break;;
            up)     ((active--));
                    if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi;;
            down)   ((active++));
                    if [ $active -ge ${#options[@]} ]; then active=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    eval $retval='("${selected[@]}")'
}

function reportetelegram (){
    function preguntardatostelegram (){
        while true
        do
            read -r -p "${lightblue}ID del usuario de Telegram que recibira el reporte (Se puede obtener en https://telegram.me/userinfobot): ${white}" telegramid
            if [ "$telegramid" != "" ]
            then
                telegram="S"
                break
            else
                continue
            fi
        done
    }

    if [ -z "$telegramid" ]
    then
        while true
        do
            read -r -p "${lightblue}No se ha detectado el ID de Telegram para enviar las evidencias, ¿quierés proporcionarlo ahora o cancelar la subida de evidencias?${green} [S/N] ${white}" telegram
            if [[ $telegram == "S" ]] || [[ $telegram == "s" ]]
            then
                preguntardatostelegram
                break
            elif [[ $telegram == "N" ]] || [[ $telegram == "n" ]]
            then
                break
            else
                continue
            fi
        done
    else
        while true
        do
            echo "${lightblue}¿Quieres usar los datos existentes para hacer el envío de la información por Telegram?"
            echo "ID: $telegramid"

            read -r -p "${green}[S/N] ${white}" comptelegram
            if [[ $comptelegram == "S" ]] || [[ $comptelegram == "s" ]]
            then
                telegram="S"
                break
            elif [[ $comptelegram == "N" ]] || [[ $comptelegram == "n" ]]
            then
                echo ""
                preguntardatostelegram
                break
            else
                continue
            fi
        done
    fi
}

function reporteftp (){
    # Pregunta por los datos para la conexión FTP
    function preguntardatosftp () {
        while true
        do
            read -r -p "Usuario: " userftp
            if [ "$userftp" != "" ]
            then
                while true
                do
                    read -r -s -p "Contraseña: " passftp
                    if [ "$passftp" != "" ]
                    then
                        break
                    else
                        continue
                    fi
                done
                    break
            else
                while true
                do
                    read -r -p "${lightblue}¿Vas a utilizar un usuario anónimo (Es peligroso, ya que cualquiera podría acceder a tus evidencias)?${green}[S/N] ${white}" compftp
                    if [[ $compftp == "S" ]] || [[ $compftp == "s" ]]
                    then
                        userftp=""
                        passftp=""
                        break
                    elif [[ $compftp == "N" ]] || [[ $compftp == "n" ]]
                    then
                        break
                    else
                        continue
                    fi
                done
                continue
            fi
        done

        while true
        do
            echo ""
            read -r -p "${lightblue}Servidor FTP (192.168.1.100 // ejemplo.com): ${white}" serverftp
            if [ "$serverftp" != "" ]
            then
                ftp="S"
                break
            else
                continue
            fi
        done
    }

    # Detecta los datos de la conexión FTP y revisa si quiere cambiarlos el usuario
    if [[ -z $userftp ]] || [[ -z $passftp ]] || [[ -z $serverftp ]]
    then
        while true
        do
            read -r -p "${lightblue}No se han detectado los datos para hacer las conexión FTP, ¿quierés proporcionarlos ahora o cancelar la subida de evidencias?${green} [S/N] ${white}" ftp
            if [[ $ftp == "S" ]] || [[ $ftp == "s" ]]
            then
                preguntardatosftp
                break
            elif [[ $ftp == "N" ]] || [[ $ftp == "n" ]]
            then
                break
            else
                continue
            fi
        done
    else
        while true
        do
            publicpassftp=$(echo "$passftp" | tr -c \\n \*)
            echo "${lightblue}¿Quieres usar los datos existentes para hacer la conexión FTP?"
            echo "Usuario: $userftp"
            echo "Contraseña: $publicpassftp"
            echo "Servidor FTP: $serverftp"
            
            read -r -p "${green}[S/N] ${white}" compftp
            
            if [[ $compftp == "S" ]] || [[ $compftp == "s" ]]
            then
                ftp="S"
                break
            elif [[ $compftp == "N" ]] || [[ $compftp == "n" ]]
            then
                echo ""
                preguntardatosftp
                break
            else
                continue
            fi
        done
    fi
			
}

function enviarreportetelegram (){
    # Realiza la subida de las evidencias a Telegram si se le indicó
	if [[ $telegram == "S" ]] || [[ $telegram == "s" ]]
	then
        echo ""
		echo "${lightblue}Subiendo las evidencias a Telegram...${white}"
        echo ""
		date +"Subida de las evidencias a Telegram el %d/%m/%Y - %T" >> log.txt
		zip -r evidencias-"$date".zip "$rutadatos" >> /dev/null
        curl -X POST \
            -H 'Content-Type: application/json' \
            -d '{"chat_id": "$telegramid", "text": "This is a test from curl", "disable_notification": true}' \
            "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZE1lc3NhZ2U=")"
        curl -F document=@"evidencias-$date.zip" "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZERvY3VtZW50")"?chat_id="$telegramid"
        rm -rf evidencias-"$date".zip >> log.txt
        echo ""
		echo "${lightblue}Completado!${white}"
	fi
}

function enviarreporteftp (){
    # Realiza la subida de las evidencias al servidor FTP si se le indicó
	if [[ $ftp == "S" ]] || [[ $ftp == "s" ]]
	then
        echo ""
		echo "${lightblue}Subiendo las evidencias al servidor FTP...${white}"
        echo ""
		date +"Subida de las evidencias al servidor FTP el %d/%m/%Y - %T" >> log.txt
		zip -r evidencias-"$date".zip "$rutadatos" >> /dev/null
		curl -T evidencias-"$date".zip -u "$userftp:$passftp" ftp://"$serverftp" >> log.txt
		rm -rf evidencias-"$date".zip >> log.txt
        echo ""
		echo "${lightblue}Completado!${white}"
	fi
}

function comprobarenviarreporte (){
    if [[ ! " ${resultadoreporte[*]} " =~ "Salir" ]]
    then
        if [[ " ${resultadoreporte[*]} " =~ "Telegram" ]]
        then
            enviarreportetelegram
        fi
        if [[ " ${resultadoreporte[*]} " =~ "FTP" ]]
        then
            enviarreporteftp
        fi
    fi
}

function menureporte (){
    # Llama al menú
    opciones=("Telegram" "FTP" "Salir")

    for i in "${!opciones[@]}"; do
        OPTIONS_STRING+="${opciones[$i]};"
    done

    while true
    do
        echo ""
        echo "${lightblue}¿Quieres enviarlo por algún medio?${white}"
        multiselect resultadoopciones "$OPTIONS_STRING"

        for i in "${!resultadoopciones[@]}"; do
            if [ "${resultadoopciones[$i]}" == "true" ]
            then
                resultadoreporte+=("${opciones[$i]}")
            fi
        done

        if [[ " ${resultadoreporte[*]} " =~ "Salir" ]]
        then
            break
        elif [[ "${resultadoreporte[0]}" == "" ]]
        then
            continue
        else
            if [[ " ${resultadoreporte[*]} " =~ "Telegram" ]]
            then
                reportetelegram
            fi
            if [[ " ${resultadoreporte[*]} " =~ "FTP" ]]
            then
                reporteftp
            fi
            break
        fi
    done
}
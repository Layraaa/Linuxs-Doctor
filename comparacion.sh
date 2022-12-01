# comparacion.sh
# Archivo que comprueba el sistema operativo a realizar las
# comparaciones pertinenetes y contiene las funciones que hacen
# estas comparaciones

function comparacionDebian (){
    # Inicio de las comparaciones de archivos recogidos para realizar el reporte del análisis
	touch "$rutadatos"/reporte.txt
	date +"Reporte realizado el %d/%m/%Y - %T" >> log.txt
	date +"Reporte realizado el %d/%m/%Y - %T" >> "$rutadatos"/reporte.txt
	echo "" >> "$rutadatos"/reporte.txt
    echo ""
	echo "${white}[${red}*${white}]${lightblue} Iniciando comparaciones de archivos..."

	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/archivos-de-sistema || ! -d $rutadatos/archivos-de-sistema ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los archivos de sistema"
		echo ""
	else
		# Inicio de las comparaciones de archivos de sistema
		echo "${white}[${red}*${white}]${lightblue} Analizando los archivos del sistema..."

		if [[ ! -f $rutauno/archivos-de-sistema/kernelfirma.txt || ! -f $rutadatos/archivos-de-sistema/kernelfirma.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el kernel, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/kernelfirma.txt "$rutadatos"/archivos-de-sistema/kernelfirma.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El kernel no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El kernel ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/kernelfirma.txt "$rutadatos"/archivos-de-sistema/kernelfirma.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/sudoersfirma.txt || ! -f $rutadatos/archivos-de-sistema/sudoersfirma.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo sudoers, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/sudoersfirma.txt "$rutadatos"/archivos-de-sistema/sudoersfirma.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo sudoers no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo sudoers ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/sudoers.txt "$rutadatos"/archivos-de-sistema/sudoers.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/shadowfirma.txt || ! -f $rutadatos/archivos-de-sistema/shadowfirma.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo shadow, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/shadowfirma.txt "$rutadatos"/archivos-de-sistema/shadowfirma.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo shadow no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo shadow ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/shadow.txt "$rutadatos"/archivos-de-sistema/shadow.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/passwdfirma.txt || ! -f $rutadatos/archivos-de-sistema/passwdfirma.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo passwd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/passwdfirma.txt "$rutadatos"/archivos-de-sistema/passwdfirma.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo passwd no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo passwd ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/passwdfirma.txt "$rutadatos"/archivos-de-sistema/passwdfirma.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/root_bash_history.txt || ! -f $rutadatos/archivos-de-sistema/root_bash_history.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo bash history, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/root_bash_history.txt "$rutadatos"/archivos-de-sistema/root_bash_history.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El bash history no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El bash history ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/root_bash_history.txt "$rutadatos"/archivos-de-sistema/root_bash_history.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/dpkg.txt || ! -f $rutadatos/archivos-de-sistema/dpkg.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo dpkg, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/dpkg.txt "$rutadatos"/archivos-de-sistema/dpkg.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se detectan paquetes nuevos/eliminados" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado paquetes nuevos/eliminados" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/dpkg.txt "$rutadatos"/archivos-de-sistema/dpkg.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/crontab.txt || ! -f $rutadatos/archivos-de-sistema/crontab.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo crontab, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/crontab.txt "$rutadatos"/archivos-de-sistema/crontab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo crontab no ha sido modificada" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo crontab ha sido modificada" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/crontab.txt "$rutadatos"/archivos-de-sistema/crontab.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/crontabl.txt || ! -f $rutadatos/archivos-de-sistema/crontabl.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las tablas de tareas cron , revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/crontabl.txt "$rutadatos"/archivos-de-sistema/crontabl.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Las tablas de tareas cron no han sido modificada" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Las tablas de tareas cron han sido modificada" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/crontabl.txt "$rutadatos"/archivos-de-sistema/crontabl.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/grub.txt || ! -f $rutadatos/archivos-de-sistema/grub.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el GRUB, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/grub.txt "$rutadatos"/archivos-de-sistema/grub.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El GRUB no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El GRUB ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/grub.txt "$rutadatos"/archivos-de-sistema/grub.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/interfaces.txt || ! -f $rutadatos/archivos-de-sistema/interfaces.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo interfaces, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/interfaces.txt "$rutadatos"/archivos-de-sistema/interfaces.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo interfaces no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo interfaces ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/interfaces.txt "$rutadatos"/archivos-de-sistema/interfaces.txt >> "$rutadatos"/reporte.txt
        fi
        
        if [[ ! -f $rutauno/archivos-de-sistema/profile.txt || ! -f $rutadatos/archivos-de-sistema/profile.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo profile, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/profile.txt "$rutadatos"/archivos-de-sistema/profile.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo profile no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo profile ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/profile.txt "$rutadatos"/archivos-de-sistema/profile.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/hosts.txt || ! -f $rutadatos/archivos-de-sistema/hosts.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo hosts, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/hosts.txt "$rutadatos"/archivos-de-sistema/hosts.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo hosts no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo hosts ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/hosts.txt "$rutadatos"/archivos-de-sistema/hosts.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/fstab.txt || ! -f $rutadatos/archivos-de-sistema/fstab.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo fstab, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/fstab.txt "$rutadatos"/archivos-de-sistema/fstab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo fstab no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo fstab ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/fstab.txt "$rutadatos"/archivos-de-sistema/fstab.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/mtab.txt || ! -f $rutadatos/archivos-de-sistema/mtab.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo mtab, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/mtab.txt "$rutadatos"/archivos-de-sistema/mtab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo mtab no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo mtab ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/mtab.txt "$rutadatos"/archivos-de-sistema/mtab.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/group.txt || ! -f $rutadatos/archivos-de-sistema/group.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo group, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/group.txt "$rutadatos"/archivos-de-sistema/group.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo group no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo group ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/group.txt "$rutadatos"/archivos-de-sistema/group.txt >> "$rutadatos"/reporte.txt
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/rc.d/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/rc.d/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/rc.d/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                ruta3=$(ls "$rutauno"/archivos-de-sistema/rc.d/"$i")
                for x in $ruta3
                do
                    if [[ ! -f $rutauno/archivos-de-sistema/rc.d/$i/$x || ! -f $rutadatos/archivos-de-sistema/rc.d/$i/$x ]]
                    then
                        echo "[?] No se ha podido analizar la información sobre el archivo $i/$x, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                    elif [[ $(cmp "$rutauno"/archivos-de-sistema/rc.d/"$i"/"$x" "$rutadatos"/archivos-de-sistema/rc.d/"$i"/"$x") == "" ]] >> log.txt 2>&1
                    then
                        echo "[*] El archivo $i/$x no ha sido modificado" >> "$rutadatos"/reporte.txt
                    else
                        echo "[!] El archivo $i/$x ha sido modificado" >> "$rutadatos"/reporte.txt
                        diff "$rutauno"/archivos-de-sistema/rc.d/"$i"/"$x" "$rutadatos"/archivos-de-sistema/rc.d/"$i"/"$x" >> "$rutadatos"/reporte.txt
                    fi
                done
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/init.d/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/init.d/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/init.d/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/init.d/$i || ! -f $rutadatos/archivos-de-sistema/init.d/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo init.d/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/init.d/"$i" "$rutadatos"/archivos-de-sistema/init.d/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo init.d/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo init.d/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/init.d/"$i" "$rutadatos"/archivos-de-sistema/init.d/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.d/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.d/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.d/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.d/$i || ! -f $rutadatos/archivos-de-sistema/cron.d/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.d/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.d/"$i" "$rutadatos"/archivos-de-sistema/cron.d/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.d/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.d/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.d/"$i" "$rutadatos"/archivos-de-sistema/cron.d/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.hourly/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.hourly/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.hourly/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.hourly/$i || ! -f $rutadatos/archivos-de-sistema/cron.hourly/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.hourly/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.hourly/"$i" "$rutadatos"/archivos-de-sistema/cron.hourly/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.hourly/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.hourly/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.hourly/"$i" "$rutadatos"/archivos-de-sistema/cron.hourly/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.dialy/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.dialy/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.dialy/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.dialy/$i || ! -f $rutadatos/archivos-de-sistema/cron.dialy/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.dialy/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.dialy/"$i" "$rutadatos"/archivos-de-sistema/cron.dialy/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.dialy/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.dialy/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.dialy/"$i" "$rutadatos"/archivos-de-sistema/cron.dialy/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.weekely/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.weekely/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.weekely/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.weekely/$i || ! -f $rutadatos/archivos-de-sistema/cron.weekely/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.weekely/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.weekely/"$i" "$rutadatos"/archivos-de-sistema/cron.weekely/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.weekely/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.weekely/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.weekely/"$i" "$rutadatos"/archivos-de-sistema/cron.weekely/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.monthly/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.monthly/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.monthly/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.monthly/$i || ! -f $rutadatos/archivos-de-sistema/cron.monthly/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.monthly/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.monthly/"$i" "$rutadatos"/archivos-de-sistema/cron.monthly/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.monthly/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.monthly/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.monthly/"$i" "$rutadatos"/archivos-de-sistema/cron.monthly/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/cmdline.txt || ! -f $rutadatos/archivos-de-sistema/cmdline.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo cmdline, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/cmdline.txt "$rutadatos"/archivos-de-sistema/cmdline.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo cmdline no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo cmdline ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/cmdline.txt "$rutadatos"/archivos-de-sistema/cmdline.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/blkid.txt || ! -f $rutadatos/archivos-de-sistema/blkid.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las particiones del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/blkid.txt "$rutadatos"/archivos-de-sistema/blkid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Las particiones del sistema no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Las particiones del sistema han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/blkid.txt "$rutadatos"/archivos-de-sistema/blkid.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/lastlog.txt || ! -f $rutadatos/archivos-de-sistema/lastlog.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el lastlog, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/lastlog.txt "$rutadatos"/archivos-de-sistema/lastlog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se ha detectado un login nuevo desde la última vez" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se ha detectado un login nuevo desde la última vez" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/lastlog.txt "$rutadatos"/archivos-de-sistema/lastlog.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/runlevel.txt || ! -f $rutadatos/archivos-de-sistema/runlevel.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el modo de operación del sistema operativo, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/runlevel.txt "$rutadatos"/archivos-de-sistema/runlevel.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El modo de operación del sistema operativo no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El modo de operación del sistema operativo ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/runlevel.txt "$rutadatos"/archivos-de-sistema/runlevel.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/lspci.txt || ! -f $rutadatos/archivos-de-sistema/lspci.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre los buses y dispositivos del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/lspci.txt "$rutadatos"/archivos-de-sistema/lspci.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Los buses y dispositivos del sistema no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Los buses y dispositivos del sistema han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/lspci.txt "$rutadatos"/archivos-de-sistema/lspci.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/fdisk.txt || ! -f $rutadatos/archivos-de-sistema/fdisk.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre los discos o las particiones del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/fdisk.txt "$rutadatos"/archivos-de-sistema/fdisk.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Los discos o las particiones del sistema no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Los discos o las particiones del sistema han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/fdisk.txt "$rutadatos"/archivos-de-sistema/fdisk.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/printenv.txt || ! -f $rutadatos/archivos-de-sistema/printenv.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las variables del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/printenv.txt "$rutadatos"/archivos-de-sistema/printenv.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Las variables del sistema no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Las variables del sistema han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/printenv.txt "$rutadatos"/archivos-de-sistema/printenv.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/selinuxconfig.txt || ! -f $rutadatos/archivos-de-sistema/selinuxconfig.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la configuración de selinux revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/selinuxconfig.txt "$rutadatos"/archivos-de-sistema/selinuxconfig.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] La configuración de selinux no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] La configuración de selinux ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/selinuxconfig.txt "$rutadatos"/archivos-de-sistema/selinuxconfig.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/selinuxsemanage.txt || ! -f $rutadatos/archivos-de-sistema/selinuxsemanage.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la configuración de las políticas de selinux, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/selinuxsemanage.txt "$rutadatos"/archivos-de-sistema/selinuxsemanage.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] La configuración de las políticas de selinux no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] La configuración de las políticas de selinux han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/selinuxsemanage.txt "$rutadatos"/archivos-de-sistema/selinuxsemanage.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/selinuxstatus.txt || ! -f $rutadatos/archivos-de-sistema/selinuxstatus.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo sestatus.conf, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/selinuxstatus.txt "$rutadatos"/archivos-de-sistema/selinuxstatus.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo sestatus.conf no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo sestatus.conf ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/selinuxstatus.txt "$rutadatos"/archivos-de-sistema/selinuxstatus.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/hosts_allow.txt || ! -f $rutadatos/archivos-de-sistema/hosts_allow.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo hosts.allow, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/hosts_allow.txt "$rutadatos"/archivos-de-sistema/hosts_allow.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo hosts.allow no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo hosts.allow ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/hosts_allow.txt "$rutadatos"/archivos-de-sistema/hosts_allow.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/hosts_deny.txt || ! -f $rutadatos/archivos-de-sistema/hosts_deny.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo hosts.deny, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/hosts_deny.txt "$rutadatos"/archivos-de-sistema/hosts_deny.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo hosts.deny no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo hosts.deny ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/hosts_deny.txt "$rutadatos"/archivos-de-sistema/hosts_deny.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/rsyslog.txt || ! -f $rutadatos/archivos-de-sistema/rsyslog.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo /proc/devices, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/rsyslog.txt "$rutadatos"/archivos-de-sistema/rsyslog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo /proc/devices no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo /proc/devices ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/rsyslog.txt "$rutadatos"/archivos-de-sistema/rsyslog.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/devices.txt || ! -f $rutadatos/archivos-de-sistema/devices.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo hosts.deny, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/devices.txt "$rutadatos"/archivos-de-sistema/devices.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo hosts.deny no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo hosts.deny ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/devices.txt "$rutadatos"/archivos-de-sistema/devices.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/machine_id.txt || ! -f $rutadatos/archivos-de-sistema/machine_id.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el ID de la máquina, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/machine_id.txt "$rutadatos"/archivos-de-sistema/machine_id.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El ID de la máquina no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El ID de la máquina ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/machine_id.txt "$rutadatos"/archivos-de-sistema/machine_id.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/product_uuid.txt || ! -f $rutadatos/archivos-de-sistema/product_uuid.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el product uuid de la máquina, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/product_uuid.txt "$rutadatos"/archivos-de-sistema/product_uuid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El product uuid de la máquina no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El product uuid de la máquina ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/product_uuid.txt "$rutadatos"/archivos-de-sistema/product_uuid.txt >> "$rutadatos"/reporte.txt
        fi
        
        if [[ ! -f $rutauno/archivos-de-sistema/resolv.txt || ! -f $rutadatos/archivos-de-sistema/resolv.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo resolv.conf, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/resolv.txt "$rutadatos"/archivos-de-sistema/resolv.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo resolv.conf no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo resolv.conf ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/resolv.txt "$rutadatos"/archivos-de-sistema/resolv.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de archivos de sistemas completadas"
        echo ""
	fi


	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/red || ! -d $rutadatos/red ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los archivos de configuraciones de red"
		echo ""
	else
		# Inicio de las comparaciones de archivos de configuraciones de red
        echo "${white}[${red}*${white}]${lightblue} Analizando los archivos de configuraciones de red..."

        if [[ ! -f $rutauno/red/nmcli.txt || ! -f $rutadatos/red/nmcli.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la configuración de red, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/nmcli.txt "$rutadatos"/red/nmcli.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de red" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de red" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/nmcli.txt "$rutadatos"/red/nmcli.txt >> "$rutadatos"/reporte.txt
        fi
        
        if [[ ! -f $rutauno/red/netstat.txt || ! -f $rutadatos/red/netstat.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las conexiones establecidas del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/netstat.txt "$rutadatos"/red/netstat.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en las conexiones establecidas del sistema" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en las conexiones establecidas del sistema" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/netstat.txt "$rutadatos"/red/netstat.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/red/dig.txt || ! -f $rutadatos/red/dig.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las peticiones DNS, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/dig.txt "$rutadatos"/red/dig.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en las peticiones DNS" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en las peticiones DNS" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/dig.txt "$rutadatos"/red/dig.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/red/route.txt || ! -f $rutadatos/red/route.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la tabla de enrutamiento, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/route.txt "$rutadatos"/red/route.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la tabla de enrutamiento" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la tabla de enrutamiento" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/route.txt "$rutadatos"/red/route.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/red/arp.txt || ! -f $rutadatos/red/arp.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la tabla ARP, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/arp.txt "$rutadatos"/red/arp.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la tabla ARP" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la tabla ARP" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/arp.txt "$rutadatos"/red/arp.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de red realiadas"
        echo ""
	fi
	
	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/servicios || ! -d $rutadatos/servicios ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los servicios de sistema"
		echo ""
	else
		# Inicio de las comparaciones de configuraciones de los servicios del sistema
        echo "${white}[${red}*${white}]${lightblue} Analizando las configuraciones de los servicios del sistema..."
        
        if [[ ! -f $rutauno/servicios/iptables.txt || ! -f $rutadatos/servicios/iptables.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre iptables, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/iptables.txt "$rutadatos"/servicios/iptables.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de iptables" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de iptables" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/iptables.txt "$rutadatos"/servicios/iptables.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/firewalld.txt || ! -f $rutadatos/servicios/firewalld.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre firewalld, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/firewalld.txt "$rutadatos"/servicios/firewalld.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de firewalld" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de firewalld" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/firewalld.txt "$rutadatos"/servicios/firewalld.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/ufw.txt || ! -f $rutadatos/servicios/ufw.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre ufw, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/ufw.txt "$rutadatos"/servicios/ufw.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de ufw" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de ufw" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/ufw.txt "$rutadatos"/servicios/ufw.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/dhcp.txt || ! -f $rutadatos/servicios/dhcp.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio DHCP, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/dhcp.txt "$rutadatos"/servicios/dhcp.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio DHCP" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio DHCP" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/dhcp.txt "$rutadatos"/servicios/dhcp.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/dns.txt || ! -f $rutadatos/servicios/dns.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio DNS, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/dns.txt "$rutadatos"/servicios/dns.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio DNS" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio DNS" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/dns.txt "$rutadatos"/servicios/dns.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/vsftpd.txt || ! -f $rutadatos/servicios/vsftpd.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio vsftpd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/vsftpd.txt "$rutadatos"/servicios/vsftpd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio vsftpd" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio vsftpd" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/vsftpd.txt "$rutadatos"/servicios/vsftpd.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/samba.txt || ! -f $rutadatos/servicios/samba.txt ]]
        then
            echo "[?] No se ha podido analizar la información el servicio samba, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/samba.txt "$rutadatos"/servicios/samba.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio samba" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio samba" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/samba.txt "$rutadatos"/servicios/samba.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/apache.txt || ! -f $rutadatos/servicios/apache.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio apache, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/apache.txt "$rutadatos"/servicios/apache.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio apache" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio apache" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/apache.txt "$rutadatos"/servicios/apache.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/mariadb.txt || ! -f $rutadatos/servicios/mariadb.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio mariadb, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/mariadb.txt "$rutadatos"/servicios/mariadb.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio mariadb" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio mariadb" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/mariadb.txt "$rutadatos"/servicios/mariadb.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/squid.txt || ! -f $rutadatos/servicios/squid.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre del servicio squid, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/squid.txt "$rutadatos"/servicios/squid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio squid" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio squid" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/squid.txt "$rutadatos"/servicios/squid.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/ssh.txt || ! -f $rutadatos/servicios/ssh.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio SSH, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/ssh.txt "$rutadatos"/servicios/ssh.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio SSH" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio SSH" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/ssh.txt "$rutadatos"/servicios/ssh.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/php.txt || ! -f $rutadatos/servicios/php.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre PHP, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/php.txt "$rutadatos"/servicios/php.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de PHP" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de PHP" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/php.txt "$rutadatos"/servicios/php.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de los servicios del sistema realiadas"
        echo ""
	fi
	
	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/logs-sistema || ! -d $rutadatos/logs-sistema ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los logs del sistema"
		echo ""
	else
		# Iniciando comparaciones de los logs del sistema
        echo "${white}[${red}*${white}]${lightblue} Analizando los archivos de los logs del sistema..."

        if [[ ! -f $rutauno/logs-sistema/auth/logfile_auth_log.txt || ! -f $rutadatos/logs-sistema/auth/logfile_auth_log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_auth_log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/auth/logfile_auth_log.txt "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_auth_log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_auth_log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/auth/logfile_auth_log.txt "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-sistema/dpkg/logfile_dpkg_log.txt || ! -f $rutadatos/logs-sistema/dpkg/logfile_dpkg_log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_dpkg_log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/dpkg/logfile_dpkg_log.txt "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_dpkg_log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_dpkg:log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/dpkg/logfile_dpkg_log.txt "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-sistema/syslog/logfile_syslog.txt || ! -f $rutadatos/logs-sistema/syslog/logfile_syslog.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_syslog, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/syslog/logfile_syslog.txt "$rutadatos"/logs-sistema/syslog/logfile_syslog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_syslog" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_syslog" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/syslog/logfile_syslog.txt "$rutadatos"/logs-sistema/syslog/logfile_syslog.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-sistema/boot/logfile_boot_log.txt || ! -f $rutadatos/logs-sistema/boot/logfile_boot_log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_boot_log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/boot/logfile_boot_log.txt "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_boot_log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_boot_log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/boot/logfile_boot_log.txt "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-sistema/kern/logfile_kern_log.txt || ! -f $rutadatos/logs-sistema/kern/logfile_kern_log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_kern_log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/kern/logfile_kern_log.txt "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_kern_log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_kern_log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/kern/logfile_kern_log.txt "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt >> "$rutadatos"/reporte.txt
        fi
        
        if [[ ! -f $rutauno/logs-sistema/lastlog/logfile_lastlog.txt || ! -f $rutadatos/logs-sistema/lastlog/logfile_lastlog.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_lastlog, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/lastlog/logfile_lastlog.txt "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_lastlog" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_lastlog" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/lastlog/logfile_lastlog.txt "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de los logs de sistema realiadas"
        echo ""
	fi

	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/logs-servicios || ! -d $rutadatos/logs-servicios ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los logs de los servicios"
		echo ""
	else
		# Iniciando comparaciones de los logs de los servicios
        echo "${white}[${red}*${white}]${lightblue} Analizando los archivos de los logs de los servicios del sistema..."

        if [[ ! -f $rutauno/logs-servicios/firewalld.txt || ! -f $rutadatos/logs-servicios/firewalld.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre firewalld, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/firewalld.txt "$rutadatos"/logs-servicios/firewalld.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en firewalld" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en firewalld" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/firewalld.txt "$rutadatos"/logs-servicios/firewalld.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/ufw/logfile_ufw.txt || ! -f $rutadatos/logs-servicios/ufw/logfile_ufw.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_ufw, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/ufw/logfile_ufw.txt "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_ufw" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_ufw" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/ufw/logfile_ufw.txt "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/vsftpd.txt || ! -f $rutadatos/logs-servicios/vsftpd.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre vsftpd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/vsftpd.txt "$rutadatos"/logs-servicios/vsftpd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en vsftpd" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en vsftpd" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/vsftpd.txt "$rutadatos"/logs-servicios/vsftpd.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/samba/logfile_log.smbd.txt || ! -f $rutadatos/logs-servicios/samba/logfile_log.smbd.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_log.smbd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/samba/logfile_log.smbd.txt "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_log.smbd" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_log.smbd" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/samba/logfile_log.smbd.txt "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/samba/logfile_log.nmbd.txt || ! -f $rutadatos/logs-servicios/samba/logfile_log.nmbd.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_log.nmbd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/samba/logfile_log.nmbd.txt "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_log.nmbd" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_log.nmbd" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/samba/logfile_log.nmbd.txt "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/apache2/logfile_error.log.txt || ! -f $rutadatos/logs-servicios/apache2/logfile_error.log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_error.log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/apache2/logfile_error.log.txt "$rutadatos"/logs-servicios/apache2/logfile_error.log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_error.log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_error.log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/apache2/logfile_error.log.txt "$rutadatos"/logs-servicios/apache2/logfile_error.log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/apache2/logfile_access.log.txt || ! -f $rutadatos/logs-servicios/apache2/logfile_access.log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_access.log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/apache2/logfile_access.log.txt "$rutadatos"/logs-servicios/apache2/logfile_access.log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_access.log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_access.log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/apache2/logfile_access.log.txt "$rutadatos"/logs-servicios/apache2/logfile_access.log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/mariadb.txt || ! -f $rutadatos/logs-servicios/mariadb.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre mariadb, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/mariadb.txt "$rutadatos"/logs-servicios/mariadb.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en mariadb" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en mariadb" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/mariadb.txt "$rutadatos"/logs-servicios/mariadb.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/access.txt || ! -f $rutadatos/logs-servicios/access.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre access, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/access.txt "$rutadatos"/logs-servicios/access.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en access" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en access" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/access.txt "$rutadatos"/logs-servicios/access.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/cache.txt || ! -f $rutadatos/logs-servicios/cache.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre cache, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/cache.txt "$rutadatos"/logs-servicios/cache.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en cache" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en cache" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/cache.txt "$rutadatos"/logs-servicios/cache.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de los logs de los servicios del sistema realiadas"
        echo ""
	fi

}

function comparacionCentOS (){
    # Inicio de las comparaciones de archivos recogidos para realizar el reporte del análisis
	touch "$rutadatos"/reporte.txt
	date +"Reporte realizado el %d/%m/%Y - %T" >> log.txt
	date +"Reporte realizado el %d/%m/%Y - %T" >> "$rutadatos"/reporte.txt
	echo "" >> "$rutadatos"/reporte.txt
    echo ""
	echo "${white}[${red}*${white}]${lightblue} Iniciando comparaciones de archivos..."

	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/archivos-de-sistema || ! -d $rutadatos/archivos-de-sistema ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los archivos de sistema"
		echo ""
	else
		# Inicio de las comparaciones de archivos de sistema
		echo "${white}[${red}*${white}]${lightblue} Analizando los archivos del sistema..."
		
		if [[ ! -f $rutauno/archivos-de-sistema/kernelfirma.txt || ! -f $rutadatos/archivos-de-sistema/kernelfirma.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el kernel, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/kernelfirma.txt "$rutadatos"/archivos-de-sistema/kernelfirma.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El kernel no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El kernel ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/kernelfirma.txt "$rutadatos"/archivos-de-sistema/kernelfirma.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/sudoersfirma.txt || ! -f $rutadatos/archivos-de-sistema/sudoersfirma.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo sudoers, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/sudoersfirma.txt "$rutadatos"/archivos-de-sistema/sudoersfirma.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo sudoers no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo sudoers ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/sudoers.txt "$rutadatos"/archivos-de-sistema/sudoers.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/shadowfirma.txt || ! -f $rutadatos/archivos-de-sistema/shadowfirma.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo shadow, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/shadowfirma.txt "$rutadatos"/archivos-de-sistema/shadowfirma.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo shadow no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo shadow ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/shadow.txt "$rutadatos"/archivos-de-sistema/shadow.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/passwdfirma.txt || ! -f $rutadatos/archivos-de-sistema/passwdfirma.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo passwd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/passwdfirma.txt "$rutadatos"/archivos-de-sistema/passwdfirma.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo passwd no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo passwd ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/passwdfirma.txt "$rutadatos"/archivos-de-sistema/passwdfirma.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/root_bash_history.txt || ! -f $rutadatos/archivos-de-sistema/root_bash_history.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo bash history, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/root_bash_history.txt "$rutadatos"/archivos-de-sistema/root_bash_history.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El bash history no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El bash history ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/root_bash_history.txt "$rutadatos"/archivos-de-sistema/root_bash_history.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/dpkg.txt || ! -f $rutadatos/archivos-de-sistema/dpkg.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo dpkg, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/dpkg.txt "$rutadatos"/archivos-de-sistema/dpkg.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se detectan paquetes nuevos/eliminados" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado paquetes nuevos/eliminados" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/dpkg.txt "$rutadatos"/archivos-de-sistema/dpkg.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/crontab.txt || ! -f $rutadatos/archivos-de-sistema/crontab.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo crontab, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/crontab.txt "$rutadatos"/archivos-de-sistema/crontab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo crontab no ha sido modificada" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo crontab ha sido modificada" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/crontab.txt "$rutadatos"/archivos-de-sistema/crontab.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/crontabl.txt || ! -f $rutadatos/archivos-de-sistema/crontabl.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las tablas de tareas cron, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/crontabl.txt "$rutadatos"/archivos-de-sistema/crontabl.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Las tablas de tareas cron no han sido modificada" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Las tablas de tareas cron han sido modificada" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/crontabl.txt "$rutadatos"/archivos-de-sistema/crontabl.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/grub.txt || ! -f $rutadatos/archivos-de-sistema/grub.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el GRUB, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/grub.txt "$rutadatos"/archivos-de-sistema/grub.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El GRUB no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El GRUB ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/grub.txt "$rutadatos"/archivos-de-sistema/grub.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/interfaces.txt || ! -f $rutadatos/archivos-de-sistema/interfaces.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo interfaces, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/interfaces.txt "$rutadatos"/archivos-de-sistema/interfaces.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo interfaces no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo interfaces ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/interfaces.txt "$rutadatos"/archivos-de-sistema/interfaces.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/profile.txt || ! -f $rutadatos/archivos-de-sistema/profile.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo profile, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/profile.txt "$rutadatos"/archivos-de-sistema/profile.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo profile no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo profile ha sido modificado" >> "$rutadatos"/reporte.txt
            diff
            "$rutauno"/archivos-de-sistema/profile.txt "$rutadatos"/archivos-de-sistema/profile.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/hosts.txt || ! -f $rutadatos/archivos-de-sistema/hosts.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo hosts, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/hosts.txt "$rutadatos"/archivos-de-sistema/hosts.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo hosts no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo hosts ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/hosts.txt "$rutadatos"/archivos-de-sistema/hosts.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/fstab.txt || ! -f $rutadatos/archivos-de-sistema/fstab.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo fstab, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/fstab.txt "$rutadatos"/archivos-de-sistema/fstab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo fstab no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo fstab ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/fstab.txt "$rutadatos"/archivos-de-sistema/fstab.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/mtab.txt || ! -f $rutadatos/archivos-de-sistema/mtab.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo mtab, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/mtab.txt "$rutadatos"/archivos-de-sistema/mtab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo mtab no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo mtab ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/mtab.txt "$rutadatos"/archivos-de-sistema/mtab.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/group.txt || ! -f $rutadatos/archivos-de-sistema/group.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo group, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/group.txt "$rutadatos"/archivos-de-sistema/group.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo group no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo group ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/group.txt "$rutadatos"/archivos-de-sistema/group.txt >> "$rutadatos"/reporte.txt
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/rc.d/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/rc.d/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/rc.d/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                ruta3=$(ls "$rutauno"/archivos-de-sistema/rc.d/"$i")
                for x in $ruta3
                do
                    if [[ ! -f $rutauno/archivos-de-sistema/rc.d/$i/$x || ! -f $rutadatos/archivos-de-sistema/rc.d/$i/$x ]]
                    then
                        echo "[?] No se ha podido analizar la información sobre el archivo $i/$x, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                    elif [[ $(cmp "$rutauno"/archivos-de-sistema/rc.d/"$i"/"$x" "$rutadatos"/archivos-de-sistema/rc.d/"$i"/"$x") == "" ]] >> log.txt 2>&1
                    then
                        echo "[*] El archivo $i/$x no ha sido modificado" >> "$rutadatos"/reporte.txt
                    else
                        echo "[!] El archivo $i/$x ha sido modificado" >> "$rutadatos"/reporte.txt
                        diff "$rutauno"/archivos-de-sistema/rc.d/"$i"/"$x" "$rutadatos"/archivos-de-sistema/rc.d/"$i"/"$x" >> "$rutadatos"/reporte.txt
                    fi
                done
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/init.d/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/init.d/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/init.d/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/init.d/$i || ! -f $rutadatos/archivos-de-sistema/init.d/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo init.d/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/init.d/"$i" "$rutadatos"/archivos-de-sistema/init.d/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo init.d/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo init.d/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/init.d/"$i" "$rutadatos"/archivos-de-sistema/init.d/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.d/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.d/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.d/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.d/$i || ! -f $rutadatos/archivos-de-sistema/cron.d/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.d/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.d/"$i" "$rutadatos"/archivos-de-sistema/cron.d/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.d/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.d/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.d/"$i" "$rutadatos"/archivos-de-sistema/cron.d/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.hourly/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.hourly/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.hourly/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.hourly/$i || ! -f $rutadatos/archivos-de-sistema/cron.hourly/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.hourly/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.hourly/"$i" "$rutadatos"/archivos-de-sistema/cron.hourly/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.hourly/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.hourly/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.hourly/"$i" "$rutadatos"/archivos-de-sistema/cron.hourly/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.dialy/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.dialy/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.dialy/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.dialy/$i || ! -f $rutadatos/archivos-de-sistema/cron.dialy/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.dialy/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.dialy/"$i" "$rutadatos"/archivos-de-sistema/cron.dialy/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.dialy/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.dialy/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.dialy/"$i" "$rutadatos"/archivos-de-sistema/cron.dialy/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.weekely/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.weekely/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.weekely/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.weekely/$i || ! -f $rutadatos/archivos-de-sistema/cron.weekely/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.weekely/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.weekely/"$i" "$rutadatos"/archivos-de-sistema/cron.weekely/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.weekely/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.weekely/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.weekely/"$i" "$rutadatos"/archivos-de-sistema/cron.weekely/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        ruta1=$(ls "$rutauno"/archivos-de-sistema/cron.monthly/)
        ruta2=$(ls "$rutadatos"/archivos-de-sistema/cron.monthly/)
        if [ "$(echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] Se ha detectado distintos archivos dentro de archivos-de-sistema/cron.monthly/" >> "$rutadatos"/reporte.txt
            echo "${ruta1[@]}" "${ruta2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/reporte.txt
        else
            for i in $ruta1
            do
                if [[ ! -f $rutauno/archivos-de-sistema/cron.monthly/$i || ! -f $rutadatos/archivos-de-sistema/cron.monthly/$i ]]
                then
                    echo "[?] No se ha podido analizar la información sobre el archivo cron.monthly/$i, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
                elif [[ $(cmp "$rutauno"/archivos-de-sistema/cron.monthly/"$i" "$rutadatos"/archivos-de-sistema/cron.monthly/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] El archivo cron.monthly/$i no ha sido modificado" >> "$rutadatos"/reporte.txt
                else
                    echo "[!] El archivo cron.monthly/$i ha sido modificado" >> "$rutadatos"/reporte.txt
                    diff "$rutauno"/archivos-de-sistema/cron.monthly/"$i" "$rutadatos"/archivos-de-sistema/cron.monthly/"$i" >> "$rutadatos"/reporte.txt
                fi
            done
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/cmdline.txt || ! -f $rutadatos/archivos-de-sistema/cmdline.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo cmdline, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/cmdline.txt "$rutadatos"/archivos-de-sistema/cmdline.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo cmdline no ha sido modificado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo cmdline ha sido modificado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/cmdline.txt "$rutadatos"/archivos-de-sistema/cmdline.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/blkid.txt || ! -f $rutadatos/archivos-de-sistema/blkid.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las particiones del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/blkid.txt "$rutadatos"/archivos-de-sistema/blkid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Las particiones del sistema no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Las particiones del sistema han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/blkid.txt "$rutadatos"/archivos-de-sistema/blkid.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/lastlog.txt || ! -f $rutadatos/archivos-de-sistema/lastlog.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el lastlog, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/lastlog.txt "$rutadatos"/archivos-de-sistema/lastlog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se ha detectado un login nuevo desde la última vez" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se ha detectado un login nuevo desde la última vez" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/lastlog.txt "$rutadatos"/archivos-de-sistema/lastlog.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/runlevel.txt || ! -f $rutadatos/archivos-de-sistema/runlevel.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el modo de operación del sistema operativo, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/runlevel.txt "$rutadatos"/archivos-de-sistema/runlevel.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El modo de operación del sistema operativo no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El modo de operación del sistema operativo ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/runlevel.txt "$rutadatos"/archivos-de-sistema/runlevel.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/lspci.txt || ! -f $rutadatos/archivos-de-sistema/lspci.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre sobre los buses y dispositivos del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/lspci.txt "$rutadatos"/archivos-de-sistema/lspci.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Los buses y dispositivos del sistema no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Los buses y dispositivos del sistema han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/lspci.txt "$rutadatos"/archivos-de-sistema/lspci.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/fdisk.txt || ! -f $rutadatos/archivos-de-sistema/fdisk.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre los discos o las particiones del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/fdisk.txt "$rutadatos"/archivos-de-sistema/fdisk.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Los discos o las particiones del sistema no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Los discos o las particiones del sistema han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/fdisk.txt "$rutadatos"/archivos-de-sistema/fdisk.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/printenv.txt || ! -f $rutadatos/archivos-de-sistema/printenv.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las variables del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/printenv.txt "$rutadatos"/archivos-de-sistema/printenv.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Las variables del sistema no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Las variables del sistema han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/printenv.txt "$rutadatos"/archivos-de-sistema/printenv.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/selinuxconfig.txt || ! -f $rutadatos/archivos-de-sistema/selinuxconfig.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la configuración de selinux revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/selinuxconfig.txt "$rutadatos"/archivos-de-sistema/selinuxconfig.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] La configuración de selinux no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] La configuración de selinux ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/selinuxconfig.txt "$rutadatos"/archivos-de-sistema/selinuxconfig.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/selinuxsemanage.txt || ! -f $rutadatos/archivos-de-sistema/selinuxsemanage.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la configuración de las políticas de selinux, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/selinuxsemanage.txt "$rutadatos"/archivos-de-sistema/selinuxsemanage.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] La configuración de las políticas de selinux no han cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] La configuración de las políticas de selinux han cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/selinuxsemanage.txt "$rutadatos"/archivos-de-sistema/selinuxsemanage.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/selinuxstatus.txt || ! -f $rutadatos/archivos-de-sistema/selinuxstatus.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo sestatus.conf, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/selinuxstatus.txt "$rutadatos"/archivos-de-sistema/selinuxstatus.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo sestatus.conf no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo sestatus.conf ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/selinuxstatus.txt "$rutadatos"/archivos-de-sistema/selinuxstatus.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/hosts_allow.txt || ! -f $rutadatos/archivos-de-sistema/hosts_allow.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo hosts.allow, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/hosts_allow.txt "$rutadatos"/archivos-de-sistema/hosts_allow.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo hosts.allow no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo hosts.allow ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/hosts_allow.txt "$rutadatos"/archivos-de-sistema/hosts_allow.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/hosts_deny.txt || ! -f $rutadatos/archivos-de-sistema/hosts_deny.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo hosts.deny, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/hosts_deny.txt "$rutadatos"/archivos-de-sistema/hosts_deny.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo hosts.deny no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo hosts.deny ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/hosts_deny.txt "$rutadatos"/archivos-de-sistema/hosts_deny.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/rsyslog.txt || ! -f $rutadatos/archivos-de-sistema/rsyslog.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo /proc/devices, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/rsyslog.txt "$rutadatos"/archivos-de-sistema/rsyslog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo /proc/devices no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo /proc/devices ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/rsyslog.txt "$rutadatos"/archivos-de-sistema/rsyslog.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/devices.txt || ! -f $rutadatos/archivos-de-sistema/devices.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo hosts.deny, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/devices.txt "$rutadatos"/archivos-de-sistema/devices.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo hosts.deny no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo hosts.deny ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/devices.txt "$rutadatos"/archivos-de-sistema/devices.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/machine_id.txt || ! -f $rutadatos/archivos-de-sistema/machine_id.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el ID de la máquina, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/machine_id.txt "$rutadatos"/archivos-de-sistema/machine_id.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El ID de la máquina no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El ID de la máquina ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/machine_id.txt "$rutadatos"/archivos-de-sistema/machine_id.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/product_uuid.txt || ! -f $rutadatos/archivos-de-sistema/product_uuid.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el product uuid de la máquina, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/product_uuid.txt "$rutadatos"/archivos-de-sistema/product_uuid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El product uuid de la máquina no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El product uuid de la máquina ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/product_uuid.txt "$rutadatos"/archivos-de-sistema/product_uuid.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/archivos-de-sistema/resolv.txt || ! -f $rutadatos/archivos-de-sistema/resolv.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el archivo resolv.conf, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/archivos-de-sistema/resolv.txt "$rutadatos"/archivos-de-sistema/resolv.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] El archivo resolv.conf no ha cambiado" >> "$rutadatos"/reporte.txt
        else
            echo "[!] El archivo resolv.conf ha cambiado" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/archivos-de-sistema/resolv.txt "$rutadatos"/archivos-de-sistema/resolv.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de archivos de sistemas completadas"
        echo ""

    fi
	

	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/red || ! -d $rutadatos/red ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los archivos de configuraciones de red"
		echo ""
	else
		    # Inicio de las comparaciones de archivos de configuraciones de red
        echo "${white}[${red}*${white}]${lightblue} Analizando los archivos de configuraciones de red..."

        if [[ ! -f $rutauno/red/nmcli.txt || ! -f $rutadatos/red/nmcli.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la configuración de red, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/nmcli.txt "$rutadatos"/red/nmcli.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de red" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de red" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/nmcli.txt "$rutadatos"/red/nmcli.txt >> "$rutadatos"/reporte.txt
        fi
        
        if [[ ! -f $rutauno/red/netstat.txt || ! -f $rutadatos/red/netstat.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las conexiones establecidas del sistema, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/netstat.txt "$rutadatos"/red/netstat.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en las conexiones establecidas del sistema" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en las conexiones establecidas del sistema" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/netstat.txt "$rutadatos"/red/netstat.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/red/dig.txt || ! -f $rutadatos/red/dig.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre las peticiones DNS, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/dig.txt "$rutadatos"/red/dig.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en las peticiones DNS" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en las peticiones DNS" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/dig.txt "$rutadatos"/red/dig.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/red/route.txt || ! -f $rutadatos/red/route.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la tabla de enrutamiento, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/route.txt "$rutadatos"/red/route.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la tabla de enrutamiento" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la tabla de enrutamiento" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/route.txt "$rutadatos"/red/route.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/red/arp.txt || ! -f $rutadatos/red/arp.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre la tabla ARP, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/red/arp.txt "$rutadatos"/red/arp.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la tabla ARP" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la tabla ARP" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/red/arp.txt "$rutadatos"/red/arp.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de red realiadas"
        echo ""
	fi

	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/servicios || ! -d $rutadatos/servicios ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los servicios de sistema"
		echo ""
	else
		    # Inicio de las comparaciones de configuraciones de los servicios del sistema
        echo "${white}[${red}*${white}]${lightblue} Analizando las configuraciones de los servicios del sistema..."
        
        if [[ ! -f $rutauno/servicios/iptables.txt || ! -f $rutadatos/servicios/iptables.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre iptables, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/iptables.txt "$rutadatos"/servicios/iptables.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de iptables" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de iptables" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/iptables.txt "$rutadatos"/servicios/iptables.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/firewalld.txt || ! -f $rutadatos/servicios/firewalld.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre firewalld, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/firewalld.txt "$rutadatos"/servicios/firewalld.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de firewalld" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de firewalld" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/firewalld.txt "$rutadatos"/servicios/firewalld.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/ufw.txt || ! -f $rutadatos/servicios/ufw.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre ufw, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/ufw.txt "$rutadatos"/servicios/ufw.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de ufw" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de ufw" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/ufw.txt "$rutadatos"/servicios/ufw.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/dhcp.txt || ! -f $rutadatos/servicios/dhcp.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio DHCP, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/dhcp.txt "$rutadatos"/servicios/dhcp.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio DHCP" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio DHCP" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/dhcp.txt "$rutadatos"/servicios/dhcp.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/dns.txt || ! -f $rutadatos/servicios/dns.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio DNS, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/dns.txt "$rutadatos"/servicios/dns.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio DNS" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio DNS" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/dns.txt "$rutadatos"/servicios/dns.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/vsftpd.txt || ! -f $rutadatos/servicios/vsftpd.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio vsftpd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/vsftpd.txt "$rutadatos"/servicios/vsftpd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio vsftpd" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio vsftpd" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/vsftpd.txt "$rutadatos"/servicios/vsftpd.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/samba.txt || ! -f $rutadatos/servicios/samba.txt ]]
        then
            echo "[?] No se ha podido analizar la información el servicio samba, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/samba.txt "$rutadatos"/servicios/samba.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio samba" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio samba" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/samba.txt "$rutadatos"/servicios/samba.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/apache.txt || ! -f $rutadatos/servicios/apache.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio apache, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/apache.txt "$rutadatos"/servicios/apache.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio apache" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio apache" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/apache.txt "$rutadatos"/servicios/apache.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/mariadb.txt || ! -f $rutadatos/servicios/mariadb.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio mariadb, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/mariadb.txt "$rutadatos"/servicios/mariadb.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio mariadb" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio mariadb" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/mariadb.txt "$rutadatos"/servicios/mariadb.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/squid.txt || ! -f $rutadatos/servicios/squid.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre del servicio squid, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/squid.txt "$rutadatos"/servicios/squid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio squid" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio squid" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/squid.txt "$rutadatos"/servicios/squid.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/ssh.txt || ! -f $rutadatos/servicios/ssh.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre el servicio SSH, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/ssh.txt "$rutadatos"/servicios/ssh.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración del servicio SSH" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración del servicio SSH" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/ssh.txt "$rutadatos"/servicios/ssh.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/servicios/php.txt || ! -f $rutadatos/servicios/php.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre PHP, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/servicios/php.txt "$rutadatos"/servicios/php.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en la configuración de PHP" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en la configuración de PHP" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/servicios/php.txt "$rutadatos"/servicios/php.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de los servicios del sistema realiadas"
        echo ""
	fi


	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/logs-sistema || ! -d $rutadatos/logs-sistema ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los logs del sistema"
		echo ""
	else
		# Iniciando comparaciones de los logs del sistema
        echo "${white}[${red}*${white}]${lightblue} Analizando los archivos de los logs del sistema..."

        if [[ ! -f $rutauno/logs-sistema/auth/logfile_auth_log.txt || ! -f $rutadatos/logs-sistema/auth/logfile_auth_log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_auth_log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/auth/logfile_auth_log.txt "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_auth_log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_auth_log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/auth/logfile_auth_log.txt "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-sistema/dpkg/logfile_dpkg_log.txt || ! -f $rutadatos/logs-sistema/dpkg/logfile_dpkg_log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_dpkg_log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/dpkg/logfile_dpkg_log.txt "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_dpkg_log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_dpkg:log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/dpkg/logfile_dpkg_log.txt "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt >> "$rutadatos"/reporte.txt
        fi
        
        if [[ ! -f $rutauno/logs-sistema/messages/logfile_messages.txt || ! -f $rutadatos/logs-sistema/messages/logfile_messages.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_messages, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/messages/logfile_messages.txt "$rutadatos"/logs-sistema/messages/logfile_messages.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_messages" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_messages" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/messages/logfile_messages.txt "$rutadatos"/logs-sistema/messages/logfile_messages.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-sistema/boot/logfile_boot_log.txt || ! -f $rutadatos/logs-sistema/boot/logfile_boot_log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_boot_log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/boot/logfile_boot_log.txt "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_boot_log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_boot_log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/boot/logfile_boot_log.txt "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-sistema/kern/logfile_kern_log.txt || ! -f $rutadatos/logs-sistema/kern/logfile_kern_log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_kern_log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/kern/logfile_kern_log.txt "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_kern_log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_kern_log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/kern/logfile_kern_log.txt "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-sistema/lastlog/logfile_lastlog.txt || ! -f $rutadatos/logs-sistema/lastlog/logfile_lastlog.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_lastlog, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-sistema/lastlog/logfile_lastlog.txt "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_lastlog" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_lastlog" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-sistema/lastlog/logfile_lastlog.txt "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de los logs de sistema realiadas"
        echo ""
	fi


	# Comprueba si las dos carpetas existen. Si existen, empieza a comparar archivos
	if [[ ! -d $rutauno/logs-servicios || ! -d $rutadatos/logs-servicios ]]
	then
		echo "${white}[${red}!${white}]${lightblue} No se pueden comparar los logs de los servicios"
		echo ""
	else
		    # Iniciando comparaciones de los logs de los servicios
        echo "${white}[${red}*${white}]${lightblue} Analizando los archivos de los logs de los servicios del sistema..."

        if [[ ! -f $rutauno/logs-servicios/firewalld.txt || ! -f $rutadatos/logs-servicios/firewalld.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre firewalld, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/firewalld.txt "$rutadatos"/logs-servicios/firewalld.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en firewalld" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en firewalld" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/firewalld.txt "$rutadatos"/logs-servicios/firewalld.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/ufw/logfile_ufw.txt || ! -f $rutadatos/logs-servicios/ufw/logfile_ufw.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_ufw, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/ufw/logfile_ufw.txt "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_ufw" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_ufw" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/ufw/logfile_ufw.txt "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/vsftpd.txt || ! -f $rutadatos/logs-servicios/vsftpd.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre vsftpd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/vsftpd.txt "$rutadatos"/logs-servicios/vsftpd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en vsftpd" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en vsftpd" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/vsftpd.txt "$rutadatos"/logs-servicios/vsftpd.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/samba/logfile_log.smbd.txt || ! -f $rutadatos/logs-servicios/samba/logfile_log.smbd.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_log.smbd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/samba/logfile_log.smbd.txt "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_log.smbd" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_log.smbd" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/samba/logfile_log.smbd.txt "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/samba/logfile_log.nmbd.txt || ! -f $rutadatos/logs-servicios/samba/logfile_log.nmbd.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_log.nmbd, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/samba/logfile_log.nmbd.txt "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_log.nmbd" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_log.nmbd" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/samba/logfile_log.nmbd.txt "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/httpd/logfile_error.log.txt || ! -f $rutadatos/logs-servicios/httpd/logfile_error.log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_error.log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/httpd/logfile_error.log.txt "$rutadatos"/logs-servicios/httpd/logfile_error.log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_error.log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_error.log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/httpd/logfile_error.log.txt "$rutadatos"/logs-servicios/httpd/logfile_error.log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/httpd/logfile_access.log.txt || ! -f $rutadatos/logs-servicios/httpd/logfile_access.log.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre logfile_access.log, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/httpd/logfile_access.log.txt "$rutadatos"/logs-servicios/httpd/logfile_access.log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en logfile_access.log" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en logfile_access.log" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/httpd/logfile_access.log.txt "$rutadatos"/logs-servicios/httpd/logfile_access.log.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/mariadb.txt || ! -f $rutadatos/logs-servicios/mariadb.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre mariadb, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/mariadb.txt "$rutadatos"/logs-servicios/mariadb.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en mariadb" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en mariadb" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/mariadb.txt "$rutadatos"/logs-servicios/mariadb.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/access.txt || ! -f $rutadatos/logs-servicios/access.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre access, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/access.txt "$rutadatos"/logs-servicios/access.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en access" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en access" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/access.txt "$rutadatos"/logs-servicios/access.txt >> "$rutadatos"/reporte.txt
        fi

        if [[ ! -f $rutauno/logs-servicios/cache.txt || ! -f $rutadatos/logs-servicios/cache.txt ]]
        then
            echo "[?] No se ha podido analizar la información sobre cache, revise el log de la herramienta" >> "$rutadatos"/reporte.txt
        elif [[ $(cmp "$rutauno"/logs-servicios/cache.txt "$rutadatos"/logs-servicios/cache.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] No se han detectado cambios en cache" >> "$rutadatos"/reporte.txt
        else
            echo "[!] Se han detectado cambios en cache" >> "$rutadatos"/reporte.txt
            diff "$rutauno"/logs-servicios/cache.txt "$rutadatos"/logs-servicios/cache.txt >> "$rutadatos"/reporte.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Comparaciones de los logs de los servicios del sistema realiadas"
        echo ""
	fi

}

function comprobarcomparacion (){
	if [[ ! -f $rutauno/analisis.txt || ! -f $rutadatos/analisis.txt ]]
	then
		while true
		do
			read -r -p "${lightblue}No se ha detectado el archivo analisis.txt en alguna de las rutas especificadas. No se podrá comprobar si se puede hacer una comparacion de evidencias de forma segura. ¿Quieres continuar?${green} [S/N]${white} " comprobaranalisis
			if [[ $comprobar == "S" ]] || [[ $comprobar == "s" ]]
			then
				while true
				do
					read -r -p "${lightblue}¿Cuál es el sistema operativo de las evidencias que quieres comparar?${green} [Debain/Ubuntu/CentOS/Kali]${white} " comprobaranalisis
					case $comprobaranalisis in
					Debian | debian | Ubuntu | ubuntu | Kali | kali)
						comparacion_so="Debian"
					;;
					CentOS | Centos | centos)
						comparacion_so="CentOS"
					;;
					*)
						continue
					esac
					break
				done

				comparacion$comparacion_so

			elif [[ $comprobar == "N" ]] || [[ $comprobar == "n" ]]
			then
				exit
			else
				continue
			fi
			break
		done
	else
		if [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') ]]
		then
			while true
			do
				read -r -p "${lightblue}Se han detectado sistemas operativos distintos${green} ("$(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }')" / "$(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }')").${lightblue} Comprueba que quieres comparar las evidencias correctas. ¿Quieres continuar?${green} [S/N]${white} " comprobaranalisis
				if [[ $comprobaranalisis == "S" ]] || [[ $comprobaranalisis == "s" ]]
				then
					while true
					do
						read -r -p "${lightblue}¿Cuál es el sistema operativo de las evidencias que quieres comparar?${green} [Debain/Ubuntu/CentOS/Kali]${white} " comprobaranalisis
						case $comprobaranalisis in
						Debian | debian | Ubuntu | ubuntu | Kali | kali)
							comparacion_so="Debian"
						;;
						CentOS | Centos | centos)
							comparacion_so="CentOS"
						;;
						*)
							continue
						esac
						break
					done
					break
				elif [[ $comprobaranalisis == "N" ]] || [[ $comprobaranalisis == "n" ]]
				then
					exit
				else
					continue
				fi
				break
			done
		fi

		if [[ $(sed '8q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Version de Linuxs Doctor: /,""); print }') != $(sed '8q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Version de Linux Doctor: /,""); print }') ]]
		then
			while true
			do
				read -r -p "${lightblue} Se han detectado distintas versiones de Linux's Doctor${green} ("$(sed '8q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Version de Linux Doctor: /,""); print }')" / "$(sed '8q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Version de Linux Doctor: /,""); print }')").${lightblue} Esto puede hacer que no se realicen todas las comparaciones esperadas. ¿Quieres continuar?${green} [S/N]${white} " comprobaranalisis
				if [[ $comprobaranalisis == "S" ]] || [[ $comprobaranalisis == "s" ]]
				then
					break
				elif [[ $comprobaranalisis == "N" ]] || [[ $comprobaranalisis == "n" ]]
				then
					exit
				else
					continue
				fi
				break
			done
		fi

		if [[ -z $comparacion_so ]]
        then
			if [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Kali" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Kali" ]]
			then
				while true
				do
					read -r -p "${lightblue}Se ha detectado un sistema operativo NO SOPORTADO${green} ("$(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }')").${lightblue} ¿Quieres continuar?${green} [S/N]${white} " comprobaranalisis
					if [[ $comprobaranalisis == "S" ]] || [[ $comprobaranalisis == "s" ]]
					then
						break
					elif [[ $comprobaranalisis == "N" ]] || [[ $comprobaranalisis == "n" ]]
					then
						exit
					else
						continue
					fi
					break
				done
			fi

			if [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]]
			then
				comparacion_so="Debian"
			else
				comparacion_so="CentOS"
			fi

			comparacion$comparacion_so

		fi
	fi
}
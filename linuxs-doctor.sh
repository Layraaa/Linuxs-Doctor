#!/bin/bash
# Linux's Doctor: Creado por @Layraa y @Japinper
# 
# linuxs-doctor-new.sh - terminal version
# Script que realiza las mismas funciones que linuxs-doctor.sh,
# pero preparado para ser ejecutado en modo terminal

# Define los colores
red="$(tput setaf 1)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"
white="$(tput setaf 7)"
lightblue="$(tput setaf 117)"
purple="$(tput setaf 135)"

# Si no existe log.txt, lo crea
if [ ! -f log.txt ]
then
	touch log.txt
fi

# Si el usuario no tiene permisos de administrador, no puede ejecutar el script
if [[ $EUID != 0 ]]
then
	echo " _     _                           ____             _             "
	echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
	echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
	echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
	echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
	echo ""
	echo "Creado por ${green}@Layraaa y @Japinper ${white}| ${blue}v1.1.1${white}"
	echo "https://github.com/Layraaa/Linuxs-Doctor"
	echo ""
	echo "${white}[${red}*${white}] ${lightblue}Debes tener permisos de administrador para ejecutar el instalador${white}"
	date +"Ejecución de linuxs-doctor.sh sin permisos de administrador realizada el %d/%m/%Y - %T" >> log.txt
	exit
fi

echo " _     _                           ____             _             "
echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
echo ""
echo "Creado por ${green}@Layraaa y @Japinper ${white}| ${blue}v1.1.1${white}"
echo "https://github.com/Layraaa/Linuxs-Doctor"
echo ""

# Comprueba si falta alguna archivo para que el script funcione correctamente
if [ ! -f analisis.sh ]
then
	echo "${red}No se encuentra el archivo analisis.sh ${white}"
	date+ "Ejecución de linuxs-doctor.sh fallida al no encontrar el archivo analisis.sh el %d/%m/%Y - %T" >> log.txt
	exit
fi

if [ ! -f comparacion.sh ]
then
	echo "${red}No se encuentra el archivo comparacion.sh ${white}"
	date+ "Ejecución de linuxs-doctor.sh fallida al no encontrar el archivo comparacion.sh el %d/%m/%Y - %T" >> log.txt
	exit
fi

if [ ! -f enviarreporte.sh ]
then
	echo "${red}No se encuentra el archivo enviarreporte.sh ${white}"
	date+ "Ejecución de linuxs-doctor.sh fallida al no encontrar el archivo enviarreporte.sh el %d/%m/%Y - %T" >> log.txt
	exit
fi

if [ ! -f file.conf ]
then
    echo "${red}No se encuentra el archivo file.conf ${white}"
	date+ "Ejecución de linuxs-doctor-cron.sh fallida al no encontrar el archivo file.conf el %d/%m/%Y - %T" >> log.txt
	exit
fi

# Incluye el archivo de configuracion
source file.conf

# Funcion que contiene el mensaje de ayuda
function ayuda (){
	echo "Ayuda

bash linuxs-doctor.sh [-l classic]
bash linuxs-doctor.sh [-l terminal] [-m] [-r] [-e] [-x] [-u] [-p] [-s] [-t]
bash linuxs-doctor.sh [-h help|info]

-l (classic/terminal)	Inicia Linux's Doctor en el modo indicado
-m (1/2/3)		Ejecuta la acción que indiques
	1		Recoge información del sistema
	2		Recoge información del sistema y la compara con un reporte
			anterior
	3		Compara dos carpetas con evidencias
-r			Indica la ruta donde quieres generar un reporte. En el caso
			que quieras realizar comparaciones, tendrás que indicar el
			último reporte generado
-e			Indica la ruta del primer reporte generado (solo para comparaciones)
-x (FTP/Telegram)	Indica a que medios externos enviar las evidencias generadas
			(Solo tienes que indicar el medio si los datos estan configurados correctamente)
-u			Usuario del servidor FTP
-p			Contraseña del servidor FTP
-s			IP/Dirección del servidor FTP
-t			ID de Telegram del usuario que recibirá las evidencias
-h (help/info)		Mostrar ayuda
	help	Muestra ayuda del uso de la herramineta
	info	Muestra información de la herramienta"
	echo ""
}

# Lee los parametros pasados por terminal
while getopts ":l:m:r:e:x:u:p:s:t:h:" option
do
   case $option in
	l)	# Modo de inicialización de Linux's Doctor
		linuxsdoctor=$OPTARG
		if [[ $linuxsdoctor != "classic" && $linuxsdoctor != "terminal" ]]
		then
			echo "Parámetro incorrecto: -l $linuxsdoctor"
			echo "bash linuxs-doctor.sh -l classic|terminal"
			exit
		fi
	;;
    m) 	# Opción a realizar
        menu=$OPTARG
		if [[ $menu != "1" ]] && [[ $menu != "2" ]] && [[ $menu != "3" ]]
		then
			echo "Parámetro incorrecto: -l terminal -m $menu"
			echo "bash linuxs-doctor.sh -l terminal -m 1|2|3"
			exit
		fi
		;;
    r) 	# Primera ruta a declarar
        rutareporte=$OPTARG;;
    e) 	# Ruta del primer reporte realizado
        rutauno=$OPTARG;;
	x) 	# Envío de evidencias a un medio externo
		resultadoreporte=()
      	for i in "$@"
	   	do
	    	resultadoreporte+=("$i")
	  	done
		;;
	u)	# Usuario del servidor FTP
		userftp=$OPTARG;;
	p)	# Contrasña del FTP
		passftp=$OPTARG;;
	s) 	# IP/Dirección del FTP
		serverftp=$OPTARG;;
	t)	# ID de Telegram
		telegramid=$OPTARG;;
	h)	# Ayuda/Mostrar información
		help=$OPTARG
		if [[ $help != "help" && $help != "info" ]]
		then
			echo "Parámetro incorrecto: -h $help"
			echo "bash linuxs-doctor.sh -h help|info"
			exit
		elif [ "$help" == "help" ]
		then
			ayuda
			exit
		elif [ "$help" == "info" ]
		then
			cat info.txt
			echo ""
			exit
		fi
	;;
	*)	# Mensaje por defecto
		ayuda
		exit
	;;
   esac
done

case $linuxsdoctor in
classic) # Modo clasico

	# Menú de selección
	while true
	do
        clear
        echo " _     _                           ____             _             "
        echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
        echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
        echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
        echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
        echo ""
        echo "Creado por ${green}@Layraaa y @Japinper ${white}| ${blue}v1.1.1${white}"
        echo "https://github.com/Layraaa/Linuxs-Doctor"
        echo ""
		echo "${purple}1) ${lightblue}Recoger información del sistema"
		echo "${purple}2) ${lightblue}Recogida de información y realizar comparaciones de evidencias"
		echo "${purple}3) ${lightblue}Realizar comparaciones de evidencias"
		echo "${purple}4) ${lightblue}Información del script"
		echo "${purple}5) ${lightblue}Salir"
		echo ""
		read -r -p "${lightblue}¿Qué quieres hacer? --> ${white}" menu

		# Opciones del menú
		case $menu in
		1)	# Recoger información del sistema

			# Pregunta por hacer un volcado de memoria RAM
			while true
			do
				read -r -p "${lightblue}¿Quieres realizar un volcado de la memoria RAM? ${red}(El peso del archivo sera igual a la cantidad de memoria que tiene tu sistema)${green} [S/N]${white} --> " ram
				if [[ $ram == "S" ]] || [[ $ram == "s" ]] || [[ $ram == "N" ]] || [[ $ram == "n" ]]
				then
					break
				else
					continue
				fi
				break
			done

			# Pregunta por la ruta para generar el reporte
			while true
			do
				read -r -p "${lightblue}Elige una ruta para generar el reporte ${green}(Ej:/home/user)${white} --> " rutareporte
				if [ ! -d "$rutareporte" ]
				then
					# Comprueba si la ruta especificada existe
					echo "${red}La ruta especificada no existe ($rutareporte)${white}"
					continue
				elif [[ $rutareporte != "" ]]
				then
					if [[ $rutareporte == */ ]]
					then
						# Si termina en /, la elimina
						rutareporte=$(${rutareporte%?})

					fi
					break
				else
					continue
				fi
				break
			done

			# Pregunta si quiere que se envie el reporte
			source enviarreporte.sh
			menureporte

			# Comprueba el sistema operativo e inicia el análisis
			if [[ ! -f /etc/os-release ]]
			then
				echo "${red}No se puede detectar el sistema operativo ${white}"
				echo "No se ha podido detectar el sistema operativo, el archivo /etc/os-release no existe en el sistema" >> log.txt
				exit
			elif [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "CentOS" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Debian" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Ubuntu" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Kali" ]
			then
				echo "${red}Tu sistema operativo no está soportado ${white}"
				exit
			elif [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" == "CentOS" ]
			then
				source analisis.sh
				analisis
				date +"Recogida de información del sistema el %d/%m/%Y - %T" >> log.txt
				recogidadatosCentOS
				finanalisis
			else
				source analisis.sh
				analisis
				date +"Recogida de información del sistema el %d/%m/%Y - %T" >> log.txt
				recogidadatosDebian
				finanalisis
			fi

			echo "${white}[${green}!${white}]${lightblue} Ya hemos terminado! Tus resultados estan en la carpeta 'evidencias-$date'${white}"
			echo "" >> log.txt

			# Envia el reporte a donde se haya querido mandar
			comprobarenviarreporte

			# Fin del script
			echo ""
			echo "${lightblue}¡Gracias por utilizar Linux's Doctor!"
			echo "https://github.com/Layraaa/Linuxs-Doctor"
			echo "Hecho por ${green}@Layraaa y @Japinper${white}"
			echo ""
			base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
			echo ""
			exit
		;;
		2)	# Recogida de información y comparaciones de evidencias

			# Comprueba si el usuario quiere continuar con la ejecución del script
			while true
			do
				read -r -p "${lightblue}¿Quieres continuar (Debes tener otra carpeta con las evidencias que quieras comparar)?${green} [S/N]${white} --> " elegir
				if [[ $elegir == "S" ]] || [[ $elegir == "s" ]]
				then
					# Pregunta por hacer un volcado de memoria RAM
					while true
					do
						read -r -p "${lightblue}¿Quieres realizar un volcado de la memoria RAM? ${red}(El peso del archivo sera igual a la cantidad de memoria que tiene tu sistema)${green} [S/N]${white} --> " ram
						if [[ $ram == "S" ]] || [[ $ram == "s" ]] || [[ $ram == "N" ]] || [[ $ram == "n" ]]
						then
							break
						else
							continue
						fi
						break
					done

					# Pregunta por la ruta para generar el reporte
					while true
					do
						read -r -p "${lightblue}Elige una ruta para generar el reporte ${green}(Ej:/home/user)${white} --> " rutareporte
						if [ ! -d "$rutareporte" ]
						then
							# Comprueba si la ruta especificada existe
							echo "${red}La ruta especificada no existe ($rutareporte)${white}"
							continue
						elif [[ $rutareporte != "" ]]
						then
							if [[ $rutareporte == */ ]]
							then
								# Si termina en /, la elimina
								rutareporte=$(${rutareporte%?})
							fi
							break
						else
							continue
						fi
						break
					done

					# Pregunta por la ruta donde está el primer reporte			
					while true
					do
						read -r -p "${lightblue}Indica la carpeta que contiene la información del primer reporte${white} --> " rutauno
						if [ ! -d "$rutauno" ]
						then
							# Comprueba si la ruta especificada existe
							echo "${red}La ruta especificada no existe ($rutauno)${white}"
							continue
						elif [[ $rutauno != "" ]]
						then
							if [[ $rutauno == */ ]]
							then
								# Si termina en /, la elimina
								rutauno=$(${rutauno%?})
							fi
							break
						else
							continue
						fi
						break
					done
					break
				elif [[ $elegir == "N" ]] || [[ $elegir == "n" ]]
				then
					clear
					bash linuxs-doctor.sh -l classic
				elif [[ -z $elegir ]]
				then
					echo "No has introducido ningún valor"
					continue
				else
					continue
				fi
				break
			done

			# Pregunta si quiere que se envie el reporte
			source enviarreporte.sh
			menureporte

			# Comprueba el sistema operativo e inicia el análisis
			if [[ ! -f /etc/os-release ]]
			then
				echo "${red}No se puede detectar el sistema operativo ${white}"
				echo "No se ha podido detectar el sistema operativo, el archivo /etc/os-release no existe en el sistema" >> log.txt
				exit
			elif [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "CentOS" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Debian" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Ubuntu" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Kali" ]
			then
				echo "${red}Tu sistema operativo no está soportado ${white}"
				exit
			elif [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" == "CentOS" ]
			then
				source analisis.sh
				analisis
				date +"Recogida de información del sistema el %d/%m/%Y - %T" >> log.txt
				recogidadatosCentOS
				finanalisis
			else
				source analisis.sh
				analisis
				date +"Recogida de información del sistema el %d/%m/%Y - %T" >> log.txt
				recogidadatosDebian
				finanalisis
			fi

			# Comparación de las evidencias
			source comparacion.sh
			comprobarcomparacion

			echo "${white}[${green}!${white}]${lightblue} Todas las comparaciones han sido realizadas!"
			echo ""
			echo "${white}[${green}!${white}]${lightblue} Ya hemos terminado! Tus resultados estan en la carpeta 'evidencias-$date'${white}"
			echo "" >> log.txt

			# Envia el reporte a donde se haya querido mandar
			comprobarenviarreporte

			# Fin del script
			echo ""
			echo "${lightblue}¡Gracias por utilizar Linux's Doctor!"
			echo "https://github.com/Layraaa/Linuxs-Doctor"
			echo "Hecho por ${green}@Layraaa y @Japinper${white}"
			echo ""
			base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
			echo ""
			exit
		;;
		3)	# Comparaciones de evidencias

			# Comprueba si el usuario quiere continuar con la ejecución del script
			while true
			do
				read -r -p "${lightblue}¿Quieres continuar (Debes tener dos carpetas con las evidencias que quieras comparar)?${green} [S/N]${white} --> " elegir
				if [[ $elegir == "S" ]] || [[ $elegir == "s" ]]
				then
					# Pregunta por la ruta donde está el primer reporte
					while true
					do
						read -r -p "${lightblue}Indica la carpeta que contiene la información del primer reporte${white} --> " rutauno
						if [ ! -d "$rutauno" ]
						then
							# Comprueba si la ruta especificada existe
							echo "${red}La ruta especificada no existe ($rutauno)${white}"
							continue
						elif [ "$rutauno" != "" ]
						then
							if [[ "$rutauno" == */ ]]
							then
								# Si termina en /, la elimina
								rutauno=$(${rutauno%?})
							fi
							break
						else
							continue
						fi
						break
					done
					
					while true
					do
						# Pregunta por la ruta donde está el segundo reporte
						read -r -p "${lightblue}Indica la carpeta que contiene la información del segundo reporte${white} --> " rutadatos
						if [ ! -d "$rutadatos" ]
						then
							# Comprueba si la ruta especificada existe
							echo "${red}La ruta especificada no existe ($rutadatos)${white}"
							continue
						elif [ "$rutadatos" != "" ]
						then
							if [[ "$rutadatos" == */ ]]
							then
								# Si termina en /, la elimina
								rutadatos=$(${rutadatos%?})
							fi
							break
						else
							continue
						fi
						break
					done
					
				elif [[ $elegir == "N" ]] || [[ $elegir == "n" ]]
				then
					clear
					bash linuxs-doctor.sh -l classic
				elif [ -z "$elegir" ]
				then
					echo "No has introducido ningún valor"
					continue
				else
					continue
				fi
				break
			done

			# Comparación de las evidencias
			source comparacion.sh
			comprobarcomparacion

			# Envia el reporte a donde se haya querido mandar
			source enviarreporte.sh
			comprobarenviarreporte

			# Fin del script
			echo ""
			echo "${lightblue}¡Gracias por utilizar Linux's Doctor!"
			echo "https://github.com/Layraaa/Linuxs-Doctor"
			echo "Hecho por ${green}@Layraaa y @Japinper${white}"
			echo ""
			base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
			echo ""
			exit
		;;
		4)	# Información del script

			# Muestra la informacion
			echo ""
			cat info.txt
			echo ""
			exit
		;;
		5)	#Salir
			exit
		;;
		esac
	done
;;
terminal) # Modo terminal

	# Detecta si se han pasado algun parametro
	if [ -z "$menu" ]
	then
		echo "No se ha detectado la opción que quieres ejecutar"
		echo "bash linuxs-doctor.sh -l terminal -m 1|2|3"
		exit
	fi

    case $menu in
    1)	# Recoger información del sistema

		if [ -z "$rutareporte" ]
		then
			# Comprueba si se ha rellanado el valor
			echo "${lightblue}No has especificado la ruta"
			echo "bash linuxs-doctor.sh -l terminal -r /ejemplo/de/ruta${white}"
        elif [ ! -d "$rutareporte" ]
        then
            # Comprueba si la ruta especificada existe
            echo "${red}La ruta especificada no existe ($rutareporte)${white}"
            exit
        elif [[ $rutareporte == */ ]]
        then
            # Si termina en /, la elimina
            rutareporte=$(${rutareporte%?})
        fi

        # Comprueba el sistema operativo e inicia el análisis
        if [[ ! -f /etc/os-release ]]
        then
            echo "${red}No se puede detectar el sistema operativo ${white}"
            echo "No se ha podido detectar el sistema operativo, el archivo /etc/os-release no existe en el sistema" >> log.txt
            exit
        elif [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "CentOS" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Debian" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Ubuntu" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Kali" ]
        then
            echo "${red}Tu sistema operativo no está soportado ${white}"
            exit
        elif [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" == "CentOS" ]
        then
            source analisis.sh
            analisis
            date +"Recogida de información del sistema el %d/%m/%Y - %T" >> log.txt
            recogidadatosCentOS
            finanalisis
        else
            source analisis.sh
            analisis
            date +"Recogida de información del sistema el %d/%m/%Y - %T" >> log.txt
            recogidadatosDebian
            finanalisis
        fi

		# Comprueba si se ha indicado los parametros necesarios para enviar el reporte a un servidor FTP
        if [[ -n $userftp ]] && [[ -n $passftp ]] && [[ -n $serverftp ]]
        then
            ftp="S"
        fi

		# Comprueba si se ha indicado los parametros necesarios para enviar el reporte por Telegram
        if [[ -n $telegramid ]]
        then
            telegram="S"
        fi

        echo "${white}[${green}!${white}]${lightblue} Ya hemos terminado! Tus resultados estan en la carpeta 'evidencias-$date'${white}"
        echo "" >> log.txt

		# Envia el reporte a donde se haya querido mandar
        source enviarreporte.sh
        comprobarenviarreporte

        echo ""
        echo "${lightblue}¡Gracias por utilizar Linux's Doctor!"
        echo "https://github.com/Layraaa/Linuxs-Doctor"
        echo "Hecho por ${green}@Layraaa y @Japinper${white}"
        echo ""
        base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
        echo ""
        exit
    ;;
    2)	# Recogida de información y comparaciones de evidencias

        if [ -z "$rutareporte" ]
		then
			# Comprueba si se ha rellanado el valor
			echo "${lightblue}No has rellenado de la ruta"
			echo "bash linuxs-doctor.sh -l classic|terminal -r /ejemplo/de/ruta -e /ejemplo/de/ruta${white}"
        elif [ ! -d "$rutareporte" ]
        then
            # Comprueba si la ruta especificada existe
            echo "${red}La ruta especificada no existe ($rutareporte)${white}"
            exit
        elif [[ $rutareporte == */ ]]
        then
            # Si termina en /, la elimina
            rutareporte=$(${rutareporte%?})
        fi

        if [ -z "$rutauno" ]
		then
			# Comprueba si se ha rellanado el valor
			echo "${lightblue}No has rellenado de la ruta"
			echo "bash linuxs-doctor.sh -l classic|terminal -r /ejemplo/de/ruta -e /ejemplo/de/ruta${white}"
        elif [ ! -d $rutauno ]
        then
            # Comprueba si la ruta especificada existe
            echo "${red}La ruta especificada no existe ($rutauno)${white}"
            exit
        elif [[ $rutauno == */ ]]
        then
            # Si termina en /, la elimina
            rutauno=$(${rutauno%?})
        fi


        # Comprueba el sistema operativo e inicia el análisis
        if [[ ! -f /etc/os-release ]]
        then
            echo "${red}No se puede detectar el sistema operativo ${white}"
            echo "No se ha podido detectar el sistema operativo, el archivo /etc/os-release no existe en el sistema" >> log.txt
            exit
        elif [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "CentOS" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Debian" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Ubuntu" ] && [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Kali" ]
        then
            echo "${red}Tu sistema operativo no está soportado ${white}"
            exit
        elif [ "$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" == "CentOS" ]
        then
            source analisis.sh
            analisis
            date +"Recogida de información del sistema el %d/%m/%Y - %T" >> log.txt
            recogidadatosCentOS
            finanalisis
        else
            source analisis.sh
            analisis
            date +"Recogida de información del sistema el %d/%m/%Y - %T" >> log.txt
            recogidadatosDebian
            finanalisis
        fi

        echo "${white}[${green}!${white}]${lightblue} Ya hemos terminado! Tus resultados estan en la carpeta 'evidencias-$date'${white}"
        echo "" >> log.txt

		# Comprobaciones sobre los archivos analisis.txt
        if [[ ! -f $rutauno/analisis.txt || ! -f $rutadatos/analisis.txt ]]
        then
            echo "No existe el archivo analisis.txt"
            exit
        elif [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') ]]
        then
            echo "${red}Se han detectado sistemas operativos distintos ("$(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }')" / "$(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }')")${white}"
            exit
        fi

        if [[ $(sed '8q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Version de Linuxs Doctor: /,""); print }') != $(sed '8q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Version de Linux Doctor: /,""); print }') ]]
        then
            echo "${red}Se han encontrado versiones distintas de Linux's Doctor ("$(sed '8q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Version de Linux Doctor: /,""); print }')" / "$(sed '8q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Version de Linux Doctor: /,""); print }')")${white}"
            exit
        fi

        if [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Kali" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Kali" ]]
        then
            echo "${red}Se ha detectado un sistema operativo no soportado ("$(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }')")${white}"
			echo "De igual forma, se hara la comparacion de evidencias"
        fi

        if [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]]
        then
            comparacion_so="Debian"
        else
            comparacion_so="CentOS"
        fi
        
		# Compara las evidencias
        source comparacion.sh
        comparacion$comparacion_so

        # Comprueba si se ha indicado los parametros necesarios para enviar el reporte a un servidor FTP
        if [[ -n $userftp ]] && [[ -n $passftp ]] && [[ -n $serverftp ]]
        then
            ftp="S"
        fi

		# Comprueba si se ha indicado los parametros necesarios para enviar el reporte por Telegram
        if [[ -n $telegramid ]]
        then
            telegram="S"
        fi

		# Envia el reporte a donde se haya querido mandar
        source enviarreporte.sh
        comprobarenviarreporte

        echo ""
        echo "${lightblue}¡Gracias por utilizar Linux's Doctor!"
        echo "https://github.com/Layraaa/Linuxs-Doctor"
        echo "Hecho por ${green}@Layraaa y @Japinper${white}"
        echo ""
        base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
        echo ""
        exit
    ;;
    3)	# Comparaciones de evidencias

        rutareporte=$rutadatos

        if [ -z "$rutadatos" ]
		then
			# Comprueba si se ha rellanado el valor
			echo "${lightblue}No has rellenado de la ruta"
			echo "bash linuxs-doctor.sh -l classic|terminal -r /ejemplo/de/ruta -e /ejemplo/de/ruta${white}"
        elif [ ! -d "$rutadatos" ]
        then
            # Comprueba si la ruta especificada existe
            echo "${red}La ruta especificada no existe ($rutadatos)${white}"
            exit
        elif [[ $rutadatos == */ ]]
        then
            # Si termina en /, la elimina
            rutadatos=$(${rutadatos%?})
        fi

        if [ -z "$rutauno" ]
		then
			# Comprueba si se ha rellanado el valor
			echo "${lightblue}No has rellenado de la ruta"
			echo "bash linuxs-doctor.sh -l classic|terminal -r /ejemplo/de/ruta -e /ejemplo/de/ruta${white}"
        elif [ ! -d "$rutauno" ]
        then
            # Comprueba si la ruta especificada existe
            echo "${red}La ruta especificada no existe ($rutauno)${white}"
            exit
        elif [[ $rutauno == */ ]]
        then
            # Si termina en /, la elimina
            rutauno=$(${rutauno%?})
        fi

		# Comprobaciones sobre los archivos analisis.txt
        if [[ ! -f $rutauno/analisis.txt || ! -f $rutadatos/analisis.txt ]]
        then
            echo "No existe el archivo analisis.txt"
            exit
        elif [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') ]]
        then
            echo "${red}Se han detectado sistemas operativos distintos ("$(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }')" / "$(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }')")${white}"
            exit
        fi

        if [[ $(sed '8q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Version de Linuxs Doctor: /,""); print }') != $(sed '8q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Version de Linux Doctor: /,""); print }') ]]
        then
            echo "${red}Se han encontrado versiones distintas de Linux's Doctor ("$(sed '8q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Version de Linux Doctor: /,""); print }')" / "$(sed '8q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Version de Linux Doctor: /,""); print }')")${white}"
            exit
        fi

        if [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Kali" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "Kali" ]]
        then
            echo "${red}Se ha detectado un sistema operativo no soportado ("$(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }')")${white}"
			echo "De igual forma, se hara la comparacion de evidencias"
        fi

        if [[ $(sed '4q;d' "$rutauno"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analisis.txt | awk '{ gsub(/Sistema operativo: /,""); print }') != "CentOS" ]]
        then
            comparacion_so="Debian"
        else
            comparacion_so="CentOS"
        fi

		# Compara las evidencias
        source comparacion.sh
        comparacion$comparacion_so

        # Comprueba si se ha indicado los parametros necesarios para enviar el reporte a un servidor FTP
        if [[ -n $userftp ]] && [[ -n $passftp ]] && [[ -n $serverftp ]]
        then
            ftp="S"
        fi

		# Comprueba si se ha indicado los parametros necesarios para enviar el reporte por Telegram
        if [[ -n $telegramid ]]
        then
            telegram="S"
        fi

		# Envia el reporte a donde se haya querido mandar
        source enviarreporte.sh
        comprobarenviarreporte

        echo ""
        echo "${lightblue}¡Gracias por utilizar Linux's Doctor!"
        echo "https://github.com/Layraaa/Linuxs-Doctor"
        echo "Hecho por ${green}@Layraaa y @Japinper${white}"
        echo ""
        base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
        echo ""
        exit
	;;
    esac
;;
esac

# Mostrar ayuda como mensaje por defecto
ayuda
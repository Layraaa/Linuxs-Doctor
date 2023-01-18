#!/bin/bash
# Linux's Doctor: Made by @Layraa y @Japinper
# 
# linuxs-doctor.sh
# Main script of the tool

# Define colors
red="$(tput setaf 1)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"
white="$(tput setaf 7)"
lightblue="$(tput setaf 117)"
purple="$(tput setaf 135)"

# If log.txt doesn't exist, it creates the file
if [ ! -f log.txt ]
then
	touch log.txt
fi

# If user doesn't have admin permisssions, end the script
if [[ $EUID != 0 ]]
then
	echo "${white} _     _                           ____             _             "
	echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
	echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
	echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
	echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
	echo ""
	echo "Made by ${green}@Layraaa and @Japinper ${white}| ${blue}v1.1.2.1${white}"
	echo "https://github.com/Layraaa/Linuxs-Doctor"
	echo ""
	echo "${white}[${red}*${white}] ${lightblue}You must have admin permisssions for execute the script${white}"
	date +"Execution of Linux's Doctor without permisssions made the %d/%m/%Y - %T" >> log.txt
	exit
fi

echo "${white} _     _                           ____             _             "
echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
echo ""
echo "Made by ${green}@Layraaa and @Japinper ${white}| ${blue}v1.1.2.1${white}"
echo "https://github.com/Layraaa/Linuxs-Doctor"

# Check if all files are finded correctly
if [ ! -f analysis.sh ]
then
	echo "${red}File not found: analysis.sh ${white}"
	date+ "Linux's Doctor was executed and we didn't find analysis.sh the %d/%m/%Y - %T" >> log.txt
	exit
fi

if [ ! -f comparision.sh ]
then
	echo "${red}File not found: comparision.sh ${white}"
	date+ "Linux's Doctor was executed and we didn't find comparision.sh the %d/%m/%Y - %T" >> log.txt
	exit
fi

if [ ! -f sendreport.sh ]
then
	echo "${red}File not found: sendreport.sh ${white}"
	date+ "Linux's Doctor was executed and we didn't find sendreport.sh the %d/%m/%Y - %T" >> log.txt
	exit
fi

if [ ! -f file.conf ]
then
    echo "${red}File not found: file.conf ${white}"
	date+ "Linux's Doctor was executed and we didn't find file.conf the %d/%m/%Y - %T" >> log.txt
	exit
fi

# Input config file
source file.conf

# Show help message
function help (){
	echo " _   _      _       
| | | | ___| |_ __  
| |_| |/ _ \ | '_ \ 
|  _  |  __/ | |_) |
|_| |_|\___|_| .__/ 
             |_|    

bash linuxs-doctor.sh [-l classic]
bash linuxs-doctor.sh [-l terminal] [-m] [-r] [-e] [-x] [-u] [-p] [-s] [-t]
bash linuxs-doctor.sh [-h help|info]

-l (classic/terminal)	Start Linux's Doctor on the indicated mode
-m (1/2/3)		Execute an action
	1		Get data from system
	2		Get data from system and compare evidences
	3		Compare evidences
-r			Path where will be allocated the generated report. If you want
			make comparisions between two generated reports, put the last
			generated report
-e			First report's path (Only for comparisions)
-x (FTP/Telegram)	Send evidences to extern mediums
			(You need only indicate the medium if config file is correctly)
-u			FTP User
-p			FTP Password
-s			FTP IP/Domain
-t			Telegram User's ID
-h (help/info)		Show help
	help	Show help for execute Linux's Doctor
	info	Show info of Linux's Doctor"
}

# Read all parameters passed by terminal
while getopts ":l:m:r:e:x:u:p:s:t:h:" option
do
   case $option in
	l)	# Initialization mode of Linux's Doctor
		linuxsdoctor=$OPTARG
		if [[ $linuxsdoctor != "classic" && $linuxsdoctor != "terminal" ]]
		then
			echo "Bad parameter: -l $linuxsdoctor"
			echo "bash linuxs-doctor.sh -l classic|terminal"
			exit
		fi
	;;
    m) 	# Option to execute
        menu=$OPTARG
		if [[ $menu != "1" ]] && [[ $menu != "2" ]] && [[ $menu != "3" ]]
		then
			echo "Bad parameter: -l terminal -m $menu"
			echo "bash linuxs-doctor.sh -l terminal -m 1|2|3"
			exit
		fi
		;;
    r) 	# Generated report path / Second report path
        rutareporte=$OPTARG;;
    e) 	# First report path
        rutauno=$OPTARG;;
	x) 	# Send evidences to an extern mediums
		resultadoreporte=()
      	for i in "$@"
	   	do
	    	resultadoreporte+=("$i")
	  	done
		;;
	u)	# User of FTP server
		userftp=$OPTARG;;
	p)	# Password of FTP
		passftp=$OPTARG;;
	s) 	# IP/Domain of FTP
		serverftp=$OPTARG;;
	t)	# Telegram ID
		telegramid=$OPTARG;;
	h)	# Help/Show information
		help=$OPTARG
		if [[ $help != "help" && $help != "info" ]]
		then
			echo "Bad parameter: -h $help"
			echo "bash linuxs-doctor.sh -h help|info"
			exit
		elif [ "$help" == "help" ]
		then
			help
			exit
		elif [ "$help" == "info" ]
		then
			cat about.txt
			echo ""
			exit
		fi
	;;
	*)	# Default message
		help
		exit
	;;
   esac
done

case $linuxsdoctor in
classic) # Classic Mode

	# Menu
	while true
	do
        clear
		echo "${white} _     _                           ____             _             "
        echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
        echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
        echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
        echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
        echo ""
        echo "Made by ${green}@Layraaa and @Japinper ${white}| ${blue}v1.1.2.1${white}"
        echo "https://github.com/Layraaa/Linuxs-Doctor"
        echo ""
		echo "${purple}1) ${lightblue}Get data from system"
		echo "${purple}2) ${lightblue}Get data from system and compare evidences"
		echo "${purple}3) ${lightblue}Compare evidences"
		echo "${purple}4) ${lightblue}Show information of the script"
		echo "${purple}5) ${lightblue}Exit"
		echo ""
		read -r -p "${lightblue}¿What do you want to do? --> ${white}" menu

		# Menu's options
		case $menu in
		1)	# Get data from system

			# Ask for dump RAM memory
			while true
			do
				read -r -p "${lightblue}¿Do you want dump RAM? ${red}(The file's weight will be same as the ammount of RAM installed on the system)${green} [Y/N]${white} --> " ram
				if [[ $ram == "Y" ]] || [[ $ram == "y" ]] || [[ $ram == "N" ]] || [[ $ram == "n" ]]
				then
					break
				else
					continue
				fi
				break
			done

			# Ask for the path of report
			while true
			do
				read -r -p "${lightblue}Choose a path for generate the report ${green}(Ex: /home/user)${white} --> " rutareporte
				if [ ! -d "$rutareporte" ]
				then
					# Check if path exists
					echo "${red}Path doesn't exist ($rutareporte)${white}"
					continue
				elif [[ $rutareporte != "" ]]
				then
					if [[ $rutareporte == */ ]]
					then
						# If it ends on "/", it erase it from the variable
						rutareporte=$(${rutareporte%?})
					fi
					break
				else
					continue
				fi
				break
			done

			# Ask if the user want send the report
			source sendreport.sh
			menureporte

			# Check the OS and start getting the data
			if [[ ! -f /etc/os-release ]]
			then
				echo "${red}It couldn't check the OS ${white}"
				echo "It couldn't check the OS, the file /etc/os-release is not found on the system" >> log.txt
				exit
			elif [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "CentOS" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Debian" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Ubuntu" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Kali" ]
			then
				echo "${red}Your OS is not supported ${white}"
				exit
			elif [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" == "CentOS" ]
			then
				source analysis.sh
				analisis
				date +"Getting system data the %d/%m/%Y - %T" >> log.txt
				recogidadatosCentOS
				finanalisis
			else
				source analysis.sh
				analisis
				date +"Getting system data the %d/%m/%Y - %T" >> log.txt
				recogidadatosDebian
				finanalisis
			fi

			echo "${white}[${green}!${white}]${lightblue} Data collection finished! The results are on the folder 'evidences-$date'${white}"
			echo "" >> log.txt

			# Send the report if the user checked it before
			comprobarenviarreporte

			# End of the script
			echo ""
			echo "${lightblue}¡Thanks for use Linux's Doctor!"
			echo "https://github.com/Layraaa/Linuxs-Doctor"
			echo "Made by ${green}@Layraaa and @Japinper${white}"
			echo ""
			base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
			echo ""
			exit
		;;
		2)	# Get data from system and compare evidences

			# Check if the user want continue with the execution's script
			while true
			do
				read -r -p "${lightblue}¿Do you want continue (You must have two different folders with evidences that you want compare)?${green} [Y/N]${white} --> " elegir
				if [[ $elegir == "Y" ]] || [[ $elegir == "y" ]]
				then
					# Ask for dump RAM memory
					while true
					do
						read -r -p "${lightblue}¿Do you want dump RAM? ${red}(The file's weight will be same as the ammount of RAM installed on the system)${green} [Y/N]${white} --> " ram
						if [[ $ram == "Y" ]] || [[ $ram == "y" ]] || [[ $ram == "N" ]] || [[ $ram == "n" ]]
						then
							break
						else
							continue
						fi
						break
					done

					# Ask for the path of report
					while true
					do
						read -r -p "${lightblue}Choose a path for generate the report ${green}(Ex: /home/user)${white} --> " rutareporte
						if [ ! -d "$rutareporte" ]
						then
							# Check if path exists
							echo "${red}Path doesn't exist ($rutareporte)${white}"
							continue
						elif [[ $rutareporte != "" ]]
						then
							if [[ $rutareporte == */ ]]
							then
								# If it ends on "/", it erase it from the variable
								rutareporte=$(${rutareporte%?})
							fi
							break
						else
							continue
						fi
						break
					done

					# Ask for the path where it's the first report			
					while true
					do
						read -r -p "${lightblue}Put the path's folder that contains the data of the first report${white} --> " rutauno
						if [ ! -d "$rutauno" ]
						then
							# Check if path exists
							echo "${red}Path doesn't exist ($rutauno)${white}"
							continue
						elif [[ $rutauno != "" ]]
						then
							if [[ $rutauno == */ ]]
							then
								# If it ends on "/", it erase it from the variable
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
				else
					continue
				fi
				break
			done

			# Ask if the user want send the report
			source sendreport.sh
			menureporte

			# Check the OS and start getting the data
			if [[ ! -f /etc/os-release ]]
			then
				echo "${red}It couldn't check the OS ${white}"
				echo "It couldn't check the OS, the file /etc/os-release is not found on the system" >> log.txt
				exit
			elif [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "CentOS" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Debian" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Ubuntu" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Kali" ]
			then
				echo "${red}Your OS is not supported ${white}"
				exit
			elif [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" == "CentOS" ]
			then
				source analysis.sh
				analisis
				date +"Getting system data the %d/%m/%Y - %T" >> log.txt
				recogidadatosCentOS
				finanalisis
			else
				source analysis.sh
				analisis
				date +"Getting system data the %d/%m/%Y - %T" >> log.txt
				recogidadatosDebian
				finanalisis
			fi

			# Comparision of evidences
			source comparision.sh
			comprobarcomparacion

			echo "${white}[${green}!${white}]${lightblue} All comparisions are ended!"
			echo ""
			echo "${white}[${green}!${white}]${lightblue} Data collection finished! The results are on the folder 'evidences-$date'${white}"
			echo "" >> log.txt

			# Send the report if the user checked it before
			comprobarenviarreporte

			# End of the script
			echo ""
			echo "${lightblue}¡Thanks for use Linux's Doctor!"
			echo "https://github.com/Layraaa/Linuxs-Doctor"
			echo "Made by ${green}@Layraaa and @Japinper${white}"
			echo ""
			base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
			echo ""
			exit
		;;
		3)	# Compare evidences

			# Check if the user want continue with the execution's script
			while true
			do
				read -r -p "${lightblue}¿Do you want continue (You must have two different folders with evidences that you want compare)?${green} [Y/N]${white} --> " elegir
				if [[ $elegir == "Y" ]] || [[ $elegir == "y" ]]
				then
					# Ask for the path where it's the first report
					while true
					do
						read -r -p "${lightblue}Put the path's folder that contains the data of the first report${white} --> " rutauno
						if [ ! -d "$rutauno" ]
						then
							# Check if path exists
							echo "${red}Path doesn't exist ($rutauno)${white}"
							continue
						elif [ "$rutauno" != "" ]
						then
							if [[ "$rutauno" == */ ]]
							then
								# If it ends on "/", it erase it from the variable
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
						# Ask for second report's path
						read -r -p "${lightblue}Put the path's folder that contains the data of the second report${white} --> " rutadatos
						if [ ! -d "$rutadatos" ]
						then
							# Check if path exists
							echo "${red}Path doesn't exist ($rutadatos)${white}"
							continue
						elif [ "$rutadatos" != "" ]
						then
							if [[ "$rutadatos" == */ ]]
							then
								# If it ends on "/", it erase it from the variable
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
					echo "You didn't put any value"
					continue
				else
					continue
				fi
				break
			done

			# Comparision of evidences
			source comparision.sh
			comprobarcomparacion

			# Send the report if the user checked it before
			source sendreport.sh
			comprobarenviarreporte

			# End of the script
			echo ""
			echo "${lightblue}¡Thanks for use Linux's Doctor!"
			echo "https://github.com/Layraaa/Linuxs-Doctor"
			echo "Made by ${green}@Layraaa and @Japinper${white}"
			echo ""
			base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
			echo ""
			exit
		;;
		4)	# Show information of the script

			# Show info
			echo ""
			cat about.txt
			echo ""
			exit
		;;
		5)	#Exit
		
			exit
		;;
		esac
	done
;;
terminal) # Terminal Mode

	# Detect if no parameters was passed
	if [ -z "$menu" ]
	then
		echo "We didn't detect any option"
		echo "bash linuxs-doctor.sh -l terminal -m 1|2|3"
		exit
	fi

    case $menu in
    1)	# Get data from system

		if [ -z "$rutareporte" ]
		then
			# Check if it has a value
			echo "${lightblue}You didn't put a path"
			echo "bash linuxs-doctor.sh -l terminal -r /example/of/path${white}"
			exit
        elif [ ! -d "$rutareporte" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($rutareporte)${white}"
            exit
        elif [[ $rutareporte == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            rutareporte=$(${rutareporte%?})
        fi

        # Check the OS and start getting the data
        if [[ ! -f /etc/os-release ]]
        then
            echo "${red}It couldn't check the OS ${white}"
            echo "It couldn't check the OS, the file /etc/os-release is not found on the system" >> log.txt
            exit
        elif [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "CentOS" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Debian" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Ubuntu" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Kali" ]
        then
            echo "${red}Your OS is not supported ${white}"
            exit
        elif [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" == "CentOS" ]
        then
            source analysis.sh
            analisis
            date +"Getting system data the %d/%m/%Y - %T" >> log.txt
            recogidadatosCentOS
            finanalisis
        else
            source analysis.sh
            analisis
            date +"Getting system data the %d/%m/%Y - %T" >> log.txt
            recogidadatosDebian
            finanalisis
        fi

		# Check if parameters were indicated correctly for send evidences to a FTP server
        if [[ -n $userftp ]] && [[ -n $passftp ]] && [[ -n $serverftp ]]
        then
            ftp="S"
        fi

		# Check if parameters were indicated correctly for send evidences to a Telegram user
        if [[ -n $telegramid ]]
        then
            telegram="S"
        fi

        echo "${white}[${green}!${white}]${lightblue} Data collection finished! The results are on the folder 'evidences-$date'${white}"
        echo "" >> log.txt

		# Send the report if the user checked it before
        source sendreport.sh
        comprobarenviarreporte

        echo ""
        echo "${lightblue}¡Thanks for use Linux's Doctor!"
        echo "https://github.com/Layraaa/Linuxs-Doctor"
        echo "Made by ${green}@Layraaa and @Japinper${white}"
        echo ""
        base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
        echo ""
        exit
    ;;
    2)	# Get data from system and compare evidences

        if [ -z "$rutareporte" ]
		then
			# Check if it has a value
			echo "${lightblue}You didn't put a path"
			echo "bash linuxs-doctor.sh -l classic|terminal -r /example/of/path -e /example/of/path${white}"
			exit
        elif [ ! -d "$rutareporte" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($rutareporte)${white}"
            exit
        elif [[ $rutareporte == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            rutareporte=$(${rutareporte%?})
        fi

        if [ -z "$rutauno" ]
		then
			# Check if it has a value
			echo "${lightblue}You didn't put a path"
			echo "bash linuxs-doctor.sh -l classic|terminal -r /example/of/path -e /example/of/path${white}"
			exit
        elif [ ! -d "$rutauno" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($rutauno)${white}"
            exit
        elif [[ $rutauno == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            rutauno=$(${rutauno%?})
        fi


        # Check the OS and start getting the data
        if [[ ! -f /etc/os-release ]]
        then
            echo "${red}It couldn't check the OS ${white}"
            echo "It couldn't check the OS, the file /etc/os-release is not found on the system" >> log.txt
            exit
        elif [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "CentOS" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Debian" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Ubuntu" ] && [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" != "Kali" ]
        then
            echo "${red}Your OS is not supported ${white}"
            exit
        elif [ "$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" == "CentOS" ]
        then
            source analysis.sh
            analisis
            date +"Getting system data the %d/%m/%Y - %T" >> log.txt
            recogidadatosCentOS
            finanalisis
        else
            source analysis.sh
            analisis
            date +"Getting system data the %d/%m/%Y - %T" >> log.txt
            recogidadatosDebian
            finanalisis
        fi

        echo "${white}[${green}!${white}]${lightblue} Data collection finished! The results are on the folder 'evidences-$date'${white}"
        echo "" >> log.txt

		# Checking analysis.txt files
        if [[ ! -f $rutauno/analysis.txt || ! -f $rutadatos/analysis.txt ]]
        then
            echo "${red}File not found: analysis.txt${white}"
            exit
        elif [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') ]]
        then
            echo "${red}We detected different OS ("$(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }')" / "$(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }')")${white}"
            exit
        fi

        if [[ $(sed '8q;d' "$rutauno"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') != $(sed '8q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') ]]
        then
            echo "${red}We detected different versions of Linux's Doctor ("$(sed '8q;d' "$rutauno"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }')" / "$(sed '8q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }')")${white}"
            exit
        fi

        if [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]]
        then
            echo "${red}We detected an unsupported OS ("$(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }')")${white}"
			echo "By all means, evidences' comparision will start"
        fi

        if [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]]
        then
            comparacion_so="Debian"
        else
            comparacion_so="CentOS"
        fi
        
		# Comparision of evidences
        source comparision.sh
        comparacion$comparacion_so

        # Check if parameters were indicated correctly for send evidences to a FTP server
        if [[ -n $userftp ]] && [[ -n $passftp ]] && [[ -n $serverftp ]]
        then
            ftp="S"
        fi

		# Check if parameters were indicated correctly for send evidences to a Telegram user
        if [[ -n $telegramid ]]
        then
            telegram="S"
        fi

		# Send the report if the user checked it before
        source sendreport.sh
        comprobarenviarreporte

        echo ""
        echo "${lightblue}¡Thanks for use Linux's Doctor!"
        echo "https://github.com/Layraaa/Linuxs-Doctor"
        echo "Made by ${green}@Layraaa and @Japinper${white}"
        echo ""
        base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
        echo ""
        exit
    ;;
    3)	# Compare evidences

        rutareporte=$rutadatos

        if [ -z "$rutadatos" ]
		then
			# Check if it has a value
			echo "${lightblue}You didn't put a path"
			echo "bash linuxs-doctor.sh -l classic|terminal -r /example/of/path -e /example/of/path${white}"
			exit
        elif [ ! -d "$rutadatos" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($rutadatos)${white}"
            exit
        elif [[ $rutadatos == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            rutadatos=$(${rutadatos%?})
        fi

        if [ -z "$rutauno" ]
		then
			# Check if it has a value
			echo "${lightblue}You didn't put a path"
			echo "bash linuxs-doctor.sh -l classic|terminal -r /example/of/path -e /example/of/path${white}"
			exit
        elif [ ! -d "$rutauno" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($rutauno)${white}"
            exit
        elif [[ $rutauno == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            rutauno=$(${rutauno%?})
        fi

		# Checking analysis.txt files
        if [[ ! -f $rutauno/analysis.txt || ! -f $rutadatos/analysis.txt ]]
        then
            echo "File not found: analysis.txt"
            exit
        elif [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') ]]
        then
            echo "${red}We detected different OS ("$(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }')" / "$(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }')")${white}"
            exit
        fi

        if [[ $(sed '8q;d' "$rutauno"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') != $(sed '8q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') ]]
        then
            echo "${red}We detected different versions of Linux's Doctor ("$(sed '8q;d' "$rutauno"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }')" / "$(sed '8q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }')")${white}"
            exit
        fi

        if [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]]
        then
            echo "${red}We detected an unsupported OS ("$(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }')")${white}"
			echo "By all means, evidences' comparision will start"
        fi

        if [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]]
        then
            comparacion_so="Debian"
        else
            comparacion_so="CentOS"
        fi

		# Comparision of evidences
        source comparision.sh
        comparacion$comparacion_so

        # Check if parameters were indicated correctly for send evidences to a FTP server
        if [[ -n $userftp ]] && [[ -n $passftp ]] && [[ -n $serverftp ]]
        then
            ftp="S"
        fi

		# Check if parameters were indicated correctly for send evidences to a Telegram user
        if [[ -n $telegramid ]]
        then
            telegram="S"
        fi

		# Send the report if the user checked it before
        source sendreport.sh
        comprobarenviarreporte

        echo ""
        echo "${lightblue}¡Thanks for use Linux's Doctor!"
        echo "https://github.com/Layraaa/Linuxs-Doctor"
        echo "Made by ${green}@Layraaa and @Japinper${white}"
        echo ""
        base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
        echo ""
        exit
	;;
    esac
;;
esac

# Show help message as default behaviour
help
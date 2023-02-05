#!/bin/bash
# Linux's Doctor: Made by @Layraa y @Japinper
#
# linuxsdoctor.sh
# Main script of the tool

# Define colors
red="$(tput setaf 1)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"
white="$(tput setaf 7)"
lightblue="$(tput setaf 117)"
purple="$(tput setaf 135)"
reset="$(tput sgr0)"

# Declare RAM var
ram="-"

# Trap exit
trap ctrl_c INT

function ctrl_c() {
	echo ""
	echo "${red}User interrupted Linux's Doctor, exiting...${reset}"
	echo ""
	sleep 1
	exit
}

# If user doesn't have admin permisssions, end the script
if [[ $EUID != 0 ]]
then
	echo "${white} _     _                           ____             _             "
	echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
	echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
	echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
	echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
	echo ""
	echo "Made by ${green}@Layraaa and @Japinper ${white}| ${blue}v1.2${white}"
	echo "${purple}https://github.com/Layraaa/Linuxs-Doctor"
	echo ""
	echo "${red}You must have root permisssions for execute linuxsdoctor${reset}"
	exit
fi

# Check if Linux's Doctor is installed correctly
if [[ ! -d /lib/linuxsdoctor || ! -f /lib/linuxsdoctor/linuxsdoctor.sh ]]
then
	echo "${red}Linux's Doctor is not installed${reset}"
	exit
fi

# If log.txt doesn't exist, it creates the file
if [ ! -f /lib/linuxsdoctor/log.txt ]
then
	touch /lib/linuxsdoctor/log.txt
fi


echo "${white} _     _                           ____             _             "
echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
echo ""
echo "Made by ${green}@Layraaa and @Japinper ${white}| ${blue}v1.2${white}"
echo "${purple}https://github.com/Layraaa/Linuxs-Doctor"

# Check if all files are finded correctly
if [ ! -f /lib/linuxsdoctor/analysis.sh ]
then
	echo "${red}File not found: analysis.sh ${reset}"
	date+ "Linux's Doctor was executed and we didn't find analysis.sh the %D - %T" >> /lib/linuxsdoctor/log.txt
	exit
fi

if [ ! -f /lib/linuxsdoctor/comparision.sh ]
then
	echo "${red}File not found: comparision.sh ${reset}"
	date+ "Linux's Doctor was executed and we didn't find comparision.sh the %D - %T" >> /lib/linuxsdoctor/log.txt
	exit
fi

if [ ! -f /lib/linuxsdoctor/sendreport.sh ]
then
	echo "${red}File not found: sendreport.sh ${reset}"
	date+ "Linux's Doctor was executed and we didn't find sendreport.sh the %D - %T" >> /lib/linuxsdoctor/log.txt
	exit
fi

if [ ! -f /lib/linuxsdoctor/file.conf ]
then
    echo "${red}File not found: file.conf ${reset}"
	date+ "Linux's Doctor was executed and we didn't find file.conf the %D - %T" >> /lib/linuxsdoctor/log.txt
	exit
fi

# Detect the OS
os=$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')

# Input config file
source /lib/linuxsdoctor/file.conf

# Function for zip evidences and send to external mediums
function zipandsend(){

	if [[ " ${reportresult[*]} " =~ "-x" ]]
	then

		# Declare if they were errors on sending reports
		htmlftp="-"
		evidencesftp="-"
		evidencestelegram="-"

		if [[ " ${reportresult[*]} " =~ "htmlftp" ]] # Send HTML report to FTP Server
		then
			if [ "$menu" -eq 2 ]
			then
				if [[ -f /lib/linuxsdoctor/.htmlftp ]] # Check if file exists
				then
					if [[ -f "$datapath"/report-"$date".html ]] # Check if report.txt exists
					then

						echo "${white}[${red}*${white}] ${lightblue}Sending HTML report to FTP Server..."
						export datapath date
						/lib/linuxsdoctor/.htmlftp

						# Check if something went wrong
						if [ "$?" -eq 0 ]
						then
							echo "${white}[${green}!${white}] ${lightblue}Completed!"
							htmlftp="Y"
						else
							echo "${red}Something went wrong${white}"
							htmlftp="N"
						fi
					else
						echo "${red}It has not been detected $datapath/report-$date.html${white}"
					fi
				else
					echo "${red}It has not been detected .htmlftp, create it in setup${white}"
				fi
			else
				echo "${red}HTML reports are only for comparisions${white}"
			fi
			echo ""
		fi

		if [[ " ${reportresult[*]} " =~ "evidencesftp" ]] # Send evidences to FTP Server
		then
			if [[ -f /lib/linuxsdoctor/.evidencesftp ]] # Check if file exists
			then
				# Zip evidences
				zip -r "$datapath.zip" "$datapath" >> /dev/null
				datapathzip="$datapath.zip"

				echo "${white}[${red}*${white}] ${lightblue}Sending evidences to FTP Server..."
				export datapathzip
				/lib/linuxsdoctor/.evidencesftp

				# Check if something went wrong
				if [ "$?" -eq 0 ]
				then
					echo "${white}[${green}!${white}] ${lightblue}Completed!"
					evidencesftp="Y"
				else
					echo "${red}Something went wrong${white}"
					evidencesftp="N"
				fi
			else
				echo "${red}It has not been detected .evidencesftp, create it in setup${white}"
			fi
			echo ""
		fi

		if [[ " ${reportresult[*]} " =~ "evidencestelegram" ]] # Send evidencias to Telegram
		then
			if [[ -f /lib/linuxsdoctor/.evidencestelegram ]] # Check if file exists
			then
				if [ ! -f "$datapath.zip" ]
				then
					zip -r "$datapath.zip" "$datapath" >> /dev/null
					datapathzip="$datapath.zip"
				fi

				echo "${white}[${red}*${white}] ${lightblue}Sending evidences to Telegram..."
				export datapathzip
				/lib/linuxsdoctor/.evidencestelegram
				
				# Check if something went wrong
				if [ "$?" -eq 0 ]
				then
					echo "${white}[${green}!${white}] ${lightblue}Completed!"
					evidencestelegram="Y"
				else
					echo "${red}Something went wrong${white}"
					evidencestelegram="N"
				fi
			else
				echo "${red}It has not been detected .evidencestelegram, create it in setup${white}"
			fi
			echo ""
		fi

		if [[ " ${reportresult[*]} " =~ "notificationdb" ]] # Send analysis notifications to DB Server
		then
			if [[ -f /lib/linuxsdoctor/.notificationdb ]] # Check if file exists
			then
				echo "${white}[${red}*${white}] ${lightblue}Sending notification to DB..."

				# Variables declaration and exporting
				ip_address=$(hostname -I)
				hostname=$(hostname)
				kernerls_version=$(uname -r)
				analysis_type="$linuxsdoctor"
				analysis_made="get_data"
				analysis_start_date=$(sed '11!d' "$datapath"/analysis.txt | sed 's/Start date: //' )
				analysis_start_time=$(sed '12!d' "$datapath"/analysis.txt | sed 's/Start time: //' )
				analysis_end_date=$(sed '13!d' "$datapath"/analysis.txt | sed 's/End date: //' )
				analysis_end_time=$(sed '14!d' "$datapath"/analysis.txt | sed 's/End time: //' )
				linuxs_doctor_version="v1.2"
				export ip_address
				export os
				export hostname
				export kernerls_version
				export analysis_type
				export analysis_made
				export analysis_start_date
				export analysis_start_time
				export analysis_end_date
				export analysis_end_time
				export ram
				export evidencesftp
				export evidencestelegram
				export htmlftp
				export linuxs_doctor_version
				export menu
				if [ "$menu" -eq 2 ]
				then
					analysis_made="get_data_and_comparisions"
					export errorssystemsfiles
					export errorsnetworkconfiguration
					export errorssystemsservices
					export errorssystemslogs
					export errorsserviceslogs
					export modifiedsystemsfiles
					export modifiednetworkconfiguration
					export modifiedsystemsservices
					export modifiedsystemslogs
					export modifiedserviceslogs
					export unmodifiedsystemsfiles
					export unmodifiednetworkconfiguration
					export unmodifiedsystemsservices
					export unmodifiedsystemslogs
					export unmodifiedserviceslogs
				fi
				/lib/linuxsdoctor/.notificationdb
				# Check if something went wrong
				if [ "$?" -eq 0 ]
				then
					echo "${white}[${green}!${white}] ${lightblue}Completed!"
				else
					echo "${red}Something went wrong${white}"
				fi
				echo ""
			else
				echo "${red}It has not been detected .notificationdb, create it in setup${white}"
			fi
			echo ""
		fi

		if [[ " ${reportresult[*]} " =~ "notificationtelegram" ]] # Send analysis notifications to Telegram
		then
			if [[ -f /lib/linuxsdoctor/.notificationtelegram ]] # Check if file exists
			then
				if [ "$menu" -eq 1 ]
				then
					notificationtelegram="Analysis Linux's Doctor v1.2

IP: $(hostname -I)
OS: $os
Hostname: $(hostname)
Kernerl's version: $(uname -r)
Analysis type: $linuxsdoctor
$(sed '11!d' "$datapath"/analysis.txt)
$(sed '12!d' "$datapath"/analysis.txt)
$(sed '13!d' "$datapath"/analysis.txt)
$(sed '14!d' "$datapath"/analysis.txt)
Dump RAM: $ram
Send evidences to FTP?: $evidencesftp
Send evidences to Telegram?: $evidencestelegram
Send web report?: $htmlftp"
				elif [ "$menu" -eq 2 ]
				then
					notificationtelegram="Analysis Linux's Doctor v1.2

IP: $(hostname -I)
OS: $os
Hostname: $(hostname)
Kernerl's version: $(uname -r)
Analysis type: $linuxsdoctor
$(sed '11!d' "$datapath"/analysis.txt)
$(sed '12!d' "$datapath"/analysis.txt)
$(sed '13!d' "$datapath"/analysis.txt)
$(sed '14!d' "$datapath"/analysis.txt)
Dump RAM: $ram
Send evidences to FTP?: $evidencesftp
Send evidences to Telegram?: $evidencestelegram
Send web report?: $htmlftp

Comparisions:
$(if [[ $errorssystemsfiles != "0" ]] || [[ $modifiedsystemsfiles != "0" ]] || [[ $unmodifiedsystemsfiles != "0" ]]
then
echo "Errors in comparisions of system's files: $errorssystemsfiles"
echo "Modified in system's files: $modifiedsystemsfiles"
echo "Unmodified system's files: $unmodifiedsystemsfiles"
echo ""
fi)

$(if [[ $errorsnetworkconfiguration != "0" ]] || [[ $modifiednetworkconfiguration != "0" ]] || [[ $unmodifiednetworkconfiguration != "0" ]]
then
echo "Errors in comparisions of network configuration: $errorsnetworkconfiguration"
echo "Modified network configuration: $modifiednetworkconfiguration"
echo "Unmodified network configuration: $unmodifiednetworkconfiguration"
echo ""
fi)

$(if [[ $errorssystemsservices != "0" ]] || [[ $modifiedsystemsservices != "0" ]] || [[ $unmodifiedsystemsservices != "0" ]]
then
echo "Errors in comparisions of system's services: $errorssystemsservices"
echo "Modified system's services: $modifiedsystemsservices"
echo "Unmodified system's services: $unmodifiedsystemsservices"
echo ""
fi)

$(if [[ $errorssystemslogs != "0" ]] || [[ $modifiedsystemslogs != "0" ]] || [[ $unmodifiedsystemslogs != "0" ]]
then
echo "Errors in comparisions of system's logs: $errorssystemslogs"
echo "Modified system's logs: $modifiedsystemslogs"
echo "Unmodified system's logs: $unmodifiedsystemslogs"
echo ""
fi)

$(if [[ $errorsserviceslogs != "0" ]] || [[ $modifiedserviceslogs != "0" ]] || [[ $unmodifiedserviceslogs != "0" ]]
then
echo "Errors in comparisions of services' logs: $errorsserviceslogs"
echo "Modified services' logs: $modifiedserviceslogs"
echo "Unmodified services' logs: $unmodifiedserviceslogs"
echo ""
fi)"
				fi

				echo "${white}[${red}*${white}] ${lightblue}Sending notification to Telegram..."
				export notificationtelegram
				/lib/linuxsdoctor/.notificationtelegram

				# Check if something went wrong
				if [ "$?" -eq 0 ]
				then
					echo "${white}[${green}!${white}] ${lightblue}Completed!"
				else
					echo "${red}Something went wrong${white}"
				fi
			else
				echo "${red}It has not been detected .notificationtelegram, create it in setup${white}"
			fi
			echo ""
		fi

		# Erase zipfile if it was generated
		if [ -f "$datapath.zip" ]
		then
			rm -rf "$datapath.zip"
		fi
	fi
}

# Function for erase evidences or old evidences
function eraseevidences(){
	if [ "$keeplastevidences" == "Y" ]
	then
		if [ -n "$lastevidences" ] # It if has a value (Not empty)
		then
			rm -rf "$lastevidences"
		fi
		datapath=${datapath//\//\\/}
		sed -i "s/^lastevidences=.*/lastevidences=$datapath/" /lib/linuxsdoctor/file.conf # Write new evidences in 'lastevidences' variable
	else
		if [ "$eraseevidences" == "Y" ]
		then
			rm -rf "$datapath"
		else
			echo "${white}[${green}!${white}]${lightblue} The results are on the folder '$datapath'${white}"
		fi
	fi
}

# Show help message
function help (){
	echo " _   _      _
| | | | ___| |_ __
| |_| |/ _ \ | '_ \ 
|  _  |  __/ | |_) |
|_| |_|\___|_| .__/
             |_| 

linuxsdoctor [-l setup]
linuxsdoctor [-l classic]
linuxsdoctor [-l terminal] [-m] [-r] [-e] [-x] [-d] [-h]
linuxsdoctor [-h help|info]

-l (setup/classic/terminal)	Start Linux's Doctor on the indicated mode
setup		Execute Linux's Doctor setup
classic		Use Linux's Doctor with a menu
terminal	Use Linux's Doctor in terminal using parameters

-m (1/2/3)	Execute an action
1		Get data from system
2		Get data from system and compare evidences
3		Compare evidences

-r	Path where will be allocated the generated report. If you want
	make comparisions between two generated reports, put the last
	generated report

-e	First report's path (Only for comparisions)

-x	Send evidences to extern mediums (Indicate the mediums with spaces between them)
evidencesftp		Send evidences to FTP Server
evidencestelegram	Send evidences to Telegram
htmlftp			Send HTML report to FTP Server
notificationdb		Send analysis notification to DB Server
notificationtelegram	Send analysis notification to Telegram

-d (Y)	Dump RAM

-h (help/info)	Help
help		Show help for execute Linux's Doctor
info		Show info of Linux's Doctor

Examples:
Get data:	linuxsdoctor -l terminal -m 1 -r /root -x evidencesftp
Comparisions:	linuxsdoctor -l terminal -m 2 -r /root -e /root/evidences -x notificationtelegram
Automatizated:	linuxsdoctor -l terminal -m 2 -r /root -e lastevidences -x evidencestelegram
"
}

# Show end script
function endscript(){
	# End of the script
	echo ""
	echo "${lightblue}¡Thanks for use Linux's Doctor!"
	echo "${purple}https://github.com/Layraaa/Linuxs-Doctor"
	echo "Made by ${green}@Layraaa and @Japinper${white}"
	echo ""
	echo "                                *"
	echo ""
	echo "                         *  _|_"
	echo "                         .-' * '-. *"
	echo "                        /       * \\"
	echo "                     *  ^^^^^|^^^^^"
	echo "                         .~. |  .~."
	echo "                        / ^ \| / ^ \\"
	echo "                       (\|  |J/\| \|) "
	echo "                       '\   /\`\"\   /\`'"
	echo "             -- '' -'-'  ^\`^    ^\`^  -- '' -'-'"
	echo "${reset}"
	exit
}

# Read all parameters passed by terminal
while getopts ":l:m:r:e:x:d:h:" option
do
	case $option in
	l)	# Initialization mode of Linux's Doctor
		linuxsdoctor=$OPTARG
		if [[ $linuxsdoctor != "setup" && $linuxsdoctor != "classic" && $linuxsdoctor != "terminal" ]]
		then
			echo "${red}Bad parameter: -l $linuxsdoctor"
			echo "${white}linuxsdoctor -l setup|classic|terminal${reset}"
			exit
		fi
	;;
    m) 	# Option to execute
        menu=$OPTARG
		if [[ $menu != "1" ]] && [[ $menu != "2" ]] && [[ $menu != "3" ]]
		then
			echo "${red}Bad parameter: -l terminal -m $menu"
			echo "${white}linuxsdoctor -l terminal -m 1|2|3${reset}"
			exit
		fi
		;;
    r) 	# Generated report path / Second report path
        reportpath=$OPTARG
		;;
    e) 	# First report path
        firstpath=$OPTARG
		if [ "$firstpath" == "lastevidences" ]
		then
			firstpath="$lastevidences"
		fi
		;;
	x) 	# Send evidences to an extern mediums
		reportresult=()
      	for i in "$@"
	   	do
	    	reportresult+=("$i")
	  	done
		;;
	d)	# Dump RAM
		ram=$OPTARG
		;;
	h)	# Help/Show information
		help=$OPTARG
		if [[ $help != "help" && $help != "info" ]]
		then
			echo "${red}Bad parameter: -h $help"
			echo "${white}linuxsdoctor -h help|info${reset}"
			exit
		elif [ "$help" == "help" ]
		then
			help
			exit
		elif [ "$help" == "info" ]
		then
			cat /lib/linuxsdoctor/about.txt
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
setup) # Execute Linux's Doctor
	if [ -f /lib/linuxsdoctor/setup.sh ]
	then
		bash /lib/linuxsdoctor/setup.sh
		exit
	else
		echo "${red}It couldn't be finded Linux's Doctor setup${reset}"
		exit
	fi
;;

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
        echo "Made by ${green}@Layraaa and @Japinper ${white}| ${blue}v1.2${white}"
        echo "${purple}https://github.com/Layraaa/Linuxs-Doctor"
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
				read -r -p "${lightblue}Choose a path for generate the report ${green}(Ex: /home/user)${white} --> " reportpath
				if [ ! -d "$reportpath" ]
				then
					# Check if path exists
					echo "${red}Path doesn't exist ($reportpath)${white}"
					continue
				elif [[ $reportpath != "" ]]
				then
					if [[ $reportpath == */ ]]
					then
						# If it ends on "/", it erase it from the variable
						reportpath=$(${reportpath%?})
					fi
					break
				else
					continue
				fi
				break
			done

			# Ask if the user want send the report
			source /lib/linuxsdoctor/sendreport.sh
			menureport

			# Check the OS and start getting the data
			if [[ ! -f /etc/os-release ]]
			then
				echo "${red}It couldn't check the OS ${reset}"
				echo "It couldn't check the OS, the file /etc/os-release is not found on the system" >> /lib/linuxsdoctor/log.txt
				exit
			elif [ "$os" != "CentOS" ] && [ "$os" != "Debian" ] && [ "$os" != "Ubuntu" ] && [ "$os" != "Kali" ]
			then
				echo "${red}Your OS is not supported ${reset}"
				exit
			elif [ "$os" == "CentOS" ]
			then
				source /lib/linuxsdoctor/analysis.sh
				startanalysis
				date +"Getting system data the %D - %T" >> /lib/linuxsdoctor/log.txt
				getdataCentOS
				endanalysis
			else
				source /lib/linuxsdoctor/analysis.sh
				startanalysis
				date +"Getting system data the %D - %T" >> /lib/linuxsdoctor/log.txt
				getdataDebian
				endanalysis
			fi

			echo "${white}[${green}!${white}]${lightblue} Data collection finished!${white}"
			echo "" >> /lib/linuxsdoctor/log.txt

			# Send the report if the user checked it before
			checksendreport

			# Erase evidences or erase old evidences
			eraseevidences

			# End of the script
			endscript
		;;
		2)	# Get data from system and compare evidences

			# Check if the user want continue with the execution's script
			while true
			do
				read -r -p "${lightblue}¿Do you want continue (You must have two different folders with evidences that you want compare)?${green} [Y/N]${white} --> " chooseyn
				if [[ $chooseyn == "Y" ]] || [[ $chooseyn == "y" ]]
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
						read -r -p "${lightblue}Choose a path for generate the report ${green}(Ex: /home/user)${white} --> " reportpath
						if [ ! -d "$reportpath" ]
						then
							# Check if path exists
							echo "${red}Path doesn't exist ($reportpath)${white}"
							continue
						elif [[ $reportpath != "" ]]
						then
							if [[ $reportpath == */ ]]
							then
								# If it ends on "/", it erase it from the variable
								reportpath=$(${reportpath%?})
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
						read -r -p "${lightblue}Put the path's folder that contains the data of the first report${white} --> " firstpath
						if [ ! -d "$firstpath" ]
						then
							# Check if path exists
							echo "${red}Path doesn't exist ($firstpath)${white}"
							continue
						elif [[ $firstpath != "" ]]
						then
							if [[ $firstpath == */ ]]
							then
								# If it ends on "/", it erase it from the variable
								firstpath=$(${firstpath%?})
							fi
							break
						else
							continue
						fi
						break
					done
					break
				elif [[ $chooseyn == "N" ]] || [[ $chooseyn == "n" ]]
				then
					clear
					linuxsdoctor -l classic
				else
					continue
				fi
				break
			done

			# Ask if the user want send the report
			source /lib/linuxsdoctor/sendreport.sh
			menureport

			# Check the OS and start getting the data
			if [[ ! -f /etc/os-release ]]
			then
				echo "${red}It couldn't check the OS ${reset}"
				echo "It couldn't check the OS, the file /etc/os-release is not found on the system" >> /lib/linuxsdoctor/log.txt
				exit
			elif [ "$os" != "CentOS" ] && [ "$os" != "Debian" ] && [ "$os" != "Ubuntu" ] && [ "$os" != "Kali" ]
			then
				echo "${red}Your OS is not supported ${reset}"
				exit
			elif [ "$os" == "CentOS" ]
			then
				source /lib/linuxsdoctor/analysis.sh
				startanalysis
				date +"Getting system data the %D - %T" >> /lib/linuxsdoctor/log.txt
				getdataCentOS
				endanalysis
			else
				source /lib/linuxsdoctor/analysis.sh
				startanalysis
				date +"Getting system data the %D - %T" >> /lib/linuxsdoctor/log.txt
				getdataDebian
				endanalysis
			fi

			# Comparision of evidences
			source /lib/linuxsdoctor/comparision.sh
			checkcomparisions

			echo "${white}[${green}!${white}]${lightblue} All comparisions are ended!"
			echo ""
			echo "${white}[${green}!${white}]${lightblue} Data collection finished!${white}"
			echo "" >> /lib/linuxsdoctor/log.txt

			# Send the report if the user checked it before
			checksendreport

			# Erase evidences or erase old evidences
			eraseevidences

			# End of the script
			endscript
		;;
		3)	# Compare evidences

			# Check if the user want continue with the execution's script
			while true
			do
				read -r -p "${lightblue}¿Do you want continue (You must have two different folders with evidences that you want compare)?${green} [Y/N]${white} --> " chooseyn
				if [[ $chooseyn == "Y" ]] || [[ $chooseyn == "y" ]]
				then
					# Ask for the path where it's the first report
					while true
					do
						read -r -p "${lightblue}Put the path's folder that contains the data of the first report${white} --> " firstpath
						if [ ! -d "$firstpath" ]
						then
							# Check if path exists
							echo "${red}Path doesn't exist ($firstpath)${white}"
							continue
						elif [ "$firstpath" != "" ]
						then
							if [[ "$firstpath" == */ ]]
							then
								# If it ends on "/", it erase it from the variable
								firstpath=$(${firstpath%?})
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
						read -r -p "${lightblue}Put the path's folder that contains the data of the second report${white} --> " datapath
						if [ ! -d "$datapath" ]
						then
							# Check if path exists
							echo "${red}Path doesn't exist ($datapath)${white}"
							continue
						elif [ "$datapath" != "" ]
						then
							if [[ "$datapath" == */ ]]
							then
								# If it ends on "/", it erase it from the variable
								datapath=$(${datapath%?})
							fi
							break
						else
							continue
						fi
						break
					done
					
				elif [[ $chooseyn == "N" ]] || [[ $chooseyn == "n" ]]
				then
					clear
					linuxsdoctor -l classic
				elif [ -z "$chooseyn" ]
				then
					echo "You didn't put any value"
					continue
				else
					continue
				fi
				break
			done

			# Comparision of evidences
			source /lib/linuxsdoctor/comparision.sh
			checkcomparisions

			# Send the report if the user checked it before
			source /lib/linuxsdoctor/sendreport.sh
			checksendreport

			# End of the script
			endscript
		;;
		4)	# Show information of the script

			# Show info
			echo ""
			cat /lib/linuxsdoctor/about.txt
			echo "${reset}"
			exit
		;;
		5)	#Exit
			echo "${reset}"
			exit
		;;
		esac
	done
;;
terminal) # Terminal Mode

	echo ""

	# Check if no parameters was passed
	if [ -z "$menu" ]
	then
		echo "${red}It didn't detect any option"
		echo "${white}linuxsdoctor -l terminal -m 1|2|3${reset}"
		exit
	fi

    case $menu in
    1)	# Get data from system

		if [ -z "$reportpath" ]
		then
			# Check if it has a value
			echo "${red}You didn't put a path"
			echo "${white}linuxsdoctor -l terminal -r /example/of/path${reset}"
			exit
        elif [ ! -d "$reportpath" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($reportpath)${reset}"
            exit
        elif [[ $reportpath == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            reportpath=${reportpath%?}
        fi

        # Check the OS and start getting the data
        if [[ ! -f /etc/os-release ]]
        then
            echo "${red}It couldn't check the OS ${reset}"
            echo "It couldn't check the OS, the file /etc/os-release is not found on the system" >> /lib/linuxsdoctor/log.txt
            exit
        elif [ "$os" != "CentOS" ] && [ "$os" != "Debian" ] && [ "$os" != "Ubuntu" ] && [ "$os" != "Kali" ]
        then
            echo "${red}Your OS is not supported ${reset}"
            exit
        elif [ "$os" == "CentOS" ]
        then
            source /lib/linuxsdoctor/analysis.sh
            startanalysis
            date +"Getting system data the %D - %T" >> /lib/linuxsdoctor/log.txt
            getdataCentOS
            endanalysis
        else
            source /lib/linuxsdoctor/analysis.sh
            startanalysis
            date +"Getting system data the %D - %T" >> /lib/linuxsdoctor/log.txt
            getdataDebian
            endanalysis
        fi

        echo "${white}[${green}!${white}]${lightblue} Data collection finished!${white}"
        echo "" >> /lib/linuxsdoctor/log.txt

		# Zip and send evidences to external mediums
		zipandsend

		# Erase evidences or erase old evidences
		eraseevidences
		
        # End script
		endscript
    ;;
    2)	# Get data from system and compare evidences

        if [ -z "$reportpath" ]
		then
			# Check if it has a value
			echo "${red}You didn't put a path"
			echo "${white}linuxsdoctor -l classic|terminal -r /example/of/path -e /example/of/path${reset}"
			exit
        elif [ ! -d "$reportpath" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($reportpath)${reset}"
            exit
        elif [[ $reportpath == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            reportpath=${reportpath%?}
        fi

        if [ -z "$firstpath" ]
		then
			# Check if it has a value
			echo "${red}You didn't put a path"
			echo "${white}linuxsdoctor -l classic|terminal -r /example/of/path -e /example/of/path${reset}"
			exit
        elif [ ! -d "$firstpath" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($firstpath)${reset}"
            exit
        elif [[ $firstpath == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            firstpath=${firstpath%?}
        fi


        # Check the OS and start getting the data
        if [[ ! -f /etc/os-release ]]
        then
            echo "${red}It couldn't check the OS ${reset}"
            echo "It couldn't check the OS, the file /etc/os-release is not found on the system" >> /lib/linuxsdoctor/log.txt
            exit
        elif [ "$os" != "CentOS" ] && [ "$os" != "Debian" ] && [ "$os" != "Ubuntu" ] && [ "$os" != "Kali" ]
        then
            echo "${red}Your OS is not supported ${reset}"
            exit
        elif [ "$os" == "CentOS" ]
        then
            source /lib/linuxsdoctor/analysis.sh
            startanalysis
            date +"Getting system data the %D - %T" >> /lib/linuxsdoctor/log.txt
            getdataCentOS
            endanalysis
        else
            source /lib/linuxsdoctor/analysis.sh
            startanalysis
            date +"Getting system data the %D - %T" >> /lib/linuxsdoctor/log.txt
            getdataDebian
            endanalysis
        fi

        echo "${white}[${green}!${white}]${lightblue} Data collection finished!${white}"
        echo "" >> /lib/linuxsdoctor/log.txt

		# Checking analysis.txt files
        if [[ ! -f $firstpath/analysis.txt || ! -f $datapath/analysis.txt ]]
        then
            echo "${red}File not found: analysis.txt${reset}"
            exit
        elif [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') ]]
        then
            echo "${red}We detected different OS ($(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') / $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }'))${reset}"
            exit
        fi

        if [[ $(sed '9q;d' "$firstpath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') != $(sed '9q;d' "$datapath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') ]]
        then
            echo "${red}We detected different versions of Linux's Doctor ($(sed '9q;d' "$firstpath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') / $(sed '9q;d' "$datapath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }'))${reset}"
            exit
        fi

        if [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]]
        then
            echo "${red}We detected an unsupported OS ($(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }'))${white}"
			echo "By all means, evidences' comparision will start"
        fi

        if [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]]
        then
            comparisions_os="Debian"
        else
            comparisions_os="CentOS"
        fi
        
		# Comparision of evidences
        source /lib/linuxsdoctor/comparision.sh
        comparisions$comparisions_os

		# Zip and send evidences to external mediums
		zipandsend

		# Erase evidences or erase old evidences
		eraseevidences

        # End script
		endscript
    ;;
    3)	# Compare evidences

        reportpath=$datapath

        if [ -z "$datapath" ]
		then
			# Check if it has a value
			echo "${red}You didn't put a path"
			echo "${white}linuxsdoctor -l classic|terminal -r /example/of/path -e /example/of/path${reset}"
			exit
        elif [ ! -d "$datapath" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($datapath)${reset}"
            exit
        elif [[ $datapath == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            datapath=${datapath%?}
        fi

        if [ -z "$firstpath" ]
		then
			# Check if it has a value
			echo "${red}You didn't put a path"
			echo "${white}linuxsdoctor -l classic|terminal -r /example/of/path -e /example/of/path${reset}"
			exit
        elif [ ! -d "$firstpath" ]
        then
            # Check if path exists
            echo "${red}Path doesn't exist ($firstpath)${reset}"
            exit
        elif [[ $firstpath == */ ]]
        then
            # If it ends on "/", it erase it from the variable
            firstpath=${firstpath%?}
        fi

		# Checking analysis.txt files
        if [[ ! -f $firstpath/analysis.txt || ! -f $datapath/analysis.txt ]]
        then
            echo "${red}File not found: analysis.txt${reset}"
            exit
        elif [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') ]]
        then
            echo "${red}We detected different OS ($(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') / $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }'))${reset}"
            exit
        fi

        if [[ $(sed '9q;d' "$firstpath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') != $(sed '9q;d' "$datapath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') ]]
        then
            echo "${red}We detected different versions of Linux's Doctor ($(sed '9q;d' "$firstpath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') / $(sed '9q;d' "$datapath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }'))${reset}"
            exit
        fi

        if [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]]
        then
            echo "${red}We detected an unsupported OS ($(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }'))${white}"
			echo "By all means, evidences' comparision will start"
        fi

        if [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]]
        then
            comparisions_os="Debian"
        else
            comparisions_os="CentOS"
        fi

		# Comparision of evidences
        source /lib/linuxsdoctor/comparision.sh
        comparisions$comparisions_os

		# Zip and send evidences to external mediums
		zipandsend

        # End script
		endscript
	;;
    esac
;;
esac

# Show help message as default behaviour
help
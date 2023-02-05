#!/bin/bash
# Linux's Doctor: Made by @Layraaa and @Japinper
#
# setup.sh
# Linux's Doctor Setup

# Define colors
red="$(tput setaf 1)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"
white="$(tput setaf 7)"
lightblue="$(tput setaf 117)"
purple="$(tput setaf 135)"
reset="$(tput sgr0)"

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

# Enter in script's folder for install if it's not on /lib/linuxsdoctor (so Linux's Doctor is not installed)
if [ ! -f /lib/linuxsdoctor/setup.sh ]
then
	cd "$(dirname "$0")"
fi

# If setuplog.txt doesn't exist, it creates the file
if [[ -d /lib/linuxsdoctor/ ]]
then
	if [[ ! -f /lib/linuxsdoctor/setuplog.txt ]]
	then
		touch /lib/linuxsdoctor/setuplog.txt
	fi
	setuplog="/lib/linuxsdoctor/setuplog.txt"
elif [ ! -f setuplog.txt ]
then
	touch setuplog.txt
	setuplog="setuplog.txt"
else
	setuplog="setuplog.txt"
fi

date +"Setup execution made the %D - %T" >> $setuplog

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
	echo "${purple}1) ${lightblue}Install Linux's Doctor and dependences"
	echo "${purple}2) ${lightblue}Install/Update LiME (Needed for Dump RAM)"
	echo "${purple}3) ${lightblue}Install/Update shc (Needed for send evidences and reports)"
	echo "${purple}4) ${lightblue}Generate file for send evidences to FTP Server"
	echo "${purple}5) ${lightblue}Generate file for send evidences to Telegram"
	echo "${purple}6) ${lightblue}Generate file for send HTML report to FTP Server"
	echo "${purple}7) ${lightblue}Generate file for send analysis notification to MySQL DB Server"
	echo "${purple}8) ${lightblue}Generate file for send analysis notification to Telegram"
	echo "${purple}9) ${lightblue}Edit file.conf"
	echo "${purple}10) ${lightblue}Update Linux's Doctor"
	echo "${purple}11) ${lightblue}Update Linux's Doctor dependences"
	echo "${purple}12) ${lightblue}Unistall Linux's Doctor"
	echo "${purple}99) ${lightblue}Exit"
	echo ""
	read -r -p "${lightblue}¿What do you want to do? --> ${white}" menu

    # Detect the OS
    os=$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')

	case $menu in
	1) # Install Linux's Doctor and dependences
		
		if [ ! -d linuxsdoctor ] # Check if user didn't delete the linuxsdoctor folder
		then
			echo "${red}It couldn't be finded linuxsdoctor folder${reset}"
			exit
		elif [ -d /lib/linuxsdoctor ] # Check if Linux's Doctor is installed
		then
			echo "${red}It has been finded /lib/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		elif [ -L /usr/bin/linuxsdoctor ] # Check if in system there is a symbolic link called "linuxsdoctor"
		then
			echo "${red}It has been finded /usr/bin/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		fi

        # Choose OS
        case $os in
            Debian) # Debian install
	
				# Show dependences
				debiandependences=(coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip lsof inxi lshw lsscsi ethtool sysstat)

				while true
				do

					while true
					do
						read -r -p "¿Do you want update the system? ${green}[Y/N]${white} --> " updatesystem # Check if user want update the system
						if [[ $updatesystem == "Y" ]] || [[ $updatesystem == "y" ]] || [[ $updatesystem == "N" ]] || [[ $updatesystem == "n" ]]
						then
							break
						else
							continue
						fi
					done

					echo "It will be installed these dependeces:"
					for i in "${debiandependences[@]}"
					do
						if [ "$(dpkg-query -W -f='${Status}' "$i" 2>/dev/null | grep -c "ok installed")" -eq 1 ]
						then
							echo "${white}[${green}+${white}] ${lightblue}$i"
						else
							echo "${white}[${red}-${white}] ${lightblue}$i"
						fi
					done
					echo ""
					read -r -p "Do you want continue? ${green}[Y/N]${white}  --> " checkinstall

					if [[ $checkinstall == "Y" ]] || [[ $checkinstall == "y" ]] # Make install
					then
						echo "Making install for Debian" >> $setuplog
						echo "" >> $setuplog

						# Update system if it was inidicated
						if [[ $updatesystem == "Y" ]] || [[ $updatesystem == "y" ]]
						then
							date +"Updating system from Linux's Doctor Setup the %D - %T" >> $setuplog
							echo ""
							echo "${white}[${red}*${white}]${lightblue} Updating..."
							apt-get update -y && apt-get upgrade -y >> $setuplog 2>&1
						fi

						# Dependences' installation
						date +"Installing dependences for Debian the %D - %T" >> $setuplog
						echo ""
						echo "${white}[${red}*${white}]${lightblue} Staring dependences' installation for Debian..."
						count=0
						for i in "${debiandependences[@]}"
						do
							count=$(( count + 1 ))
							apt-get install "$i" -y >> $setuplog 2>&1
							if [ "$?" -eq 0 ]
							then
								echo "${white}[${green}$count/${#debiandependences[@]}${white}] ${lightblue} $i"
							else
								echo "${white}[${red}$count/${#debiandependences[@]}${white}] ${lightblue} $i"
							fi
						done

						# Move Linux's Doctor to /lib
						mv linuxsdoctor /lib >> $setuplog 2>&1

						if [ ! -d /lib/linuxsdoctor ] # Check if something went wrong
						then
							echo "${red}Something went wrong, check the log file${reset}"
							exit
						fi

						# Move data to /lib/linuxsdoctor
						mv setup.sh setuplog.txt LICENSE README.md /lib/linuxsdoctor

						# Create link
						ln -s /lib/linuxsdoctor/linuxsdoctor.sh /usr/bin/linuxsdoctor
						chmod 700 /lib/linuxsdoctor/linuxsdoctor.sh

						# End of installation
						date +"End of installation the %D - %T" >> /lib/linuxsdoctor/setuplog.txt
						echo "" >> $setuplog
						echo ""
						echo "${white}[${green}!${white}] ${lightblue}Installation completed!"
						echo "${white}[${green}!${white}] ${lightblue}Remember check '/lib/linuxsdoctor/file.conf' for fill the configuration file${white}"
						echo "${white}[${green}!${white}] ${lightblue}Write 'linuxsdoctor' in terminal :)"
						break

					elif [[ $checkinstall == "N" ]] || [[ $checkinstall == "n" ]] # Don't make install
					then
						echo "${reset}"
						exit
					else
						continue
					fi
					break
				done
            ;;
            Ubuntu) # Ubuntu install
			
				# Show dependences
				ubuntudependences=(coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip lsof inxi lshw lsscsi ethtool sysstat)

				while true
				do

					while true
					do
						read -r -p "¿Do you want update the system? ${green}[Y/N]${white} --> " updatesystem # Check if user want update the system
						if [[ $updatesystem == "Y" ]] || [[ $updatesystem == "y" ]] || [[ $updatesystem == "N" ]] || [[ $updatesystem == "n" ]]
						then
							break
						else
							continue
						fi
					done

					echo "It will be installed these dependeces:"
					for i in "${ubuntudependences[@]}"
					do
						if [ "$(dpkg-query -W -f='${Status}' "$i" 2>/dev/null | grep -c "ok installed")" -eq 1 ]
						then
							echo "${white}[${green}+${white}] ${lightblue}$i"
						else
							echo "${white}[${red}-${white}] ${lightblue}$i"
						fi
					done
					echo ""
					read -r -p "Do you want continue? ${green}[Y/N]${white}  --> " checkinstall

					if [[ $checkinstall == "Y" ]] || [[ $checkinstall == "y" ]] # Make install
					then
						echo "Making install for Ubuntu" >> $setuplog
						echo "" >> $setuplog

						# Update system if it was inidicated
						if [[ $updatesystem == "Y" ]] || [[ $updatesystem == "y" ]]
						then
							date +"Updating system from Linux's Doctor Setup the %D - %T" >> $setuplog
							echo ""
							echo "${white}[${red}*${white}]${lightblue} Updating..."
							apt-get update -y && apt-get upgrade -y >> $setuplog 2>&1
						fi

						# Dependences' installation
						date +"Installing dependences for Ubuntu the %D - %T" >> $setuplog
						echo ""
						echo "${white}[${red}*${white}]${lightblue} Staring dependences' installation for Ubuntu..."
						count=0
						for i in "${ubuntudependences[@]}"
						do
							count=$(( count + 1 ))
							apt-get install "$i" -y >> $setuplog 2>&1
							if [ "$?" -eq 0 ]
							then
								echo "${white}[${green}$count/${#ubuntudependences[@]}${white}] ${lightblue} $i"
							else
								echo "${white}[${red}$count/${#ubuntudependences[@]}${white}] ${lightblue} $i"
							fi
						done

						# Move Linux's Doctor to /lib
						mv linuxsdoctor /lib >> $setuplog 2>&1

						if [ ! -d /lib/linuxsdoctor ] # Check if something went wrong
						then
							echo "${red}Something went wrong, check the log file${reset}"
							exit
						fi

						# Move data to /lib/linuxsdoctor
						mv setup.sh setuplog.txt LICENSE README.md /lib/linuxsdoctor

						# Create link
						ln -s /lib/linuxsdoctor/linuxsdoctor.sh /usr/bin/linuxsdoctor
						chmod 700 /lib/linuxsdoctor/linuxsdoctor.sh

						# End of installation
						date +"End of installation the %D - %T" >> /lib/linuxsdoctor/setuplog.txt
						echo "" >> $setuplog
						echo ""
						echo "${white}[${green}!${white}] ${lightblue}Installation completed!"
						echo "${white}[${green}!${white}] ${lightblue}Remember check '/lib/linuxsdoctor/file.conf' for fill the configuration file${white}"
						echo "${white}[${green}!${white}] ${lightblue}Write 'linuxsdoctor' in terminal :)"
						break

					elif [[ $checkinstall == "N" ]] || [[ $checkinstall == "n" ]] # Don't make install
					then
						echo "${reset}"
						exit
					else
						continue
					fi
					break
				done
	        ;;
            Kali) # Kali Linux install

				# Show dependences
				kalidependences=(coreutils findutils dpkg util-linux login runit-init net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip lsof inxi lshw lsscsi ethtool sysstat)

				while true
				do
					while true
					do
						read -r -p "¿Do you want update the system? ${green}[Y/N]${white} --> " updatesystem # Check if user want update the system
						if [[ $updatesystem == "Y" ]] || [[ $updatesystem == "y" ]] || [[ $updatesystem == "N" ]] || [[ $updatesystem == "n" ]]
						then
							break
						else
							continue
						fi
					done

					echo "It will be installed these dependeces:"
					for i in "${kalidependences[@]}"
					do
						if [ "$(dpkg-query -W -f='${Status}' "$i" 2>/dev/null | grep -c "ok installed")" -eq 1 ]
						then
							echo "${white}[${green}+${white}] ${lightblue} $i"
						else
							echo "${white}[${red}-${white}] ${lightblue} $i"
						fi
					done
					echo ""
					read -r -p "Do you want continue? ${green}[Y/N]${white}  --> " checkinstall

					if [[ $checkinstall == "Y" ]] || [[ $checkinstall == "y" ]] # Make install
					then
						echo "Making install for Kali Linux" >> $setuplog
						echo "" >> $setuplog

						# Update system if it was inidicated
						if [[ $updatesystem == "Y" ]] || [[ $updatesystem == "y" ]]
						then
							date +"Updating system from Linux's Doctor Setup the %D - %T" >> $setuplog
							echo ""
							echo "${white}[${red}*${white}]${lightblue} Updating..."
							apt-get update -y && apt-get upgrade -y >> $setuplog 2>&1
						fi

						# Dependences' installation
						date +"Installing dependences for Kali Linux the %D - %T" >> $setuplog
						echo ""
						echo "${white}[${red}*${white}]${lightblue} Staring dependences' installation for Kali Linux..."
						count=0
						for i in "${kalidependences[@]}"
						do
							count=$(( count + 1 ))
							apt-get install "$i" -y >> $setuplog 2>&1
							if [ "$?" -eq 0 ]
							then
								echo "${white}[${green}$count/${#kalidependences[@]}${white}] ${lightblue} $i"
							else
								echo "${white}[${red}$count/${#kalidependences[@]}${white}] ${lightblue} $i"
							fi
						done

						# Move Linux's Doctor to /lib
						mv linuxsdoctor /lib >> $setuplog 2>&1

						if [ ! -d /lib/linuxsdoctor ] # Check if something went wrong
						then
							echo "${red}Something went wrong, check the log file${reset}"
							exit
						fi

						# Move data to /lib/linuxsdoctor
						mv setup.sh setuplog.txt LICENSE README.md /lib/linuxsdoctor

						# Create link
						ln -s /lib/linuxsdoctor/linuxsdoctor.sh /usr/bin/linuxsdoctor
						chmod 700 /lib/linuxsdoctor/linuxsdoctor.sh

						# End of installation
						date +"End of installation the %D - %T" >> /lib/linuxsdoctor/setuplog.txt
						echo "" >> $setuplog
						echo ""
						echo "${white}[${green}!${white}] ${lightblue}Installation completed!"
						echo "${white}[${green}!${white}] ${lightblue}Remember check '/lib/linuxsdoctor/file.conf' for fill the configuration file${white}"
						echo "${white}[${green}!${white}] ${lightblue}Write 'linuxsdoctor' in terminal :)"
						break

					elif [[ $checkinstall == "N" ]] || [[ $checkinstall == "n" ]] # Don't make install
					then
						echo "${reset}"
						exit
					else
						continue
					fi
					break
				done
            ;;
            CentOS) #CentOS install

				# Show dependences
				centosdependences=(coreutils findutils dpkg util-linux systemd net-tools git make build-essential kernel-devel gcc bind-utils linux-headers-"$(uname -r)" lsof inxi lshw lsscsi ethtool sysstat)

				while true
				do

					while true
					do
						read -r -p "¿Do you want update the system? ${green}[Y/N]${white} --> " updatesystem # Check if user want update the system
						if [[ $updatesystem == "Y" ]] || [[ $updatesystem == "y" ]] || [[ $updatesystem == "N" ]] || [[ $updatesystem == "n" ]]
						then
							break
						else
							continue
						fi
					done

					echo "It will be installed these dependeces:"
					for i in "${centosdependences[@]}"
					do
						if [ "$(rpm -q "$i" && echo $?)" -eq 0 ]
						then
							echo "${white}[${green}+${white}] ${lightblue} $i"
						else
							echo "${white}[${red}-${white}] ${lightblue} $i"
						fi
					done
					echo ""
					read -r -p "Do you want continue? ${green}[Y/N]${white}  --> " checkinstall

					if [[ $checkinstall == "Y" ]] || [[ $checkinstall == "y" ]] # Make install
					then
						echo "Making install for CentOS" >> $setuplog
						echo "" >> $setuplog

						# Update system if it was inidicated
						if [[ $updatesystem == "Y" ]] || [[ $updatesystem == "y" ]]
						then
							date +"Updating system from Linux's Doctor Setup the %D - %T" >> $setuplog
							echo ""
							echo "${white}[${red}*${white}]${lightblue} Updating..."
							yum update -y >> $setuplog 2>&1
						fi

						# Dependences' installation
						date +"Installing dependences for CentOS the %D - %T" >> $setuplog
						echo ""
						echo "${white}[${red}*${white}]${lightblue} Staring dependences' installation for CentOS..."
						count=0
						for i in "${centosdependences[@]}"
						do
							count=$(( count + 1 ))
							yum install "$i" -y >> $setuplog 2>&1
							if [ "$?" -eq 0 ]
							then
								echo "${white}[${green}$count/${#centosdependences[@]}${white}] ${lightblue} $i"
							else
								echo "${white}[${red}$count/${#centosdependences[@]}${white}] ${lightblue} $i"
							fi
						done

						# Move Linux's Doctor to /lib
						mv linuxsdoctor /lib >> $setuplog 2>&1

						if [ ! -d /lib/linuxsdoctor ] # Check if something went wrong
						then
							echo "${red}Something went wrong, check the log file${reset}"
							exit
						fi

						# Move data to /lib/linuxsdoctor
						mv setup.sh setuplog.txt LICENSE README.md /lib/linuxsdoctor

						# Create link
						ln -s /lib/linuxsdoctor/linuxsdoctor.sh /usr/bin/linuxsdoctor
						chmod 700 /lib/linuxsdoctor/linuxsdoctor.sh

						# End of installation
						date +"End of installation the %D - %T" >> /lib/linuxsdoctor/setuplog.txt
						echo "" >> $setuplog
						echo ""
						echo "${white}[${green}!${white}] ${lightblue}Installation completed!"
						echo "${white}[${green}!${white}] ${lightblue}Remember check '/lib/linuxsdoctor/file.conf' for fill the configuration file${white}"
						echo "${white}[${green}!${white}] ${lightblue}Write 'linuxsdoctor' in terminal :)"
						break

					elif [[ $checkinstall == "N" ]] || [[ $checkinstall == "n" ]] # Don't make install
					then
						echo "${reset}"
						exit
					else
						continue
					fi
					break
				done
            ;;
            *)
                echo "${red}We don't have support for your OS :(${reset}"
                exit
        esac
		break
	;;
	2) # Install/Update LiME (Needed for Dump RAM)
		
		# Check if LiME is installed
		if [ -d /lib/linuxsdoctor/LiME ]
		then
			while true
			do
				read -r -p "${red}LiME is installed on your system. ${white}Do you want update it? ${green}[Y/N]${white} --> " checkupdate
				if [[ $checkupdate == "Y" ]] || [[ $checkupdate == "y" ]] # Update LiME
				then
					echo ""
					echo "${white}[${red}*${white}] ${lightblue}Updating LiME..."
					echo ""
					rm -rf /lib/linuxsdoctor/LiME
					break
				elif [[ $checkupdate == "N" ]] || [[ $checkupdate == "n" ]] # Don't update LiME
				then
					echo "${reset}"
					exit
				else
					continue
				fi
			done
		else
			echo ""
			echo "${white}[${red}*${white}] ${lightblue}Installing LiME..."
			echo ""	
		fi

		git clone https://github.com/504ensicsLabs/LiME >> $setuplog 2>&1

		if [ -d LiME ]
		then
			{
				cd LiME/src/ && make && cd .. && cd ..
				mv LiME /lib/linuxsdoctor
			} >> $setuplog 2>&1
			echo "${white}[${green}!${white}] ${lightblue}LiME was installed correctly!"
		else
			echo "${white}[${green}!${white}] ${lightblue}It couldn't be installed LiME, check the log :("
		fi
		break
	;;
	3) # Install/Update shc (Needed for send evidences and reports)

        # Choose OS
        case $os in
		Debian | Ubuntu | Kali)

			# Check if shc is installed
			if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 0 ]
			then
				while true
				do
					echo ""
					echo "${white}SHC is needed for securize your credentials in connections made by Linux's Doctor"
					read -r -p "Do you want install it? ${green}[Y/N]${white} --> " checkshc
					if [[ $checkshc == "Y" ]] || [[ $checkshc == "y" ]] # Install shc
					then
						echo "Installation SHC the %D - %T" >> $setuplog
						echo ""
						echo "${white}[${red}*${white}] ${lightblue}Installing shc..."
						apt-get install shc -y >> $setuplog 2>&1
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ]
						then
							echo ""
							echo "${white}[${green}+${white}] ${lightblue} SHC was installed succesfully!"
							break
						else
							echo ""
							echo "${white}[${green}-${white}] ${lightblue} Something happend that SHC couldn't be installed, check the log file ${reset}"
							exit
						fi
					elif [[ $checkshc == "N" ]] || [[ $checkshc == "n" ]] # Don't install shc
					then
						echo "${reset}"
						exit
					else
						continue
					fi
				done
			else
				while true
				do
					echo "${white}SHC is installed in your system"
					read -r -p "Do you want update it? ${green}[Y/N]${white} --> " checkshc
					if [[ $checkshc == "Y" ]] || [[ $checkshc == "y" ]] # Update shc
					then
						echo "Update SHC the %D - %T" >> $setuplog
						echo "${white}[${red}*${white}] ${lightblue}Updating shc..."
						apt-get install shc -y >> $setuplog 2>&1
						break
					elif [[ $checkshc == "N" ]] || [[ $checkshc == "n" ]] # Don't update shc
					then
						echo "${reset}"
						exit
					else
						continue
					fi
				done
			fi

		;;
		CentOS)

			# Check if shc is installed
			if [ "$(rpm -q shc && echo $?)" -eq 0 ]
			then
				while true
				do
					echo ""
					echo "${white}SHC is needed for securize your credentials in connections made by Linux's Doctor"
					read -r -p "Do you want install it? ${green}[Y/N]${white} --> " checkshc
					if [[ $checkshc == "Y" ]] || [[ $checkshc == "y" ]] # Install shc
					then
						echo "Installation SHC the %D - %T" >> $setuplog
						echo ""
						echo "${white}[${red}*${white}] ${lightblue}Installing shc..."
						yum install shc -y >> $setuplog 2>&1
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ]
						then
							echo ""
							echo "${white}[${green}+${white}] ${lightblue} SHC was installed succesfully!"
							break
						else
							echo ""
							echo "${white}[${green}-${white}] ${lightblue} Something happend that SHC couldn't be installed, check the log file ${reset}"
							exit
						fi
					elif [[ $checkshc == "N" ]] || [[ $checkshc == "n" ]] # Don't install shc
					then
						echo "${reset}"
						exit
					else
						continue
					fi
				done
			else
				while true
				do
					echo "${white}SHC is installed in your system"
					read -r -p "Do you want update it? ${green}[Y/N]${white} --> " checkshc
					if [[ $checkshc == "Y" ]] || [[ $checkshc == "y" ]] # Update shc
					then
						echo "Update SHC the %D - %T" >> $setuplog
						echo "${white}[${red}*${white}] ${lightblue}Updating shc..."
						yum install shc -y >> $setuplog 2>&1
						break
					elif [[ $checkshc == "N" ]] || [[ $checkshc == "n" ]] # Don't update shc
					then
						echo "${reset}"
						exit
					else
						continue
					fi
				done
			fi
		;;
		*)
			echo "${red}We don't have support for your OS :(${reset}"
			exit
		;;
		esac
		break
	;;
	4) # Generate file for send evidences to FTP Server

		if [ ! -d /lib/linuxsdoctor ] # Check if Linux's Doctor is installed
		then
			echo "${red}It hasn't been finded /lib/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		elif [ ! -L /usr/bin/linuxsdoctor ] # Check if in system there is a symbolic link called "linuxsdoctor"
		then
			echo "${red}It hasn't been finded /usr/bin/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		fi

		# Choose OS
        case $os in
		Debian | Ubuntu | Kali)
			while true
			do
				# Check dependences
				if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.evidencesftp ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask user
						do
							read -r -p "${white}FTP user: --> " user
							if [ -z "$user" ]
							then
								continue
							fi
							break
						done

						while true # Ask password
						do
							read -r -s -p "${white}FTP password: --> " password
							if [ -z "$password" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm password
						do
							read -r -s -p "${white}Confirm FTP password: --> " confirmpassword
							if [ -z "$confirmpassword" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$password" == "$confirmpassword" ] # Check if passwords match
						then
							echo "${white}[${green}!${white}] ${lightblue}Passwords match!${white}"
							publicpassword=$(echo "$password" | tr -c \\n \*)
						else
							echo "${red}Password don't match${reset}"
							exit
						fi

						while true # Ask server
						do
							read -r -p "${white}FTP Server: --> " server
							if [ -z "$server" ]
							then
								continue
							fi
							break
						done

						while true
						do
							echo ""
							echo "${white}These are your configurations:"
							echo "${lightblue}User:${white} $user"
							echo "${lightblue}Password:${white} $publicpassword"
							echo "${lightblue}Server:${white} $server"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(curl -u "$user:$password" ftp://"$server" 2>&1)" # Connection succesful
									then
										# Generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo "$user":"$password" ftp://"$server" | base64)
										touch /lib/linuxsdoctor/.evidencesftp.sh
										{
											echo "#!/bin/bash"
											echo curl -T '"$datapathzip"' -u' $(echo' "$base64" '| base64 --decode)'

										} >> /lib/linuxsdoctor/.evidencesftp.sh

										shc -U -f /lib/linuxsdoctor/.evidencesftp.sh -o /lib/linuxsdoctor/.evidencesftp
										shred -zu -n32 /lib/linuxsdoctor/.evidencesftp.sh
										rm -rf  /lib/linuxsdoctor/.evidencesftp.sh.x.c
										chmod 700 /lib/linuxsdoctor/.evidencesftp

										if [ -f /lib/linuxsdoctor/.evidencesftp ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							apt-get install -y coreutils
							apt-get install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		CentOS)
			while true
			do
				# Check dependences
				if [ "$(rpm -q shc && echo $?)" != "0" ] && [ "$(rpm -q coreutils && echo $?)" != "0" ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.evidencesftp ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask user
						do
							read -r -p "${white}FTP user: --> " user
							if [ -z "$user" ]
							then
								continue
							fi
							break
						done

						while true # Ask password
						do
							read -r -s -p "${white}FTP password: --> " password
							if [ -z "$password" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm password
						do
							read -r -s -p "${white}Confirm FTP password: --> " confirmpassword
							if [ -z "$confirmpassword" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$password" == "$confirmpassword" ] # Check if passwords match
						then
							echo "${white}[${green}!${white}] ${lightblue}Passwords match!${white}"
							publicpassword=$(echo "$password" | tr -c \\n \*)
						else
							echo "${red}Password don't match${reset}"
							exit
						fi

						while true # Ask server
						do
							read -r -p "${white}FTP Server: --> " server
							if [ -z "$server" ]
							then
								continue
							fi
							break
						done

						while true
						do
							echo ""
							echo "${white}These are your configurations:"
							echo "${lightblue}User:${white} $user"
							echo "${lightblue}Password:${white} $publicpassword"
							echo "${lightblue}Server:${white} $server"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(curl -u "$user:$password" ftp://"$server" 2>&1)" # Connection succesful
									then
										# Generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo "$user":"$password" ftp://"$server" | base64)
										touch /lib/linuxsdoctor/.evidencesftp.sh
										{
											echo "#!/bin/bash"
											echo curl -T '"$datapathzip"' -u' $(echo' "$base64" '| base64 --decode)'

										} >> /lib/linuxsdoctor/.evidencesftp.sh

										shc -U -f /lib/linuxsdoctor/.evidencesftp.sh -o /lib/linuxsdoctor/.evidencesftp
										shred -zu -n32 /lib/linuxsdoctor/.evidencesftp.sh
										rm -rf /lib/linuxsdoctor/.evidencesftp.sh.x.c
										chmod 700 /lib/linuxsdoctor/.evidencesftp

										if [ -f /lib/linuxsdoctor/.evidencesftp ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							yum install -y coreutils
							yum install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		esac
		break
	;;
	5) # Generate file for send evidences to Telegram
		
		if [ ! -d /lib/linuxsdoctor ] # Check if Linux's Doctor is installed
		then
			echo "${red}It hasn't been finded /lib/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		elif [ ! -L /usr/bin/linuxsdoctor ] # Check if in system there is a symbolic link called "linuxsdoctor"
		then
			echo "${red}It hasn't been finded /usr/bin/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		fi

		# Choose OS
        case $os in
		Debian | Ubuntu | Kali)
			while true
			do
				# Check dependences
				if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.evidencestelegram ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask Telegram ID
						do
							read -r -s -p "${white}Telegram ID --> " telegramid
							if [ -z "$telegramid" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm Telegram ID
						do
							read -r -s -p "${white}Confirm Telegram ID --> " confirmtelegramid
							if [ -z "$confirmtelegramid" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$telegramid" == "$confirmtelegramid" ] # Check if Telegram IDs match
						then
							echo "${white}[${green}!${white}] ${lightblue}Telegram IDs match!${white}"
							publictelegramid=$(echo "$telegramid" | tr -c \\n \*)
						else
							echo "${red}Telegram IDs don't match${reset}"
							exit
						fi

						while true
						do
							echo ""
							echo "${white}This is your configuration:"
							echo "${lightblue}Telegram ID:${white} $publictelegramid"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(curl -s -X POST "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZE1lc3NhZ2U=")" -d chat_id=$telegramid -d text="This is a connection test from Linux's Doctor" 2>&1)" # Connection succesful
									then
										# Generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo ?chat_id="$telegramid" | base64)
										touch /lib/linuxsdoctor/.evidencestelegram.sh
										{
											echo "#!/bin/bash"
											echo curl -F document=@'"$datapathzip"' "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZERvY3VtZW50")"'$(echo' "$base64" '| base64 --decode) >> /dev/null'

										} >> /lib/linuxsdoctor/.evidencestelegram.sh

										shc -U -f /lib/linuxsdoctor/.evidencestelegram.sh -o /lib/linuxsdoctor/.evidencestelegram
										shred -zu -n32 /lib/linuxsdoctor/.evidencestelegram.sh
										rm -rf /lib/linuxsdoctor/.evidencestelegram.sh.x.c
										chmod 700 /lib/linuxsdoctor/.evidencestelegram

										if [ -f /lib/linuxsdoctor/.evidencestelegram ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							apt-get install -y coreutils
							apt-get install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		CentOS)
			while true
			do
				# Check dependences
				if [ "$(rpm -q shc && echo $?)" != "0" ] && [ "$(rpm -q coreutils && echo $?)" != "0" ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.evidencestelegram ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask Telegram ID
						do
							read -r -s -p "${white}Telegram ID --> " telegramid
							if [ -z "$telegramid" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm Telegram ID
						do
							read -r -s -p "${white}Confirm Telegram ID --> " confirmtelegramid
							if [ -z "$confirmtelegramid" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$telegramid" == "$confirmtelegramid" ] # Check if Telegram IDs match
						then
							echo "${white}[${green}!${white}] ${lightblue}Telegram IDs match!${white}"
							publictelegramid=$(echo "$telegramid" | tr -c \\n \*)
						else
							echo "${red}Password don't match${reset}"
							exit
						fi

						while true
						do
							echo ""
							echo "${white}This is your configuration:"
							echo "${lightblue}Telegram ID:${white} $publictelegramid"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(curl -s -X POST "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZE1lc3NhZ2U=")" -d chat_id=$telegramid -d text="This is a connection test from Linux's Doctor" 2>&1)" # Connection succesful
									then
										# Generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo ?chat_id="$telegramid" | base64)
										touch /lib/linuxsdoctor/.evidencestelegram.sh
										{
											echo "#!/bin/bash"
											echo curl -F document=@'"$datapathzip"' "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZERvY3VtZW50")"'$(echo' "$base64" '| base64 --decode) >> /dev/null'
										} >> /lib/linuxsdoctor/.evidencestelegram.sh

										shc -U -f /lib/linuxsdoctor/.evidencestelegram.sh -o /lib/linuxsdoctor/.evidencestelegram
										shred -zu -n32 /lib/linuxsdoctor/.evidencestelegram.sh
										rm -rf /lib/linuxsdoctor/.evidencestelegram.sh.x.c
										chmod 700 /lib/linuxsdoctor/.evidencestelegram

										if [ -f /lib/linuxsdoctor/.evidencestelegram ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							yum install -y coreutils
							yum install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		esac
		break
	;;
	6) # Generate file for send HTML report to FTP Server

		if [ ! -d /lib/linuxsdoctor ] # Check if Linux's Doctor is installed
		then
			echo "${red}It hasn't been finded /lib/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		elif [ ! -L /usr/bin/linuxsdoctor ] # Check if in system there is a symbolic link called "linuxsdoctor"
		then
			echo "${red}It hasn't been finded /usr/bin/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		fi

		# Choose OS
        case $os in
		Debian | Ubuntu | Kali)
			while true
			do
				# Check dependences
				if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.htmlftp ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask user
						do
							read -r -p "${white}FTP user: --> " user
							if [ -z "$user" ]
							then
								continue
							fi
							break
						done

						while true # Ask password
						do
							read -r -s -p "${white}FTP password: --> " password
							if [ -z "$password" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm password
						do
							read -r -s -p "${white}Confirm FTP password: --> " confirmpassword
							if [ -z "$confirmpassword" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$password" == "$confirmpassword" ] # Check if passwords match
						then
							echo "${white}[${green}!${white}] ${lightblue}Passwords match!${white}"
							publicpassword=$(echo "$password" | tr -c \\n \*)
						else
							echo "${red}Password don't match${reset}"
							exit
						fi

						while true # Ask server
						do
							read -r -p "${white}FTP Server: --> " server
							if [ -z "$server" ]
							then
								continue
							fi
							break
						done

						while true
						do
							echo ""
							echo "${white}These are your configurations:"
							echo "${lightblue}User:${white} $user"
							echo "${lightblue}Password:${white} $publicpassword"
							echo "${lightblue}Server:${white} $server"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(curl -u "$user:$password" ftp://"$server" 2>&1)" # Connection succesful
									then
										# Generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo "$user":"$password" ftp://"$server" | base64)
										touch /lib/linuxsdoctor/.htmlftp.sh
										{
											echo "#!/bin/bash"
											echo curl -T '"$datapath"/report-"$date".html' -u' $(echo' "$base64" '| base64 --decode)'

										} >> /lib/linuxsdoctor/.htmlftp.sh

										shc -U -f /lib/linuxsdoctor/.htmlftp.sh -o /lib/linuxsdoctor/.htmlftp
										shred -zu -n32 /lib/linuxsdoctor/.htmlftp.sh
										rm -rf /lib/linuxsdoctor/.htmlftp.sh.x.c
										chmod 700 /lib/linuxsdoctor/.htmlftp

										if [ -f /lib/linuxsdoctor/.htmlftp ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							apt-get install -y coreutils
							apt-get install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		CentOS)
			while true
			do
				# Check dependences
				if [ "$(rpm -q shc && echo $?)" != "0" ] && [ "$(rpm -q coreutils && echo $?)" != "0" ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.htmlftp ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask user
						do
							read -r -p "${white}FTP user: --> " user
							if [ -z "$user" ]
							then
								continue
							fi
							break
						done

						while true # Ask password
						do
							read -r -s -p "${white}FTP password: --> " password
							if [ -z "$password" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm password
						do
							read -r -s -p "${white}Confirm FTP password: --> " confirmpassword
							if [ -z "$confirmpassword" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$password" == "$confirmpassword" ] # Check if passwords match
						then
							echo "${white}[${green}!${white}] ${lightblue}Passwords match!${white}"
							publicpassword=$(echo "$password" | tr -c \\n \*)
						else
							echo "${red}Password don't match${reset}"
							exit
						fi

						while true # Ask server
						do
							read -r -p "${white}FTP Server: --> " server
							if [ -z "$server" ]
							then
								continue
							fi
							break
						done

						while true
						do
							echo ""
							echo "${white}These are your configurations:"
							echo "${lightblue}User:${white} $user"
							echo "${lightblue}Password:${white} $publicpassword"
							echo "${lightblue}Server:${white} $server"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(curl -u "$user:$password" ftp://"$server" 2>&1)" # Connection succesful
									then
										# Generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo "$user":"$password" ftp://"$server" | base64)
										touch /lib/linuxsdoctor/.htmlftp.sh
										{
											echo "#!/bin/bash"
											echo curl -T '"$datapath"/report-"$date".html' -u' $(echo' "$base64" '| base64 --decode)'

										} >> /lib/linuxsdoctor/.htmlftp.sh

										shc -U -f /lib/linuxsdoctor/.htmlftp.sh -o /lib/linuxsdoctor/.htmlftp
										shred -zu -n32 /lib/linuxsdoctor/.htmlftp.sh
										rm -rf /lib/linuxsdoctor/.htmlftp.sh.x.c
										chmod 700 /lib/linuxsdoctor/.htmlftp

										if [ -f /lib/linuxsdoctor/.htmlftp ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							yum install -y coreutils
							yum install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		esac
		break
	;;
	7) # Generate file for send analysis notification to MySQL DB Server

		if [ ! -d /lib/linuxsdoctor ] # Check if Linux's Doctor is installed
		then
			echo "${red}It hasn't been finded /lib/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		elif [ ! -L /usr/bin/linuxsdoctor ] # Check if in system there is a symbolic link called "linuxsdoctor"
		then
			echo "${red}It hasn't been finded /usr/bin/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		fi

		# Choose OS
        case $os in
		Debian | Ubuntu | Kali)
			while true
			do
				# Check dependences
				if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.notificationdb ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask user
						do
							read -r -p "${white}DB user: --> " user
							if [ -z "$user" ]
							then
								continue
							fi
							break
						done

						while true # Ask password
						do
							read -r -s -p "${white}DB password: --> " password
							if [ -z "$password" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm password
						do
							read -r -s -p "${white}Confirm DB password: --> " confirmpassword
							if [ -z "$confirmpassword" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$password" == "$confirmpassword" ] # Check if passwords match
						then
							echo "${white}[${green}!${white}] ${lightblue}Passwords match!${white}"
							publicpassword=$(echo "$password" | tr -c \\n \*)
						else
							echo "${red}Password don't match${reset}"
							exit
						fi

						while true # Ask server
						do
							read -r -p "${white}DB Server: --> " server
							if [ -z "$server" ]
							then
								continue
							fi
							break
						done

						while true
						do
							echo ""
							echo "${white}These are your configurations:"
							echo "${lightblue}User:${white} $user"
							echo "${lightblue}Password:${white} $publicpassword"
							echo "${lightblue}Server:${white} $server"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(mysql -u "$user" -p"$password" -h "$server" -e "exit")" # Connection succesful
									then
										# Create database, generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""

										while true
										do
											read -r -p "Do you want install the database? ${green}[Y/N]${white} (Say Y if you didn't installed before) --> " installdatabase
											if [[ $installdatabase == "Y" ]] || [[ $installdatabase == "y" ]]
											then
												echo "${white}[${red}*${white}]${lightblue} Creating database..."
												mysql -u "$user" -p"$password" -h "$server" -e "CREATE DATABASE linuxsdoctor; USE 'linuxsdoctor'; CREATE TABLE analysis ( id int(11) PRIMARY KEY NULL AUTO_INCREMENT, ip_address tinytext DEFAULT NULL, os tinytext DEFAULT NULL, hostname tinytext DEFAULT NULL, kernerls_version tinytext DEFAULT NULL, analysis_type tinytext DEFAULT NULL, analysis_made tinytext DEFAULT NULL, analysis_start_date date NOT NULL, analysis_start_time time NOT NULL, analysis_end_date date NOT NULL, analysis_end_time time NOT NULL, dump_ram char(1) NOT NULL, send_evidences_ftp char(1) NOT NULL, send_evidences_telegram char(1) NOT NULL, send_web_report char(1) NOT NULL, linuxs_doctor_version tinytext NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci; CREATE TABLE comparisions ( id int(11) PRIMARY KEY NULL, unmodified_systems_files int NOT NULL, modified_systems_files int NOT NULL, errors_systems_files int NOT NULL, unmodified_network_configuration int NOT NULL, modified_network_configuration int NOT NULL, errors_network_configuration int NOT NULL, unmodified_systems_services int NOT NULL, modified_systems_services int NOT NULL, errors_systems_services int NOT NULL, unmodified_systems_logs int NOT NULL, modified_systems_logs int NOT NULL, errors_systems_logs int NOT NULL, unmodified_services_logs int NOT NULL, modified_services_logs int NOT NULL, errors_services_logs int NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci; ALTER TABLE comparisions ADD FOREIGN KEY (id) REFERENCES analysis(id);"
												if [ "$?" -eq 0 ]
												then
													echo "${white}[${green}!${white}]${lightblue} Database created succesfully!"
												else
													echo "${red}Something went wrong${reset}"
													exit
												fi
											elif [[ $installdatabase == "N" ]] || [[ $installdatabase == "n" ]]
											then
												break
											else
												continue
											fi
										done
										
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo mysql -u "$user" -p"$password" -h "$server" | base64)
										touch /lib/linuxsdoctor/.notificationdb.sh
										{
											echo "#!/bin/bash"
											echo 'if [ "$menu" -eq 1 ]'
											echo 'then'
											echo '$(echo' "$base64" '| base64 --decode)' -e '"USE linuxsdoctor; INSERT INTO analysis (id, ip_address, os, hostname, kernerls_version, analysis_type, analysis_made, analysis_start_date, analysis_start_time, analysis_end_date, analysis_end_time, dump_ram, send_evidences_ftp, send_evidences_telegram, send_web_report, linuxs_doctor_version) VALUES (NULL, '"'"'$ip_address'"'"', '"'"'$os'"'"', '"'"'$hostname'"'"', '"'"'$kernerls_version'"'"', '"'"'$analysis_type'"'"', '"'"'$analysis_made'"'"', '"'"'$analysis_start_date'"'"', '"'"'$analysis_start_time'"'"', '"'"'$analysis_end_date'"'"', '"'"'$analysis_end_time'"'"', '"'"'$ram'"'"', '"'"'$evidencesftp'"'"', '"'"'$evidencestelegram'"'"', '"'"'$htmlftp'"'"', '"'"'$linuxs_doctor_version'"'"');"'
											echo 'else'
											echo '$(echo' "$base64" '| base64 --decode)' -e '"USE linuxsdoctor; INSERT INTO analysis (id, ip_address, os, hostname, kernerls_version, analysis_type, analysis_made, analysis_start_date, analysis_start_time, analysis_end_date, analysis_end_time, dump_ram, send_evidences_ftp, send_evidences_telegram, send_web_report, linuxs_doctor_version) VALUES (NULL, '"'"'$ip_address'"'"', '"'"'$os'"'"', '"'"'$hostname'"'"', '"'"'$kernerls_version'"'"', '"'"'$analysis_type'"'"', '"'"'$analysis_made'"'"', '"'"'$analysis_start_date'"'"', '"'"'$analysis_start_time'"'"', '"'"'$analysis_end_date'"'"', '"'"'$analysis_end_time'"'"', '"'"'$ram'"'"', '"'"'$evidencesftp'"'"', '"'"'$evidencestelegram'"'"', '"'"'$htmlftp'"'"', '"'"'$linuxs_doctor_version'"'"'); INSERT INTO comparisions (id, unmodified_systems_files, modified_systems_files, errors_systems_files, unmodified_network_configuration, modified_network_configuration, errors_network_configuration, unmodified_systems_services, modified_systems_services, errors_systems_services, unmodified_systems_logs, modified_systems_logs, errors_systems_logs, unmodified_services_logs, modified_services_logs, errors_services_logs) VALUES (last_insert_id(), '"'"'$unmodifiedsystemsfiles'"'"', '"'"'$modifiedsystemsfiles'"'"', '"'"'$errorssystemsfiles'"'"', '"'"'$unmodifiednetworkconfiguration'"'"', '"'"'$modifiednetworkconfiguration'"'"', '"'"'$errorsnetworkconfiguration'"'"', '"'"'$unmodifiedsystemsservices'"'"', '"'"'$modifiedsystemsservices'"'"', '"'"'$errorssystemsservices'"'"', '"'"'$unmodifiedsystemslogs'"'"', '"'"'$modifiedsystemslogs'"'"', '"'"'$errorssystemslogs'"'"',  '"'"'$unmodifiedserviceslogs'"'"', '"'"'$modifiedserviceslogs'"'"', '"'"'$errorsserviceslogs'"'"')"'
											echo 'fi'
										} >> /lib/linuxsdoctor/.notificationdb.sh

										shc -U -f /lib/linuxsdoctor/.notificationdb.sh -o /lib/linuxsdoctor/.notificationdb
										shred -zu -n32 /lib/linuxsdoctor/.notificationdb.sh
										rm -rf /lib/linuxsdoctor/.notificationdb.sh.x.c
										chmod 700 /lib/linuxsdoctor/.notificationdb

										if [ -f /lib/linuxsdoctor/.notificationdb ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							apt-get install -y coreutils
							apt-get install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		CentOS)
			while true
			do
				# Check dependences
				if [ "$(rpm -q shc && echo $?)" != "0" ] && [ "$(rpm -q coreutils && echo $?)" != "0" ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.notificationdb ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask user
						do
							read -r -p "${white}DB user: --> " user
							if [ -z "$user" ]
							then
								continue
							fi
							break
						done

						while true # Ask password
						do
							read -r -s -p "${white}DB password: --> " password
							if [ -z "$password" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm password
						do
							read -r -s -p "${white}Confirm DB password: --> " confirmpassword
							if [ -z "$confirmpassword" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$password" == "$confirmpassword" ] # Check if passwords match
						then
							echo "${white}[${green}!${white}] ${lightblue}Passwords match!${white}"
							publicpassword=$(echo "$password" | tr -c \\n \*)
						else
							echo "${red}Password don't match${reset}"
							exit
						fi

						while true # Ask server
						do
							read -r -p "${white}DB Server: --> " server
							if [ -z "$server" ]
							then
								continue
							fi
							break
						done

						while true
						do
							echo ""
							echo "${white}These are your configurations:"
							echo "${lightblue}User:${white} $user"
							echo "${lightblue}Password:${white} $publicpassword"
							echo "${lightblue}Server:${white} $server"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(mysql -u "$user" -p"$password" -h "$server" -e "exit")" # Connection succesful
									then
										# Create database, generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""
										
										while true
										do
											read -r -p "Do you want install the database? ${green}[Y/N]${white} (Say Y if you didn't installed before) --> " installdatabase
											if [[ $installdatabase == "Y" ]] || [[ $installdatabase == "y" ]]
											then
												echo "${white}[${red}*${white}]${lightblue} Creating database..."
												mysql -u "$user" -p"$password" -h "$server" -e "CREATE DATABASE linuxsdoctor; USE 'linuxsdoctor'; CREATE TABLE analysis ( id int(11) PRIMARY KEY NULL AUTO_INCREMENT, ip_address tinytext DEFAULT NULL, os tinytext DEFAULT NULL, hostname tinytext DEFAULT NULL, kernerls_version tinytext DEFAULT NULL, analysis_type tinytext DEFAULT NULL, analysis_made tinytext DEFAULT NULL, analysis_start_date date NOT NULL, analysis_start_time time NOT NULL, analysis_end_date date NOT NULL, analysis_end_time time NOT NULL, dump_ram char(1) NOT NULL, send_evidences_ftp char(1) NOT NULL, send_evidences_telegram char(1) NOT NULL, send_web_report char(1) NOT NULL, linuxs_doctor_version tinytext NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci; CREATE TABLE comparisions ( id int(11) PRIMARY KEY NULL, unmodified_systems_files int NOT NULL, modified_systems_files int NOT NULL, errors_systems_files int NOT NULL, unmodified_network_configuration int NOT NULL, modified_network_configuration int NOT NULL, errors_network_configuration int NOT NULL, unmodified_systems_services int NOT NULL, modified_systems_services int NOT NULL, errors_systems_services int NOT NULL, unmodified_systems_logs int NOT NULL, modified_systems_logs int NOT NULL, errors_systems_logs int NOT NULL, unmodified_services_logs int NOT NULL, modified_services_logs int NOT NULL, errors_services_logs int NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci; ALTER TABLE comparisions ADD FOREIGN KEY (id) REFERENCES analysis(id);"
												if [ "$?" -eq 0 ]
												then
													echo "${white}[${green}!${white}]${lightblue} Database created succesfully!"
												else
													echo "${red}Something went wrong${reset}"
													exit
												fi
											elif [[ $installdatabase == "N" ]] || [[ $installdatabase == "n" ]]
											then
												break
											else
												continue
											fi
										done
										
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo mysql -u "$user" -p"$password" -h "$server" | base64)
										touch /lib/linuxsdoctor/.notificationdb.sh
										{
											echo "#!/bin/bash"
											echo 'if [ "$menu" -eq 1 ]'
											echo 'then'
											echo '$(echo' "$base64" '| base64 --decode)' -e '"USE linuxsdoctor; INSERT INTO analysis (id, ip_address, os, hostname, kernerls_version, analysis_type, analysis_made, analysis_start_date, analysis_start_time, analysis_end_date, analysis_end_time, dump_ram, send_evidences_ftp, send_evidences_telegram, send_web_report, linuxs_doctor_version) VALUES (NULL, '"'"'$ip_address'"'"', '"'"'$os'"'"', '"'"'$hostname'"'"', '"'"'$kernerls_version'"'"', '"'"'$analysis_type'"'"', '"'"'$analysis_made'"'"', '"'"'$analysis_start_date'"'"', '"'"'$analysis_start_time'"'"', '"'"'$analysis_end_date'"'"', '"'"'$analysis_end_time'"'"', '"'"'$ram'"'"', '"'"'$evidencesftp'"'"', '"'"'$evidencestelegram'"'"', '"'"'$htmlftp'"'"', '"'"'$linuxs_doctor_version'"'"');"'
											echo 'else'
											echo '$(echo' "$base64" '| base64 --decode)' -e '"USE linuxsdoctor; INSERT INTO analysis (id, ip_address, os, hostname, kernerls_version, analysis_type, analysis_made, analysis_start_date, analysis_start_time, analysis_end_date, analysis_end_time, dump_ram, send_evidences_ftp, send_evidences_telegram, send_web_report, linuxs_doctor_version) VALUES (NULL, '"'"'$ip_address'"'"', '"'"'$os'"'"', '"'"'$hostname'"'"', '"'"'$kernerls_version'"'"', '"'"'$analysis_type'"'"', '"'"'$analysis_made'"'"', '"'"'$analysis_start_date'"'"', '"'"'$analysis_start_time'"'"', '"'"'$analysis_end_date'"'"', '"'"'$analysis_end_time'"'"', '"'"'$ram'"'"', '"'"'$evidencesftp'"'"', '"'"'$evidencestelegram'"'"', '"'"'$htmlftp'"'"', '"'"'$linuxs_doctor_version'"'"'); INSERT INTO comparisions (id, unmodified_systems_files, modified_systems_files, errors_systems_files, unmodified_network_configuration, modified_network_configuration, errors_network_configuration, unmodified_systems_services, modified_systems_services, errors_systems_services, unmodified_systems_logs, modified_systems_logs, errors_systems_logs, unmodified_services_logs, modified_services_logs, errors_services_logs) VALUES (last_insert_id(), '"'"'$unmodifiedsystemsfiles'"'"', '"'"'$modifiedsystemsfiles'"'"', '"'"'$errorssystemsfiles'"'"', '"'"'$unmodifiednetworkconfiguration'"'"', '"'"'$modifiednetworkconfiguration'"'"', '"'"'$errorsnetworkconfiguration'"'"', '"'"'$unmodifiedsystemsservices'"'"', '"'"'$modifiedsystemsservices'"'"', '"'"'$errorssystemsservices'"'"', '"'"'$unmodifiedsystemslogs'"'"', '"'"'$modifiedsystemslogs'"'"', '"'"'$errorssystemslogs'"'"',  '"'"'$unmodifiedserviceslogs'"'"', '"'"'$modifiedserviceslogs'"'"', '"'"'$errorsserviceslogs'"'"')"'
											echo 'fi'
										} >> /lib/linuxsdoctor/.notificationdb.sh

										shc -U -f /lib/linuxsdoctor/.notificationdb.sh -o /lib/linuxsdoctor/.notificationdb
										shred -zu -n32 /lib/linuxsdoctor/.notificationdb.sh
										rm -rf /lib/linuxsdoctor/.notificationdb.sh.x.c
										chmod 700 /lib/linuxsdoctor/.notificationdb

										if [ -f /lib/linuxsdoctor/.notificationdb ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							yum install -y coreutils
							yum install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		esac
		break
	;;
	8) # Generate file for send analysis notification to Telegram

		if [ ! -d /lib/linuxsdoctor ] # Check if Linux's Doctor is installed
		then
			echo "${red}It hasn't been finded /lib/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		elif [ ! -L /usr/bin/linuxsdoctor ] # Check if in system there is a symbolic link called "linuxsdoctor"
		then
			echo "${red}It hasn't been finded /usr/bin/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		fi

		# Choose OS
        case $os in
		Debian | Ubuntu | Kali)
			while true
			do
				# Check dependences
				if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.notificationtelegram ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask Telegram ID
						do
							read -r -s -p "${white}Telegram ID --> " telegramid
							if [ -z "$telegramid" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm Telegram ID
						do
							read -r -s -p "${white}Confirm Telegram ID --> " confirmtelegramid
							if [ -z "$confirmtelegramid" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$telegramid" == "$confirmtelegramid" ] # Check if Telegram IDs match
						then
							echo "${white}[${green}!${white}] ${lightblue}Telegram IDs match!${white}"
							publictelegramid=$(echo "$telegramid" | tr -c \\n \*)
						else
							echo "${red}Telegram IDs don't match${reset}"
							exit
						fi

						while true
						do
							echo ""
							echo "${white}This is your configuration:"
							echo "${lightblue}Telegram ID:${white} $publictelegramid"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(curl -s -X POST "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZE1lc3NhZ2U=")" -d chat_id=$telegramid -d text="This is a connection test from Linux's Doctor" 2>&1)" # Connection succesful
									then
										# Generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo ?chat_id="$telegramid" | base64)
										touch /lib/linuxsdoctor/.notificationtelegram.sh
										{
											echo "#!/bin/bash"
											echo curl -s -X POST "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZE1lc3NhZ2U=")"'$(echo' "$base64" '| base64 --decode)' -d text='"$notificationtelegram"' '>> /dev/null'
										} >> /lib/linuxsdoctor/.notificationtelegram.sh

										shc -U -f /lib/linuxsdoctor/.notificationtelegram.sh -o /lib/linuxsdoctor/.notificationtelegram
										shred -zu -n32 /lib/linuxsdoctor/.notificationtelegram.sh
										rm -rf /lib/linuxsdoctor/.notificationtelegram.sh.x.c
										chmod 700 /lib/linuxsdoctor/.notificationtelegram

										if [ -f /lib/linuxsdoctor/.notificationtelegram ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							apt-get install -y coreutils
							apt-get install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		CentOS)
			while true
			do
				# Check dependences
				if [ "$(rpm -q shc && echo $?)" != "0" ] && [ "$(rpm -q coreutils && echo $?)" != "0" ] # Check dependences
				then
					if [ -f /lib/linuxsdoctor/.notificationtelegram ]
					then
						while true
						do
							read -r -p "It has been detected a configurated file. Do you want delete it and create a new one or exit? ${green}[Y/N]${white} --> " checkconnectionfile
							if [[ $checkconnectionfile == "Y" ]] || [[ $checkconnectionfile == "y" ]] # Delete old file and create new file
							then
								break
							elif [[ $checkconnectionfile == "N" ]] || [[ $checkconnectionfile == "n" ]] # Exit
							then
								echo "${reset}"
								exit
							else
								continue
							fi
						done
					fi

					while true
					do
						echo "${lightblue}We need your credentials for make the connection" # Ask credentials

						while true # Ask Telegram ID
						do
							read -r -s -p "${white}Telegram ID --> " telegramid
							if [ -z "$telegramid" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						while true # Confirm Telegram ID
						do
							read -r -s -p "${white}Confirm Telegram ID --> " confirmtelegramid
							if [ -z "$confirmtelegramid" ]
							then
								echo ""
								continue
							fi
							echo ""
							break
						done

						if [ "$telegramid" == "$confirmtelegramid" ] # Check if Telegram IDs match
						then
							echo "${white}[${green}!${white}] ${lightblue}Telegram IDs match!${white}"
							publictelegramid=$(echo "$telegramid" | tr -c \\n \*)
						else
							echo "${red}Password don't match${reset}"
							exit
						fi

						while true
						do
							echo ""
							echo "${white}This is your configuration:"
							echo "${lightblue}Telegram ID:${white} $publictelegramid"
							echo ""
							read -r -p "Do you want continue? ${green}[Y/N]${white} --> " checkconfirmationconnectionfile

							if [[ $checkconfirmationconnectionfile == "Y" ]] || [[ $checkconfirmationconnectionfile == "y" ]]
							then
								while true
								do
									# Test connection
									echo ""
									echo "${white}[${red}*${white}]${lightblue} We are going to do a connection test..."
									if connectiontest="$(curl -s -X POST "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZE1lc3NhZ2U=")" -d chat_id=$telegramid -d text="This is a connection test from Linux's Doctor" 2>&1)" # Connection succesful
									then
										# Generate file, encrypt it and delete trash file
										echo "${white}[${green}!${white}]${lightblue} Connection made succesfully!"
										echo ""
										echo "${white}[${red}*${white}]${lightblue} Generating file... "
										base64=$(echo ?chat_id="$telegramid" | base64)
										touch /lib/linuxsdoctor/.notificationtelegram.sh
										{
											echo "#!/bin/bash"
											echo curl -s -X POST "$(base64 -d <<<"aHR0cHM6Ly9hcGkudGVsZWdyYW0ub3JnL2JvdDU3MDAyOTIxNzE6QUFFLWZodl9LLTltMndtTFM4cDlPeFZxZjljZFJRUG1KVWsvc2VuZE1lc3NhZ2U=")"'$(echo' "$base64" '| base64 --decode)' -d text='"$notificationtelegram"' '>> /dev/null'
										} >> /lib/linuxsdoctor/.notificationtelegram.sh

										shc -U -f /lib/linuxsdoctor/.notificationtelegram.sh -o /lib/linuxsdoctor/.notificationtelegram
										shred -zu -n32 /lib/linuxsdoctor/.notificationtelegram.sh
										rm -rf /lib/linuxsdoctor/.notificationtelegram.sh.x.c
										chmod 700 /lib/linuxsdoctor/.notificationtelegram

										if [ -f /lib/linuxsdoctor/.notificationtelegram ]
										then
											echo "${white}[${green}!${white}] ${lightblue}File created succesfully!${white}"
											break
										else
											echo "${red}Something went wrong${reset}"
											exit
										fi
									else # Something went wrong with the connection
										while true
										do
											echo "${red}Something went wrong with the connection :(${white}"
											echo "$connectiontest"
											read -r -p "Do you want try again? ${green}[Y/N]${white} --> " retryconnection
											if [[ $retryconnection == "Y" ]] || [[ $retryconnection == "y" ]]
											then
												continue
											elif [[ $retryconnection == "N" ]] || [[ $retryconnection == "n" ]]
											then
												echo "${reset}"
												exit
											else
												continue
											fi
										done
									fi
								break
								done
							elif [[ $checkconfirmationconnectionfile == "N" ]] || [[ $checkconfirmationconnectionfile == "n" ]]
							then
								break
							else
								continue
							fi
							break
						done
						break	
					done

				else
					
					echo "${red}It couldn't be detected all the dependences needed"
					
					if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] 
					then
						echo "${white}[${green}+${white}] ${lightblue}shc"
					else
						echo "${white}[${red}-${white}] ${lightblue}shc"
					fi
					
					if [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue}coreutils"
					else
						echo "${white}[${red}-${white}] ${lightblue}coreutils"
					fi
					
					read -r -p "${white}Do you want install the dependences? ${green}[Y/N]${white} --> " checkconnectionfiledependences
					
					if [[ $checkconnectionfiledependences == "Y" ]] || [[ $checkconnectionfiledependences == "y" ]] # Install dependences
					then
						echo "${white}[${red}*${white}]${lightblue}Installing dependences..."
						{
							yum install -y coreutils
							yum install -y shc
						} >> $setuplog 2>&1
						
						if [ "$(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed")" -eq 1 ] && [ "$(dpkg-query -W -f='${Status}' coreutils 2>/dev/null | grep -c "ok installed")" -eq 1 ] # Check if dependences were installed
						then
							echo "${white}[${green}!${white}] ${lightblue}Dependences installed succesfully!"
							continue
						else # Something went wrong
							echo "${red}Something went wrong during dependences install, check log file ${reset}"
							exit
						fi
					elif [[ $checkconnectionfiledependences == "N" ]] || [[ $checkconnectionfiledependences == "n" ]] # Don't install dependences
					then
						echo "${reset}"
						exit
					fi
				fi
				break
			done
		;;
		esac
		break
	;;
	9) # Edit file.conf

		if [[ ! -f /lib/linuxsdoctor/file.conf ]] # Check if file exists
		then
			echo "${red}It couldn't be finded /lib/linuxsdoctor/file.conf${reset}"
			exit
		else
			
			texteditor=(nano vi vim nvim micro ne)

			echo "Available text editors:"
			for i in "${texteditor[@]}"
			do
				if [[ -f /usr/bin/$i ]]
				then
					echo "${white}[${green}+${white}] ${lightblue}$i"
				fi
			done
			echo ""

			while true
			do
				read -r -p "${white}Choose a text editor: " selectedtexteditor
				if [ -z "$selectedtexteditor" ]
				then
					continue
				fi
				break
			done

			if [[ " ${texteditor[*]} " =~ $selectedtexteditor ]]
			then
				$selectedtexteditor /lib/linuxsdoctor/file.conf
			else
				echo "${red}You didn't choose a valid text editor${reset}"
				exit
			fi
		fi

	;;
	10) # Update Linux's Doctor
	
		if [ ! -d /lib/linuxsdoctor ] # Check if Linux's Doctor is installed
		then
			echo "${red}It hasn't been finded /lib/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		elif [ ! -L /usr/bin/linuxsdoctor ] # Check if in system there is a symbolic link called "linuxsdoctor"
		then
			echo "${red}It hasn't been finded /usr/bin/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		fi

		while true
		do
			echo "${white}Are you sure that you want update Linux's Doctor? ${red}It's possible that you couldn't compare new evidences with old ones"
			echo "${lightblue}Check Linux's Doctor changelog before update it"
			read -r -p "${green}[Y/N]${white} --> " checkupdate
			if [[ $checkupdate == "Y" ]] || [[ $checkupdate == "y" ]] # Update Linux's Doctor
			then
				while true
				do
					echo "${white}Do you want keep connections files for make connections for export reports/evidences?"
					echo "${lightblue}Check if in changelog says that it's necessary create them again"
					read -r -p "${green}[Y/N]${white} --> " checkeraseconnectionsfiles
					if [[ $checkeraseconnectionsfiles == "Y" ]] || [[ $checkeraseconnectionsfiles == "y" ]] || [[ $checkeraseconnectionsfiles == "N" ]] || [[ $checkeraseconnectionsfiles == "n" ]] # Ask for delete connections files
					then
						break
					else
						continue
					fi
				done
				while true
				do
					echo "${white}Do you want keep file.conf? (It can be obselete)"
					read -r -p "${green}[Y/N]${white} --> " checkerasefileconfig
					if [[ $checkerasefileconfig == "Y" ]] || [[ $checkerasefileconfig == "y" ]] || [[ $checkerasefileconfig == "N" ]] || [[ $checkerasefileconfig == "n" ]] # Ask for delete config file
					then
						break
					else
						continue
					fi
				done

				echo "${white}[${red}*${white}] ${lightblue}Updating Linux's Doctor..."

				git clone https://github.com/Layraaa/linuxs-doctor >> $setuplog 2>&1

				if [ ! -d linuxsdoctor ] # Check if linuxsdoctor repository was cloned succesfully
				then
					echo "${red}Something went wrong when it tried clonning Linux's Doctor repository, check log file ${reset}"
					exit
				fi

				if [[ $checkeraseconnectionsfiles == "Y" ]] || [[ $checkeraseconnectionsfiles == "y" ]] || [[ $checkerasefileconfig == "Y" ]] || [[ $checkerasefileconfig == "y" ]] # Keep config and connections files
				then
					find /lib/linuxsdoctor -type f -not \( -name 'LiME' -or -name '.*' -or -name 'file.conf' \) -delete >> $setuplog 2>&1
				elif [[ $checkeraseconnectionsfiles == "Y" ]] || [[ $checkeraseconnectionsfiles == "y" ]] # Keep only connections files
				then
					find /lib/linuxsdoctor -type f -not \( -name 'LiME' -or -name '.*' \) -delete >> $setuplog 2>&1
				elif [[ $checkerasefileconfig == "Y" ]] || [[ $checkerasefileconfig == "y" ]] # Keep only config files
				then
					find /lib/linuxsdoctor -type f -not \( -name 'LiME' -or -name 'file.conf' \) -delete >> $setuplog 2>&1
				else # Don't keep anything
					find /lib/linuxsdoctor -type f -not \( -name 'LiME' \) -delete >> $setuplog 2>&1
				fi
				
				# Delete hard link, move new files (excepting file.conf if user want keep it the old one) to /lib and create a new link with execution permissions for root
				if [[ $checkerasefileconfig == "Y" ]] || [[ $checkerasefileconfig == "y" ]]
				then
					rm -rf linuxsdoctor/file.conf $setuplog 2>&1
				fi

				{
					rm -rf /usr/bin/linuxsdoctor
					mv linuxsdoctor/* /lib/linuxsdoctor
					mv setup.sh LICENSE README.md /lib/linuxsdoctor
					ln /lib/linuxsdoctor/linuxsdoctor.sh /usr/bin/linuxsdoctor
					chmod 700 /usr/bin/linuxsdoctor
				} >> $setuplog 2>&1


				if [ -d /lib/linuxsdoctor ] || [ -L /usr/bin/linuxsdoctor ] # Check if files are installed correctly
				then
					echo "${white}[${green}!${white}] ${lightblue}Updated completed succesfully!"
					echo "${white}[${lightblue}!${white}] ${lightblue}Remeber update Linux's Doctor dependences or install news"
					break
				else
					echo "${red}Something went wrong, check log file ${reset}"
					exit
				fi

			elif [[ $checkupdate == "N" ]] || [[ $checkupdate == "n" ]] # Don't update Linux's Doctor
			then
				echo "${reset}"
				exit
			else
				continue
			fi	
		done	
		break
	;;
	11) # Update Linux's Doctor dependences

		# Choose OS
        case $os in
		Debian)

			# Show dependences
			debiandependences=(coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip lsof inxi lshw lsscsi ethtool sysstat)
			
			while true
			do
				echo "It will be updated these dependeces:"
				for i in "${debiandependences[@]}"
				do
					if [ "$(dpkg-query -W -f='${Status}' "$i" 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue} $i"
					else
						echo "${white}[${red}-${white}] ${lightblue} $i"
					fi
				done
				read -r -p "Do you want continue? ${green}[Y/N]${white}  --> " checkupdate

				if [[ $checkupdate == "Y" ]] || [[ $checkupdate == "y" ]] # Make update
				then
					echo "${white}[${red}*${white}] ${lightblue}Updating dependences..."
					count=0
					for i in "${debiandependences[@]}"
					do
						count=$(( count + 1 ))
						apt-get install "$i" -y >> $setuplog 2>&1
						if [ "$?" -eq 0 ]
						then
							echo "${white}[${green}$count/${#debiandependences[@]}${white}] ${lightblue} $i"
						else
							echo "${white}[${red}$count/${#debiandependences[@]}${white}] ${lightblue} $i"
						fi
					done
					date +"End of update dependences the %D - %T" >> $setuplog
					echo "" >> $setuplog
					echo "${white}[${green}!${white}] ${lightblue}Update completed!${white}"
					break

				elif [[ $checkupdate == "N" ]] || [[ $checkupdate == "n" ]] # Don't make update
				then
					echo "${reset}"
					exit
				else
					continue
				fi
			done
		;;
		Ubuntu)

			# Show dependences
			ubuntudependences=(coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip lsof inxi lshw lsscsi ethtool sysstat)
			
			while true
			do
				echo "It will be updated these dependeces:"
				for i in "${ubuntudependences[@]}"
				do
					if [ "$(dpkg-query -W -f='${Status}' "$i" 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue} $i"
					else
						echo "${white}[${red}-${white}] ${lightblue} $i"
					fi
				done
				read -r -p "Do you want continue? ${green}[Y/N]${white}  --> " checkupdate

				if [[ $checkupdate == "Y" ]] || [[ $checkupdate == "y" ]] # Make update
				then
					echo "${white}[${red}*${white}] ${lightblue}Updating dependences..."
					count=0
					for i in "${ubuntudependences[@]}"
					do
						count=$(( count + 1 ))
						apt-get install "$i" -y >> $setuplog 2>&1
						if [ "$?" -eq 0 ]
						then
							echo "${white}[${green}$count/${#debiandependences[@]}${white}] ${lightblue} $i"
						else
							echo "${white}[${red}$count/${#debiandependences[@]}${white}] ${lightblue} $i"
						fi
					done
					date +"End of update dependences the %D - %T" >> $setuplog
					echo "" >> $setuplog
					echo "${white}[${green}!${white}] ${lightblue}Update completed!${white}"
					break

				elif [[ $checkupdate == "N" ]] || [[ $checkupdate == "n" ]] # Don't make update
				then
					echo "${reset}"
					exit
				else
					continue
				fi
			done
		;;
		Kali)

			# Show dependences
			kalidependences=(coreutils findutils dpkg util-linux login runit-init net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip lsof inxi lshw lsscsi ethtool sysstat)
			
			while true
			do
				echo "It will be updated these dependeces:"
				for i in "${kalidependences[@]}"
				do
					if [ "$(dpkg-query -W -f='${Status}' "$i" 2>/dev/null | grep -c "ok installed")" -eq 1 ]
					then
						echo "${white}[${green}+${white}] ${lightblue} $i"
					else
						echo "${white}[${red}-${white}] ${lightblue} $i"
					fi
				done
				read -r -p "Do you want continue? ${green}[Y/N]${white}  --> " checkupdate

				if [[ $checkupdate == "Y" ]] || [[ $checkupdate == "y" ]] # Make update
				then
					echo "${white}[${red}*${white}] ${lightblue}Updating dependences..."
					count=0
					for i in "${kalidependences[@]}"
					do
						count=$(( count + 1 ))
						apt-get install "$i" -y >> $setuplog 2>&1
						if [ "$?" -eq 0 ]
						then
							echo "${white}[${green}$count/${#debiandependences[@]}${white}] ${lightblue} $i"
						else
							echo "${white}[${red}$count/${#debiandependences[@]}${white}] ${lightblue} $i"
						fi
					done
					date +"End of update dependences the %D - %T" >> $setuplog
					echo "" >> $setuplog
					echo "${white}[${green}!${white}] ${lightblue}Update completed!${white}"
					break

				elif [[ $checkupdate == "N" ]] || [[ $checkupdate == "n" ]] # Don't make update
				then
					echo "${reset}"
					exit
				else
					continue
				fi
			done
		;;
		CentOS)

			# Show dependences
			centosdependences=(coreutils findutils dpkg util-linux systemd net-tools git make build-essential kernel-devel gcc bind-utils linux-headers-"$(uname -r)" lsof inxi lshw lsscsi ethtool sysstat)
			
			while true
			do
				echo "It will be updated these dependeces:"
				for i in "${centosdependences[@]}"
				do
					if [ "$(rpm -q "$i" && echo $?)" -eq 0 ]
					then
						echo "${white}[${green}+${white}] ${lightblue} $i"
					else
						echo "${white}[${red}-${white}] ${lightblue} $i"
					fi
				done
				read -r -p "Do you want continue? ${green}[Y/N]${white}  --> " checkupdate

				if [[ $checkupdate == "Y" ]] || [[ $checkupdate == "y" ]] # Make update
				then
					echo "${white}[${red}*${white}] ${lightblue}Updating dependences..."
					count=0
					for i in "${centosdependences[@]}"
					do
						count=$(( count + 1 ))
						yum install "$i" -y >> $setuplog 2>&1
						if [ "$?" -eq 0 ]
						then
							echo "${white}[${green}$count/${#centosdependences[@]}${white}] ${lightblue} $i"
						else
							echo "${white}[${red}$count/${#centosdependences[@]}${white}] ${lightblue} $i"
						fi
					done
					date +"End of update dependences the %D - %T" >> $setuplog
					echo "" >> $setuplog
					echo "${white}[${green}!${white}] ${lightblue}Update completed!${white}"
					break

				elif [[ $checkupdate == "N" ]] || [[ $checkupdate == "n" ]] # Don't make update
				then
					echo "${reset}"
					exit
				else
					continue
				fi
			done
		;;
		*)
			echo "${red}We don't have support for your OS :(${reset}"
            exit
		;;
		esac
		break
	;;
	12) # Unistall Linux's Doctor

		if [ ! -d /lib/linuxsdoctor ] # Check if Linux's Doctor is not installed
		then
			echo "${red}It hasn't been finded /lib/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		elif [ ! -L /usr/bin/linuxsdoctor ] # Check if in system there is not a symbolic link called "linuxsdoctor"
		then
			echo "${red}It hasn't been finded /usr/bin/linuxsdoctor on system, is Linux's Doctor installed?${reset}"
			exit
		fi

		while true
		do
			read -r -p "Are you sure of unistall Linux's Doctor? ${green}[Y/N]${white} --> " checkunistall
			if [[ $checkunistall == "Y" ]] || [[ $checkunistall == "y" ]] # Make unistall
			then
				randomsecuritynumber="$RANDOM"
				read -r -p "Write the secuirty number for confirm for uninstall: ${green}$randomsecuritynumber${white} --> " checkunistallnumber
				if [ "$checkunistallnumber" == "$randomsecuritynumber" ] # Make unistall if the user write the secuirty number correctly
				then
					echo ""
					echo "${white}[${red}*${white}] ${lightblue}Starting uninstall..."
					rm -rf /usr/bin/linuxsdoctor /lib/linuxsdoctor >> $setuplog 2>&1
					if [ "$?" -eq 0 ]
					then
						echo ""
						echo "${white}[${green}!${white}] ${lightblue}Uninstall completed :("
					else
						echo ""
						echo "${red}Something went wrong, check log file"
						exit
					fi
					break
				else # Exit program if user didn't write the security number correctly
					echo "${red}You didn't write the security number correctly${reset}"
					exit
				fi
			elif [[ $checkunistall == "N" ]] || [[ $checkunistall == "n" ]] # Don't make unistall
			then
				echo "${reset}"
				exit
			else
				continue
			fi
		done
		break
	;;
	99) # Exit
		echo "${reset}"
		exit
	;;
	esac
done

echo ""
echo "${lightblue}¡Thanks for use Linux's Doctor!"
echo "${purple}https://github.com/Layraaa/Linuxs-Doctor"
echo "${white}Made by ${green}@Layraaa and @Japinper${white}"
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

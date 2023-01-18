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
	date +"Execution of setup without permisssions made the %d/%m/%Y - %T" >> log.txt
	exit
fi

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


date +"Setup execution the %d/%m/%Y - %T" >> log.txt

# Detect the OS
so=$(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')

# Start the installation
echo "${lightblue}Welcome to Linux's Doctor Setup"
read -r -p "¿Do you want update the system? ${green}[Y/N]${white} --> " sistema
case $so in
	Debian)
		echo "Making install for Debian" >> log.txt
		echo "" >> log.txt

		# Update system if it was inidicated
		if [[ $sistema == "Y" ]] || [[ $sistema == "y" ]]
		then
			date +"Updating system from Linux's Doctor Setup the %d/%m/%Y - %T" >> log.txt
			echo "${white}[${red}*${white}]${lightblue} Updating..."
			apt-get update -y && apt-get upgrade -y >> log.txt 2>&1
		fi

		# Dependences' installation
		date +"Installing dependences for Debian the %d/%m/%Y - %T" >> log.txt
		echo ""
		echo "${white}[${red}*${white}]${lightblue} Staring dependences' installation for Debian..."
		apt-get install coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip lsof -y >> log.txt 2>&1
	;;
	Ubuntu)
		echo "Making install for Ubuntu" >> log.txt
		echo "" >> log.txt

		# Update system if it was inidicated
		if [[ $sistema == "Y" ]] || [[ $sistema == "y" ]]
		then
			date +"Updating system from Linux's Doctor Setup the %d/%m/%Y - %T" >> log.txt
			echo "${white}[${red}*${white}]${lightblue} Updating..."
			apt-get update -y && apt-get upgrade -y >> log.txt 2>&1
		fi

		# Dependences' installation
		date +"Installing dependences for Ubuntu the %d/%m/%Y - %T" >> log.txt
		echo ""
		echo "${white}[${red}*${white}]${lightblue} Staring dependences' installation for Ubuntu..."
		apt-get install coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip lsof -y >> log.txt 2>&1
	;;
	Kali)
		echo "Making install for Kali" >> log.txt
		echo "" >> log.txt

		# Update system if it was inidicated
		if [[ $sistema == "Y" ]] || [[ $sistema == "y" ]]
		then
			date +"Updating system from Linux's Doctor Setup the %d/%m/%Y - %T" >> log.txt
			echo "${white}[${red}*${white}]${lightblue} Updating..."
			apt-get update -y && apt-get upgrade -y >> log.txt 2>&1
		fi

		# Dependences' installation
		date +"Installing dependences for Kali Linux the %d/%m/%Y - %T" >> log
		echo ""
		echo "${white}[${red}*${white}]${lightblue} Staring dependences' installation for Kali Linux..."
		apt-get install coreutils findutils dpkg util-linux login runit-init net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip lsof -y >> log.txt 2>&1
	;;
	CentOS)
		echo "Making install for CentOS" >> log.txt
		echo "" >> log.txt

		# Update system if it was inidicated
		if [[ $sistema == "Y" ]] || [[ $sistema == "y" ]]
		then
			date +"Updating system from Linux's Doctor Setup the %d/%m/%Y - %T" >> log.txt
			echo "${white}[${red}*${white}]${lightblue} Updating..."
			yum update -y >> log.txt 2>&1
		fi

		# Dependences' installation
		date +"Installing dependences for CentOS the %d/%m/%Y - %T" >> log.txt
		echo ""
		echo "${white}[${red}*${white}]${lightblue} Staring dependences' installation for CentOS..."
		yum install coreutils findutils dpkg util-linux systemd net-tools git make build-essential kernel-devel gcc bind-utils lsof -y >> log.txt 2>&1
		yum install linux-headers-"$(uname -r)" -y >> log.txt 2>&1
	;;
	*)
		echo "We don't have support for your OS :("
		exit
esac

# LiME installation

echo "${white}[${red}*${white}] ${lightblue}Installing LiME..."
echo ""	

git clone https://github.com/504ensicsLabs/LiME >> log.txt 2>&1
if [ -d LiME ]
then
	{
		cd LiME/src/ || make || cd .. || cd ..
	} >> log.txt 2>&1
	echo "${white}[${green}!${white}] ${lightblue}LiME was installed correctly!"
else
	echo "${white}[${green}!${white}] ${lightblue}It couldn't be installed LiME, check the log :("
fi

# End of installation

date +"End of installation the %d/%m/%Y - %T" >> log.txt
echo "" >> log.txt
echo "${white}[${green}!${white}] ${lightblue}Installation completed!"
echo "${white}[${green}!${white}] ${lightblue}Remember check 'file.conf'"
echo ""
echo "${lightblue}¡Thanks for install Linux's Doctor!"
echo "https://github.com/Layraaa/Linuxs-Doctor"
echo "Made by ${green}@Layraaa and @Japinper${white}"
echo ""
base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
echo ""
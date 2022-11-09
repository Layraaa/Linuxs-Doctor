#!/bin/bash
# Linux's Doctor: Creado por @Layraaa y @Japinper
#
# setup.sh
# Setup para la herramienta Linux's Doctor

# Define los colores
red="$(tput setaf 1)"
green="$(tput setaf 2)"
blue="$(tput setaf 4)"
white="$(tput setaf 7)"
lightblue="$(tput setaf 117)"

# Si no existe el log, lo crea
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
	echo "Creado por ${green}@Layraaa y @Japinper ${white}| ${blue}v1.1${white}"
	echo "https://github.com/Layraaa/Linuxs-Doctor"
	echo ""
	echo "${white}[${red}*${white}] ${lightblue}Debes tener permisos de administrador para ejecutar el instalador${white}"
	date +"Ejecución del setup sin permisos de administrador realizada el %d/%m/%Y - %T" >> log.txt
	exit
fi

clear

echo " _     _                           ____             _             "
echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
echo ""
echo "Creado por ${green}@Layraaa y @Japinper ${white}| ${blue}v1.1${white}"
echo "https://github.com/Layraaa/Linuxs-Doctor"
echo ""


date +"Ejecucion del setup realizada el %d/%m/%Y - %T" >> log.txt

# Detecta el sistema operativo
so=$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')

# Instalación del script
echo "${lightblue}Bienvenido a la instalción de Linux's Doctor"
read -r -p "¿Quieres actualizar el sistema? ${green}[S/N]${white} --> " sistema
case $so in
	Debian)
	echo "Instalación seleccionada para Debian" >> log.txt
	echo "" >> log.txt

	# Realiza la actualización del sistema si se le ha indicado
	if [[ $sistema == "S" ]] || [[ $sistema == "s" ]]
	then
		date +"Actualizacion del sistema realizada desde el setup el %d/%m/%Y - %T" >> log.txt
		echo "${white}[${red}*${white}]${lightblue} Actualizando el sistema..."
		apt-get update -y && apt-get upgrade -y >> log.txt 2>&1
	fi

	# Instala la herramienta
	date +"Instalacion de las dependencias para Debian el %d/%m/%Y - %T" >> log.txt
	echo ""
	echo "${white}[${red}*${white}]${lightblue} Ejecutando instalación para Debian"
	sudo apt-get install coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip -y >> log.txt 2>&1
	;;
	Ubuntu)
	echo "Instalación seleccionada para Ubuntu" >> log.txt
	echo "" >> log.txt

	# Realiza la actualización del sistema si se le ha indicado
	if [[ $sistema == "S" ]] || [[ $sistema == "s" ]]
	then
		date +"Actualizacion del sistema realizada desde el setup el %d/%m/%Y - %T" >> log.txt
		echo "${white}[${red}*${white}]${lightblue} Actualizando el sistema..."
		apt-get update -y && apt-get upgrade -y >> log.txt 2>&1
	fi

	# Instala la herramienta
	date +"Instalacion de las dependencias para Ubuntu el %d/%m/%Y - %T" >> log.txt
	echo ""
	echo "${white}[${red}*${white}]${lightblue} Ejecutando instalación para Ubuntu"
	sudo apt-get install coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip -y >> log.txt 2>&1
	;;
	Kali)
	echo "Instalación seleccionada para Kali" >> log.txt
	echo "" >> log.txt

	# Realiza la actualización del sistema si se le ha indicado
	if [[ $sistema == "S" ]] || [[ $sistema == "s" ]]
	then
		date +"Actualizacion del sistema realizada desde el setup el %d/%m/%Y - %T" >> log.txt
		echo "${white}[${red}*${white}]${lightblue} Actualizando el sistema..."
		apt-get update -y && apt-get upgrade -y >> log.txt 2>&1
	fi

	# Instala la herramienta
	date +"Instalacion de las dependencias para Kali Linux el %d/%m/%Y - %T" >> log
	echo "".txt
	echo "${white}[${red}*${white}]${lightblue} Ejecutando instalación para Kali Linux"
	sudo apt-get install coreutils findutils dpkg util-linux login runit-init net-tools dnsutils network-manager git make build-essential linux-headers-"$(uname -r)" zip -y >> log.txt 2>&1
	;;
	CentOS)
	echo "Instalación seleccionada para CentOS" >> log.txt
	echo "" >> log.txt

	# Realiza la actualización del sistema si se le ha indicado
	if [[ $sistema == "S" ]] || [[ $sistema == "s" ]]
	then
		date +"Actualizacion del sistema realizada desde el setup el %d/%m/%Y - %T" >> log.txt
		echo "${white}[${red}*${white}]${lightblue} Actualizando el sistema..."
		yum update -y >> log.txt 2>&1
	fi

	# Instala la herramienta
	date +"Instalacion de las dependencias para CentOS el %d/%m/%Y - %T" >> log.txt
	echo ""
	echo "${white}[${red}*${white}]${lightblue} Ejecutando instalación para CentOS"
	sudo yum install coreutils findutils dpkg util-linux systemd net-tools git make build-essential kernel-devel gcc bind-utils -y >> log.txt 2>&1
	sudo yum install linux-headers-"$(uname -r)" -y >> log.txt 2>&1
	;;
	*)
	echo "Esta harramienta no tiene soporte para tu sistema operativo :("
	exit
esac

# Instala LiME

echo "${white}[${green}!${white}] ${lightblue}Instalación de LiME!"
echo ""	

{
	git clone https://github.com/504ensicsLabs/LiME
	cd LiME/src/
	make

} >> log.txt 2>&1

cd .. || cd ..


# Fin de la instalación
date +"Final del setup el %d/%m/%Y - %T" >> log.txt
echo "" >> log.txt
echo "${white}[${green}!${white}] ${lightblue}Instalación completada!"
echo ""
echo "${lightblue}¡Gracias por instalar Linux's Doctor!"
echo "https://github.com/Layraaa/Linuxs-Doctor"
echo "Hecho por ${green}@Layraaa y @Japinper${white}"
echo ""
base64 -d <<<"ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCgogICAgICAgICAgICAgICAgICAgICAgICAgKiAgX3xfCiAgICAgICAgICAgICAgICAgICAgICAgICAuLScgKiAnLS4gKgogICAgICAgICAgICAgICAgICAgICAgICAvICAgICAgICogXAogICAgICAgICAgICAgICAgICAgICAqICBeXl5eXnxeXl5eXgogICAgICAgICAgICAgICAgICAgICAgICAgLn4uIHwgIC5+LgogICAgICAgICAgICAgICAgICAgICAgICAvIF4gXHwgLyBeIFwKICAgICAgICAgICAgICAgICAgICAgICAofCAgIHxKL3wgICB8KQogICAgICAgICAgICAgICAgICAgICAgICdcICAgL2AiXCAgIC9gCiAgICAgICAgICAgICAtLSAnJyAtJy0nICBeYF4gICAgXmBeICAtLSAnJyAtJy0nCg=="
echo ""
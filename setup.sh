#!/bin/bash
#
# Creado por @Layraaa y @Japinper
# Setup para la herramienta Linux's Doctor

if [[ $EUID != 0 ]]
then
	echo " _     _                           ____             _             "
	echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
	echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
	echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
	echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
	echo ""
	echo "Creado por @Layraaa y @Japinper | $(tput setaf 4)1.0"
	echo ""
	echo "$(tput setaf 1)[*] Debes tener permisos de administrador para ejecutar el instalador"
	echo "$(tput setaf 7)"
	exit
fi

clear

echo " _     _                           ____             _             "
echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
echo ""
echo "Creado por @Layraaa y @Japinper | $(tput setaf 4)v1.0"
echo ""

### Si no existe el log, lo crea
if [ ! -f log.txt ]
then
	touch log.txt
fi

date +"Ejecucion del setup realizada el %d/%m/%Y - %T" >> log.txt

so=$(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')

read -p "$(tput setaf 117)¿Quieres actualizar el sistema? $(tput setaf 2)[S/N]$(tput setaf 7) --> " sistema
echo ""
case $so in
	Debian)
	if [[ $sistema == "S" ]] || [[ $sistema == "s" ]]
	then
		date +"Actualizacion del sistema realizada desde el setup el %d/%m/%Y - %T" >> log.txt
		echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Actualizando el sistema..."
		apt-get update -y && apt-get upgrade -y >> log.txt 2>&1
	fi
	date +"Instalacion de las dependencias para Debian el %d/%m/%Y - %T" >> log.txt
	echo ""
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Ejecutando instalación para Debian"
	sudo apt-get install coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-$(uname -r) -y >> log.txt 2>&1
	;;
	Ubuntu)
	if [[ $sistema == "S" ]] || [[ $sistema == "s" ]]
	then
		date +"Actualizacion del sistema realizada desde el setup el %d/%m/%Y - %T" >> log.txt
		echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Actualizando el sistema..."
		apt-get update -y && apt-get upgrade -y >> log.txt 2>&1
	fi
	date +"Instalacion de las dependencias para Ubuntu el %d/%m/%Y - %T" >> log.txt
	echo ""
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Ejecutando instalación para Ubuntu"
	sudo apt-get install coreutils findutils dpkg util-linux login net-tools dnsutils network-manager git make build-essential linux-headers-$(uname -r) -y >> log.txt 2>&1
	;;
	Kali)
	if [[ $sistema == "S" ]] || [[ $sistema == "s" ]]
	then
		date +"Actualizacion del sistema realizada desde el setup el %d/%m/%Y - %T" >> log.txt
		echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Actualizando el sistema..."
		apt-get update -y && apt-get upgrade -y >> log.txt 2>&1
	fi
	date +"Instalacion de las dependencias para Kali Linux el %d/%m/%Y - %T" >> log
	echo "".txt
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Ejecutando instalación para Kali Linux"
	sudo apt-get install coreutils findutils dpkg util-linux login runit-init net-tools dnsutils network-manager git make build-essential linux-headers-$(uname -r) -y >> log.txt 2>&1
	;;
	CentOS)
	if [[ $sistema == "S" ]] || [[ $sistema == "s" ]]
	then
		date +"Actualizacion del sistema realizada desde el setup el %d/%m/%Y - %T" >> log.txt
		echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Actualizando el sistema..."
		yum update -y >> log.txt 2>&1
	fi
	date +"Instalacion de las dependencias para CentOS el %d/%m/%Y - %T" >> log.txt
	echo ""
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Ejecutando instalación para CentOS"
	sudo yum install coreutils findutils dpkg util-linux systemd net-tools git make build-essential kernel-devel gcc bind-utils -y >> log.txt 2>&1
	sudo yum install linux-headers-$(uname -r) -y >> log.txt 2>&1
	;;
	*)
	echo "Esta harramienta no tiene soporte para tu sistema operativo :("
	exit
esac

echo ""
git clone https://github.com/504ensicsLabs/LiME >> log.txt 2>&1
cd LiME/src/ >> log.txt 2>&1
make >> log.txt 2>&1
cd ..
cd ..
echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)] $(tput setaf 117)Instalación completada!$(tput setaf 7)"
date +"Final del setup el %d/%m/%Y - %T" >> log.txt
echo "" >> log.txt
exit
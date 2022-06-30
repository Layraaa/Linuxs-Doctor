#!/bin/bash
#
# Creado por @Layraaa y @Japinper
# Script creado para análisis forense y recogida de información del sistema

### Si el usuario no es root no puede ejecutar el script

if [[ $EUID != 0 ]]
then
	echo " _     _                           ____             _             "
	echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
	echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
	echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
	echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
	echo ""
	echo "Creado por @Layraaa y @Japinper | $(tput setaf 4)v1.0"
	echo ""
	echo "$(tput setaf 1)[*] Debes tener permisos de administrador para ejecutar esta herramienta"
	echo "$(tput setaf 7)"
	exit
fi

### Ejecución normal del script

clear

echo " _     _                           ____             _             "
echo "| |   (_)_ __  _   ___  __() ___  |  _ \  ___   ___| |_ ___  _ __ "
echo "| |   | | '_ \| | | \ \/ /|// __| | | | |/ _ \ / __| __/ _ \| '__|"
echo "| |___| | | | | |_| |>  <   \__ \ | |_| | (_) | (__| || (_) | |   "
echo "|_____|_|_| |_|\__,_/_/\_\  |___/ |____/ \___/ \___|\__\___/|_|   "
echo ""
echo "Creado por @Layraaa y @Japinper | $(tput setaf 4)1.0"
echo ""

### Si no existe el log, lo crea
if [ ! -f log.txt ]
then
	touch log.txt
fi

### Menú de selección
echo "$(tput setaf 135)1) $(tput setaf 117)Recoger información del sistema"
echo "$(tput setaf 135)2) $(tput setaf 117)Análisis del sistema"
echo "$(tput setaf 135)3) $(tput setaf 117)Información del script"
echo "$(tput setaf 135)4) $(tput setaf 117)Salir"
echo ""
read -p "$(tput setaf 117)¿Qué quieres hacer? --> $(tput setaf 7)" menu

### Opciones del menú
case $menu in
	1) #Recoger información del sistema
	read -p "$(tput setaf 117)¿Quieres realizar un volcado de la memoria RAM? $(tput setaf 1)(El peso del archivo sera igual a la cantidad de memoria que tiene tu sistema)$(tput setaf 2) [S/N]$(tput setaf 7) --> " ram
    read -p "$(tput setaf 117)Elige una ruta para generar el reporte $(tput setaf 2)(Ej:/home/user)$(tput setaf 7) --> " rutanueva
	echo ""
	if [ ! -d $rutanueva ]
	then
		echo "$(tput setaf 117)La ruta especificada no existe $(tput setaf 7)"
		exit
	fi

	date +"Recogida de información del sistema el %d/%m/%Y - %T" >> log.txt

	### Recogida de información del sistema
	mkdir $rutanueva/evidencias >> log.txt 2>&1
	mkdir $rutanueva/evidencias/archivos-de-sistema >> log.txt 2>&1
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Recogiendo archivos del sistema..."
	sha256sum /boot/vmlinuz-$(uname -r) > $rutanueva/evidencias/archivos-de-sistema/kernelfirma.txt
	cat /etc/sudoers > $rutanueva/evidencias/archivos-de-sistema/sudoers.txt
	sha256sum /etc/sudoers > $rutanueva/evidencias/archivos-de-sistema/sudoersfirma.txt
	cat /etc/shadow > $rutanueva/evidencias/archivos-de-sistema/shadow.txt
	sha256sum /etc/shadow > $rutanueva/evidencias/archivos-de-sistema/shadowfirma.txt
	cat /etc/passwd > $rutanueva/evidencias/archivos-de-sistema/passwd.txt
	sha256sum /etc/passwd > $rutanueva/evidencias/archivos-de-sistema/passwdfirma.txt
	cat /root/.bash_history > $rutanueva/evidencias/archivos-de-sistema/root_bash_history.txt
	if [ $(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"') != "CentOS" ]
	then
		dpkg-query -f '${binary:Package}\n' -W > $rutanueva/evidencias/archivos-de-sistema/dpkg.txt
	else
		rpm -qa > $rutanueva/evidencias/archivos-de-sistema/dpkg.txt
	fi
	cat /etc/crontab > $rutanueva/evidencias/archivos-de-sistema/crontab.txt
	cat /etc/default/grub > $rutanueva/evidencias/archivos-de-sistema/grub.txt
	dmesg > $rutanueva/evidencias/archivos-de-sistema/dmesg.txt
	lastlog > $rutanueva/evidencias/archivos-de-sistema/lastlog.txt
	runlevel > $rutanueva/evidencias/archivos-de-sistema/runlevel.txt
	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Listo..."
	echo ""

	### Recogiendo información sobre la configuración de red del dispositivo
	mkdir $rutanueva/evidencias/red >> log.txt 2>&1
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Recogiendo información de red sobre el dispositivo..."
	ip a > $rutanueva/evidencias/red/ip.txt
	netstat -an > $rutanueva/evidencias/red/netstat.txt
	dig > $rutanueva/evidencias/red/dig.txt
	route > $rutanueva/evidencias/red/route.txt
	arp -v -e > $rutanueva/evidencias/red/arp.txt
	nmcli device show > $rutanueva/evidencias/red/nmcli.txt
	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Listo..."
	echo ""

	### Recogiendo información sobre los logs de sistema
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Recogiendo los logs del sistema..."
	mkdir  $rutanueva/evidencias/logs >> log.txt 2>&1
	cp /var/log/auth.log*  $rutanueva/evidencias/logs/ >> log.txt 2>&1
	cp /var/log/dpkg.log*  $rutanueva/evidencias/logs/ >> log.txt 2>&1
	cp /var/log/syslog*  $rutanueva/evidencias/logs/ >> log.txt 2>&1
	cp /var/log/boot.log*  $rutanueva/evidencias/logs/ >> log.txt 2>&1
	cp /var/log/kern.log*  $rutanueva/evidencias/logs/ >> log.txt 2>&1
	cp /var/log/lastlog* $rutanueva/evidencias/logs/ >> log.txt 2>&1

	### Descomprime todos los archivos y los pasa a un solo archivo
	gunzip $rutanueva/evidencias/logs/auth.log* >> log.txt 2>&1
	touch $rutanueva/evidencias/logs/logfile_auth_log.txt
	for auth_log in $(ls $rutanueva/evidencias/logs/auth.log*)
	do
		cat "$auth_log" >> $rutanueva/evidencias/logs/logfile_auth_log.txt
	done
	if [ ! -s $rutanueva/evidencias/logs/logfile_auth_log.txt ]
	then
		rm -rf $rutanueva/evidencias/logs/logfile_auth_log.txt
	fi

	gunzip $rutanueva/evidencias/logs/dpkg.log* >> log.txt 2>&1
	touch $rutanueva/evidencias/logs/logfile_dpkg_log.txt
	for dpkg_log in $(ls $rutanueva/evidencias/logs/dpkg.log*)
	do
		cat "$dpkg_log" >> $rutanueva/evidencias/logs/logfile_dpkg_log.txt
	done
	if [ ! -s $rutanueva/evidencias/logs/logfile_dpkg_log.txt ]
	then
		rm -rf $rutanueva/evidencias/logs/logfile_dpkg_log.txt
	fi

	gunzip $rutanueva/evidencias-/logs/syslog* >> log.txt 2>&1
	touch $rutanueva/evidencias/logs/logfile_syslog.txt
	for syslog in $(ls $rutanueva/evidencias/logs/syslog*)
	do
		cat "$syslog" >> $rutanueva/evidencias/logs/logfile_syslog.txt
	done
	if [ ! -s $rutanueva/evidencias/logs/logfile_syslog.txt ]
	then
		rm -rf $rutanueva/evidencias/logs/logfile_syslog.txt
	fi

	gunzip $rutanueva/evidencias/logs/boot.log* >> log.txt 2>&1
	touch $rutanueva/evidencias/logs/logfile_boot_log.txt
	for boot_log in $(ls $rutanueva/evidencias/logs/boot.log*)
	do
		cat "$boot_log" >> $rutanueva/evidencias/logs/logfile_boot_log.txt
	done
	if [ ! -s $rutanueva/evidencias/logs/logfile_boot_log.txt ]
	then
		rm -rf $rutanueva/evidencias/logs/logfile_boot_log.txt
	fi

	gunzip $rutanueva/evidencias/logs/kern.log* >> log.txt 2>&1
	touch $rutanueva/evidencias/logs/logfile_kern_log.txt
	for kern_log in $(ls $rutanueva/evidencias/logs/kern.log*)
	do
		cat "$kern_log" >> $rutanueva/evidencias/logs/logfile_kern_log.txt
	done
	if [ ! -s $rutanueva/evidencias/logs/logfile_kern_log.txt ]
	then
		rm -rf $rutanueva/evidencias/logs/logfile_kern_log.txt
	fi

	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Listo..."
	echo "$(tput setaf 7)"

	### Volcado de RAM
	if [[ $ram == "S" ]] || [[ $ram == "s" ]]
	then
		cd LiME/src/ && insmod lime-$(uname -r).ko "path=$rutanueva/evidencias/volcado_memoria format=raw"
		rmmod lime
		cd ..
		cd ..
	fi

	### Fin del script
	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Ya hemos terminado! Tus resultados estan en la carpeta 'evidencias'$(tput setaf 7)"
	echo "" >> log.txt
	;;
	2) # Análisis del sistema
	### Comprueba si el usuario tiene los datos necesarios para realizar el análisis
	read -p "$(tput setaf 117)¿Quieres continuar con el análisis (Debes tener la carpeta generada por la primera opción en el directorio para realizar el reporte)?$(tput setaf 2) [S/N]$(tput setaf 7) --> " elegir
	if [[ $elegir == "S" ]] || [[ $elegir == "s" ]]
	then
		read -p "$(tput setaf 117)¿Quieres realizar un volcado de la memoria RAM? $(tput setaf 1)(El peso del archivo sera igual a la cantidad de memoria que tiene tu sistema) $(tput setaf 2)[S/N]$(tput setaf 7) --> " ram
    	read -p "$(tput setaf 117)Elige una ruta para generar el reporte $(tput setaf 2)(Ej:/home/user)$(tput setaf 7) --> " rutactual
		read -p "$(tput setaf 117)Indica la ruta donde se generó el primer reporte$(tput setaf 7) --> " rutaanterior
	elif [[ $elegir == "N" ]] || [[ $elegir == "n" ]]
	then
		bash linux-doctor.sh
	elif [[ -z $elegir ]]
	then
		echo "No has introducido ningun valor"
		exit
	else
		echo "Valor introducido incorrecto"
		exit
	fi

	### Comprueba si las rutas existen
	if [ ! -d $rutaactual ]
	then
		echo "$(tput setaf 117)La ruta especificada para generar el segundo análisis no existe $(tput setaf 7)"
		exit
	fi

	if [ ! -d $rutaanterior ]
	then
		echo "$(tput setaf 117)La ruta especificada del primer análisis no existe (asegúrate que la carpeta se llama evidencias) $(tput setaf 7)"
		exit
	fi

	date +"Análisis del sistema hecho el %d/%m/%Y - %T" >> log.txt

	### Recogida de información del sistema
	mkdir $rutactual/evidencias-actuales
	mkdir $rutactual/evidencias-actuales/archivos-de-sistema >> log.txt 2>&1
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Recogiendo archivos del sistema..."
	sha256sum /boot/vmlinuz-$(uname -r) > $rutactual/evidencias-actuales/archivos-de-sistema/kernelfirma.txt
	cat /etc/sudoers > $rutactual/evidencias-actuales/archivos-de-sistema/sudoers.txt
	sha256sum /etc/sudoers > $rutactual/evidencias-actuales/archivos-de-sistema/sudoersfirma.txt
	cat /etc/shadow > $rutactual/evidencias-actuales/archivos-de-sistema/shadow.txt
	sha256sum /etc/shadow > $rutactual/evidencias-actuales/archivos-de-sistema/shadowfirma.txt
	cat /etc/passwd > $rutactual/evidencias-actuales/archivos-de-sistema/passwd.txt
	sha256sum /etc/passwd > $rutactual/evidencias-actuales/archivos-de-sistema/passwdfirma.txt
	cat /root/.bash_history > $rutactual/evidencias-actuales/archivos-de-sistema/root_bash_history.txt
	if [ $(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"') != "CentOS" ]
	then
		dpkg-query -f '${binary:Package}\n' -W > $rutactual/evidencias-actuales/archivos-de-sistema/dpkg.txt
	else
		rpm -qa > $rutactual/evidencias-actuales/archivos-de-sistema/dpkg.txt
	fi
	cat /etc/crontab > $rutactual/evidencias-actuales/archivos-de-sistema/crontab.txt
	cat /etc/default/grub > $rutactual/evidencias-actuales/archivos-de-sistema/grub.txt
	dmesg > $rutactual/evidencias-actuales/archivos-de-sistema/dmesg.txt
	lastlog > $rutactual/evidencias-actuales/archivos-de-sistema/lastlog.txt
	runlevel > $rutactual/evidencias-actuales/archivos-de-sistema/runlevel.txt
	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Listo..."
	echo "$(tput setaf 7)"

	### Recogiendo información sobre la configuración de red del dispositivo
	mkdir $rutactual/evidencias-actuales/red >> log.txt 2>&1
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Recogiendo información de red sobre el dispositivo..."
	ip a > $rutactual/evidencias-actuales/red/ip.txt
	netstat -an > $rutactual/evidencias-actuales/red/netstat.txt
	dig > $rutactual/evidencias-actuales/red/dig.txt
	route > $rutactual/evidencias-actuales/red/route.txt
	arp -v -e > $rutactual/evidencias-actuales/red/arp.txt
	nmcli device show > $rutactual/evidencias-actuales/red/nmcli.txt
	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Listo..."
	echo ""

	### Recogiendo información sobre los logs de sistema
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Recogiendo los logs del sistema..."
	mkdir  $rutactual/evidencias-actuales/logs >> log.txt 2>&1
	cp /var/log/auth.log*  $rutactual/evidencias-actuales/logs/ >> log.txt 2>&1
	cp /var/log/dpkg.log*  $rutactual/evidencias-actuales/logs/ >> log.txt 2>&1
	cp /var/log/syslog*  $rutactual/evidencias-actuales/logs/ >> log.txt 2>&1
	cp /var/log/boot.log*  $rutactual/evidencias-actuales/logs/ >> log.txt 2>&1
	cp /var/log/kern.log*  $rutactual/evidencias-actuales/logs/ >> log.txt 2>&1
	cp /var/log/lastlog* $rutactual/evidencias-actuales/logs/ >> log.txt 2>&1

	### Descomprime todos los archivos y los pasa a un solo archivo
	gunzip $rutactual/evidencias-actuales/logs/auth.log* >> log.txt 2>&1
	touch $rutactual/evidencias-actuales/logs/logfile_auth_log.txt
	for auth_log in $(ls $rutactual/evidencias-actuales/logs/auth.log*)
	do
		cat "$auth_log" >> $rutactual/evidencias-actuales/logs/logfile_auth_log.txt
	done
	if [ ! -s $rutactual/evidencias-actuales/logs/logfile_auth_log.txt ]
	then
		rm -rf $rutactual/evidencias-actuales/logs/logfile_auth_log.txt
	fi

	gunzip $rutactual/evidencias-actuales/logs/dpkg.log* >> log.txt 2>&1
	touch $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt
	for dpkg_log in $(ls $rutactual/evidencias-actuales/logs/dpkg.log*)
	do
		cat "$dpkg_log" >> $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt
	done
	if [ ! -s $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt ]
	then
		rm -rf $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt
	fi

	gunzip $rutactual/evidencias-actuales/logs/syslog* >> log.txt 2>&1
	touch $rutactual/evidencias-actuales/logs/logfile_syslog.txt
	for syslog in $(ls $rutactual/evidencias-actuales/logs/syslog*)
	do
		cat "$syslog" >> $rutactual/evidencias-actuales/logs/logfile_syslog.txt
	done
	if [ ! -s $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt ]
	then
		rm -rf $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt
	fi

	gunzip $rutactual/evidencias-actuales/logs/boot.log* >> log.txt 2>&1
	touch $rutactual/evidencias-actuales/logs/logfile_boot_log.txt
	for boot_log in $(ls $rutactual/evidencias-actuales/logs/boot.log*)
	do
		cat "$boot_log" >> $rutactual/evidencias-actuales/logs/logfile_boot_log.txt
	done
	if [ ! -s $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt ]
	then
		rm -rf $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt
	fi

	gunzip $rutactual/evidencias-actuales/logs/kern.log* >> log.txt 2>&1
	touch $rutactual/evidencias-actuales/logs/logfile_kern_log.txt
	for kern_log in $(ls $rutactual/evidencias-actuales/logs/kern.log*)
	do
		cat "$kern_log" >> $rutactual/evidencias-actuales/logs/logfile_kern_log.txt
	done
	if [ ! -s $rutactual/evidencias-actuales/logs/logfile_kern_log.txt ]
	then
		rm -rf $rutactual/evidencias-actuales/logs/logfile_kern_log.txt
	fi

	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Listo..."
	echo "$(tput setaf 7)"

	### Volcado de RAM
	if [[ $ram == "S" ]] || [[ $ram == "s" ]]
	then
		cd LiME/src/ || insmod lime-$(uname -r).ko "path=$rutactual/evidencias-actuales/volcado_memoria format=raw"
		rmmod lime
		cd ..
		cd ..
	fi

	echo "" >> log.txt

	### Inicio de las comparaciones de archivos recogidos para realizar el reporte del análisis
	touch $rutactual/evidencias-actuales/reporte.txt
	date +"Reporte realizado el %d/%m/%Y - %T" >> log.txt
	date +"Reporte realizado el %d/%m/%Y - %T" >> $rutactual/evidencias-actuales/reporte.txt
	echo "" >> $rutactual/evidencias-actuales/reporte.txt
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Analizando los archivos del sistema..."

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/kernelfirma.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/kernelfirma.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el kernel, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/kernelfirma.txt $rutactual/evidencias-actuales/archivos-de-sistema/kernelfirma.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] El kernel no ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] El kernel ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/kernelfirma.txt $rutactual/evidencias-actuales/archivos-de-sistema/kernelfirma.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/sudoersfirma.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/sudoersfirma.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el archivo sudoers, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/sudoersfirma.txt $rutactual/evidencias-actuales/archivos-de-sistema/sudoersfirma.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] El archivo sudoers no ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] El archivo sudoers ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/sudoers.txt $rutactual/evidencias-actuales/archivos-de-sistema/sudoers.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/shadowfirma.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/shadowfirma.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el archivo shadow, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/shadowfirma.txt $rutactual/evidencias-actuales/archivos-de-sistema/shadowfirma.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] El archivo shadow no ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] El archivo shadow ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/shadow.txt $rutactual/evidencias-actuales/archivos-de-sistema/shadow.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/passwdfirma.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/passwdfirma.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el archivo passwd, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/passwdfirma.txt $rutactual/evidencias-actuales/archivos-de-sistema/passwdfirma.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] El archivo passwd no ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] El archivo passwd ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/passwdfirma.txt $rutactual/evidencias-actuales/archivos-de-sistema/passwdfirma.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/root_bash_history.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/root_bash_history.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el archivo bash history, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/root_bash_history.txt $rutactual/evidencias-actuales/archivos-de-sistema/root_bash_history.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] El bash history no ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] El bash history ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/root_bash_history.txt $rutactual/evidencias-actuales/archivos-de-sistema/root_bash_history.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/dpkg.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/dpkg.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el archivo dpkg, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/dpkg.txt $rutactual/evidencias-actuales/archivos-de-sistema/dpkg.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se detectan paquetes nuevos/eliminados" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado paquetes nuevos/eliminados" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/dpkg.txt $rutactual/evidencias-actuales/archivos-de-sistema/dpkg.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/crontab.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/crontab.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre la configuración de crontab, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/crontab.txt $rutactual/evidencias-actuales/archivos-de-sistema/crontab.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] La configuración de crontab no ha sido modificada" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] La configuración de crontab ha sido modificada" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/crontab.txt $rutactual/evidencias-actuales/archivos-de-sistema/crontab.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/grub.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/grub.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el GRUB, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/grub.txt $rutactual/evidencias-actuales/archivos-de-sistema/grub.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] El GRUB no ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] El GRUB ha sido modificado" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/grub.txt $rutactual/evidencias-actuales/archivos-de-sistema/grub.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/dmesg.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/dmesg.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el buffer de mensajes del núcleo, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/dmesg.txt $rutactual/evidencias-actuales/archivos-de-sistema/dmesg.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] El buffer de mensajes del núcleo no ha cambiado" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] El buffer de mensajes del núcleo ha cambiado" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/dmesg.txt $rutactual/evidencias-actuales/archivos-de-sistema/dmesg.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/lastlog.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/lastlog.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el lastlog, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/lastlog.txt $rutactual/evidencias-actuales/archivos-de-sistema/lastlog.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se ha detectado un login nuevo desde la última vez" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se ha detectado un login nuevo desde la última vez" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/lastlog.txt $rutactual/evidencias-actuales/archivos-de-sistema/lastlog.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/archivos-de-sistema/runlevel.txt || ! -f $rutactual/evidencias-actuales/archivos-de-sistema/runlevel.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre el runlevel, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/archivos-de-sistema/runlevel.txt $rutactual/evidencias-actuales/archivos-de-sistema/runlevel.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] El modo de operación del sistema operativo no ha cambiado" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] El modo de operación del sistema operativo ha cambiado" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/archivos-de-sistema/runlevel.txt $rutactual/evidencias-actuales/archivos-de-sistema/runlevel.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi
	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Comparaciones de archivos de sistemas completadas"
	echo ""
	
	### Inicio de las comparaciones de archivos de red
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Analizando los archivos de configuraciones de red..."

	if [[ ! -f $rutaanterior/evidencias/red/ip.txt || ! -f $rutactual/evidencias-actuales/red/ip.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre la configuración de red, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/red/ip.txt $rutactual/evidencias-actuales/red/ip.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] La configuración de red no ha cambiado" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] La configuración de red ha cambiado" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/red/ip.txt $rutactual/evidencias-actuales/red/ip.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/red/netstat.txt || ! -f $rutactual/evidencias-actuales/red/netstat.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre las conexiones establecidas del sistema, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/red/netstat.txt $rutactual/evidencias-actuales/red/netstat.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se han detectado cambios en las conexiones establecidas del sistema" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado cambios en las conexiones establecidas del sistema" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/red/netstat.txt $rutactual/evidencias-actuales/red/netstat.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/red/dig.txt || ! -f $rutactual/evidencias-actuales/red/dig.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre las peticiones DNS, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[*] Peticiones DNS" >> $rutactual/evidencias-actuales/reporte.txt
		cat $rutaanterior/evidencias/red/dig.txt >> $rutactual/evidencias-actuales/reporte.txt
		echo "" >> $rutactual/evidencias-actuales/reporte.txt
		cat $rutactual/evidencias-actuales/red/dig.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/red/route.txt || ! -f $rutactual/evidencias-actuales/red/route.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre la tabla de enrutamiento, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/red/route.txt $rutactual/evidencias-actuales/red/route.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se han detectado cambios en la tabla de enrutamiento" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado cambios en la tabla de enrutamiento" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/red/route.txt $rutactual/evidencias-actuales/red/route.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/red/arp.txt || ! -f $rutactual/evidencias-actuales/red/arp.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre la tabla ARP, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/red/arp.txt $rutactual/evidencias-actuales/red/arp.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se han detectado cambios en la tabla ARP" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado cambios en la tabla ARP" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/red/arp.txt $rutactual/evidencias-actuales/red/arp.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/red/nmcli.txt || ! -f $rutactual/evidencias-actuales/red/nmcli.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre la configuración de red avanzada, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias-actuales/red/nmcli.txt $rutactual/evidencias-actuales/red/nmcli.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se han detectado cambios en la configuración de red avanzada" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado cambios en la configuración de red avanzada" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias-actuales/red/nmcli.txt $rutactual/evidencias-actuales/red/nmcli.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Comparaciones de red realiadas"
	echo ""

	### Iniciando comparaciones de los logs
	echo "$(tput setaf 7)[$(tput setaf 1)*$(tput setaf 7)]$(tput setaf 117) Analizando los archivos de los logs del sistema..."

	if [[ ! -f $rutaanterior/evidencias/logs/logfile_auth_log.txt || ! -f $rutactual/evidencias-actuales/logs/logfile_auth_log.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre en logfile_auth_log, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/logs/logfile_auth_log.txt $rutactual/evidencias-actuales/logs/logfile_auth_log.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se han detectado cambios en logfile_auth_log" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado cambios en logfile_auth_log" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/logs/logfile_auth_log.txt $rutactual/evidencias-actuales/logs/logfile_auth_log.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/logs/logfile_dpkg_log.txt || ! -f $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre en logfile_dpkg_log, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/logs/logfile_dpkg_log.txt $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se han detectado cambios en logfile_dpkg_log" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado cambios en logfile_dpkg:log" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/logs/logfile_dpkg_log.txt $rutactual/evidencias-actuales/logs/logfile_dpkg_log.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/logs/logfile_syslog.txt || ! -f $rutactual/evidencias-actuales/logs/logfile_syslog.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre en logfile_syslog, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/logs/logfile_syslog.txt $rutactual/evidencias-actuales/logs/logfile_syslog.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se han detectado cambios en logfile_syslog" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado cambios en logfile_syslog" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/logs/logfile_syslog.txt $rutactual/evidencias-actuales/logs/logfile_syslog.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/logs/logfile_boot_log.txt || ! -f $rutactual/evidencias-actuales/logs/logfile_boot_log.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre en logfile_boot_log, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/logs/logfile_boot_log.txt $rutactual/evidencias-actuales/logs/logfile_boot_log.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se han detectado cambios en logfile_boot_log" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado cambios en logfile_boot_log" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/logs/logfile_boot_log.txt $rutactual/evidencias-actuales/logs/logfile_boot_log.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	if [[ ! -f $rutaanterior/evidencias/logs/logfile_kern_log.txt || ! -f $rutactual/evidencias-actuales/logs/logfile_kern_log.txt ]]
	then
		echo "[?] No se ha podido recoger información sobre en logfile_kern_log, revise el log de la herramienta" >> $rutactual/evidencias-actuales/reporte.txt
	elif [[ $(cmp $rutaanterior/evidencias/logs/logfile_kern_log.txt $rutactual/evidencias-actuales/logs/logfile_kern_log.txt) == "" ]] >> log.txt 2>&1
	then
		echo "[*] No se han detectado cambios en logfile_kern_log" >> $rutactual/evidencias-actuales/reporte.txt
	else
		echo "[!] Se han detectado cambios en logfile_kern_log" >> $rutactual/evidencias-actuales/reporte.txt
		diff $rutaanterior/evidencias/logs/logfile_kern_log.txt $rutactual/evidencias-actuales/logs/logfile_kern_log.txt >> $rutactual/evidencias-actuales/reporte.txt
	fi

	### Fin del script
	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Todas las comparaciones han sido realizadas!"
	echo ""
	echo "$(tput setaf 7)[$(tput setaf 2)!$(tput setaf 7)]$(tput setaf 117) Ya hemos terminado! Tus resultados estan en la carpeta 'evidencias-actuales'$(tput setaf 7)"
	echo "" >> log.txt
	;;
	3) #Información del script
	echo ""
	echo "Información:
Linux's Doctor tiene las siguientes opciones:
	- Recoger información del sistema: Recoge los datos especificados más abajo del sistema
	- Análisis el sistema: Recoge los datos especificados más abajo del sistema y los compara con un reporte anterior
	- Información: Muestra información sobre el script
	- Salir: Sale del script
Algunos archivos puede que no se generen/copien dependiendo del sistema operativo que estes utilizando. El reporte estará divido en 5 secciones:
	- Archivos de sistema:
		- kernelfirma.txt: Firma en sha256 del archivo del kernel del sistema
		- sudoers.txt: Archivo que incluye una lista de los usuarios que pueden usar el comando sudo para obtener privilegios de administrador
		- sudoersfirma.txt: Firma en sha256 del archivo sudoers
		- shadow.txt: Archivo que contiene una lista con nombres de usuario, contraseñas cifradas, caducidad y validez de la cuenta
		- shadowfirma.txt: Firma en sha256 del archivo shadow
		- passwd.txt:  Archivo que contiene una lista con nombres de usuario, estado de su contraseña, UID, GID, carpeta por defecto para inicio de sesión y la shell que utiliza
		- passwdfirma.txt: Firma en sha256 del archivo passwd
		- root_bash_history.txt: Arhicvo que contiene el historial de comandos del usuario root
		- dpkg.txt: Archivo que contiene una lista de los paquetes instalados en el sistema
		- crontab.txt: Archivo que contiene la configuración de cron
		- grub.txt: Archivo que contiene la configuración del GRUB
	 	- dmesg.txt: Archivo que muestra el buffer de mensajes del núcleo
	 	- lastlog.txt: Archivo que muestra el último login realizado por los usuarios del sistema
	 	- runlevel.txt: Archivo que muestra el modo de operación del sistema operativo
	- Red:
		- ip.txt, nmcli.txt: Archivo que muestra información sobre las tarjetas de red existentes
		- netstat.txt: Archivo que muestra información sobre las conexiones del sistema
		- dig.txt: Archivo que muestra información sobre quien contesta a las peticiones DNS del sistema
		- route.txt: Archivo que muestra información sobre las tabla de enrutamiento del sistema
		- arp.txt: Archivo que muestra información sobre las tabla ARP del sistema
	- Logs:
		- auth.log*: Copia los logs de acceso al sistema
		- dpkg.log*: Copia los logs de estado de los paquetes del sistema
		- syslog*: Copia los logs del sistema
		- boot.log*: Copia los logs del inicio del sistema
		- kern.log*: Copia los logs del kernel del sistema
		- logfile_auth_log.txt, logfile_dpkg_log.txt, logfile_syslog.txt, logfile_boot_log.txt, logfile_kern_log.txt: Todos los logs en un archivo
	- Volcado de memoria la RAM
	- reporte.txt: En el caso que hayas elegido analizar el sistema, se generará un reporte con las diferencias encontradas"
	echo ""
	;;
	4) #Salir
		exit
esac
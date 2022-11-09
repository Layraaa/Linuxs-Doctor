# analsis.sh
# Archivo que contiene las funciones para realizar la
# recogida de datos del sistema

function analisis (){
	date=$(date +"%Y.%m.%d-%H.%M.%S")
	rutadatos="$rutareporte/evidencias-$date"
	mkdir "$rutadatos" >> log.txt 2>&1
	touch "$rutadatos"/analisis.txt >> log.txt 2>&1
	if [ ! -f "$rutadatos"/analisis.txt ]
	then
		echo "No se ha podido crear el archivo analisis.txt, revise el log de la herramienta"
		echo "Se ha cancelado la recogida de datos ya que no se pudo crear el archivo analisis.txt" >> log.txt
		exit
	fi
	echo "*NO MODIFIQUES ESTE ARCHIVO, PUEDE GENERAR ERRORES AL SER COMPARADO CON OTROS REPORTES*" >> "$rutadatos"/analisis.txt
	echo "*HAZLO SOLO SI SABES LO QUE ESTAS HACIENDO*" >> "$rutadatos"/analisis.txt
	echo "" >> "$rutadatos"/analisis.txt
	echo "Sistema operativo: $(cat /etc/os-release | grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')" >> "$rutadatos"/analisis.txt
	echo "Version del sistema operativo: $(uname -r)" >> "$rutadatos"/analisis.txt
	echo "Direccion IP: $(hostname -I)" >> "$rutadatos"/analisis.txt
	echo "" >> "$rutadatos"/analisis.txt
	echo "Version de Linux's Doctor: 1.1" >> "$rutadatos"/analisis.txt
	echo "Tipo de análisis: $linuxsdoctor" >> "$rutadatos"/analisis.txt
	date +"Hora de Inicio: %T" >> "$rutadatos"/analisis.txt
	echo "Hora de Finalizacion: -" >> "$rutadatos"/analisis.txt
}

function finanalisis (){
	# Elimina la última linea e indica la hora final de la recogida de datos
	tail -n 1 "$rutadatos/analisis.txt" | wc -c | xargs -I {} truncate "$rutadatos/analisis.txt" -s -{}
	date +"Hora de Finaliazacion: %T" >> "$rutadatos"/analisis.txt
}

function recogidadatosDebian (){
	# Recogida de información del sistema
	mkdir "$rutadatos"/archivos-de-sistema >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Recogiendo archivos del sistema..."
	sha256sum /boot/vmlinuz-"$(uname -r)" > "$rutadatos"/archivos-de-sistema/kernelfirma.txt
	cat /etc/sudoers > "$rutadatos"/archivos-de-sistema/sudoers.txt
	sha256sum /etc/sudoers > "$rutadatos"/archivos-de-sistema/sudoersfirma.txt
	cat /etc/shadow > "$rutadatos"/archivos-de-sistema/shadow.txt
	sha256sum /etc/shadow > "$rutadatos"/archivos-de-sistema/shadowfirma.txt
	cat /etc/passwd > "$rutadatos"/archivos-de-sistema/passwd.txt
	sha256sum /etc/passwd > "$rutadatos"/archivos-de-sistema/passwdfirma.txt
	cat /root/.bash_history > "$rutadatos"/archivos-de-sistema/root_bash_history.txt
	dpkg-query -f '${binary:Package}\n' -W > "$rutadatos"/archivos-de-sistema/dpkg.txt
	cat /etc/crontab > "$rutadatos"/archivos-de-sistema/crontab.txt
	crontab -l > "$rutadatos"/archivos-de-sistema/crontabl.txt 2>&1
	cat /etc/default/grub > "$rutadatos"/archivos-de-sistema/grub.txt
	cat /etc/network/interfaces > "$rutadatos"/archivos-de-sistema/interfaces.txt
	cat /etc/profile > "$rutadatos"/archivos-de-sistema/profile.txt
	cat /etc/hosts > "$rutadatos"/archivos-de-sistema/hosts.txt
	cat /etc/fstab > "$rutadatos"/archivos-de-sistema/fstab.txt
	cat /etc/mtab > "$rutadatos"/archivos-de-sistema/mtab.txt
	cat /etc/group > "$rutadatos"/archivos-de-sistema/group.txt
	mkdir "$rutadatos"/archivos-de-sistema/rc.d
	cp -r /etc/rc*.d/ "$rutadatos"/archivos-de-sistema/rc.d/ >> log.txt 2>&1
	for i in $(ls "$rutadatos"/archivos-de-sistema/rc.d/)
	do
		path="$(ls "$rutadatos"/archivos-de-sistema/rc.d/"$i")"
		rm -rf "$rutadatos"/archivos-de-sistema/rc.d/"$i"/*
		for x in $path
		do
			cat /etc/"$i"/"$x" >> "$rutadatos"/archivos-de-sistema/rc.d/"$i"/"$x"
		done
	done
	cp -r /etc/init.d/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.d/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.hourly/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.dialy/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.weekely/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.monthly/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cat /proc/cmdline > "$rutadatos"/archivos-de-sistema/cmdline.txt
	blkid > "$rutadatos"/archivos-de-sistema/blkid.txt
	lastlog > "$rutadatos"/archivos-de-sistema/lastlog.txt
	runlevel > "$rutadatos"/archivos-de-sistema/runlevel.txt
	lspci -vvv > "$rutadatos"/archivos-de-sistema/lspci.txt
	fdisk -l > "$rutadatos"/archivos-de-sistema/fdisk.txt
	printenv > "$rutadatos"/archivos-de-sistema/printenv.txt
	cat /etc/machine-id > "$rutadatos"/archivos-de-sistema/machine_id.txt
	cat /sys/class/dmi/id/product_uuid > "$rutadatos"/archivos-de-sistema/product_uuid.txt
	cat /etc/resolv.conf > "$rutadatos"/archivos-de-sistema/resolv.txt
	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo ""

	# Recogiendo información sobre la configuración de red del dispositivo
	mkdir "$rutadatos"/red >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Recogiendo información sobre la configuración de red del dispositivo..."
	nmcli dev show | sed '/^IP[4-6].ROUTE/d' > "$rutadatos"/red/nmcli.txt
	netstat -ltun | awk '{$2=$3=""; print $0}' | awk '($1=$1) || 1' OFS=\\t | tail -n +2 | sort > "$rutadatos"/red/netstat.txt
	dig +short | sort > "$rutadatos"/red/dig.txt
	route > "$rutadatos"/red/route.txt
	arp -v -e > "$rutadatos"/red/arp.txt
	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo ""

	# Recogiendo información sobre los servicios del sistema
	mkdir "$rutadatos"/servicios >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Recogiendo información sobre los servicios del sistema..."

	systemctl show -p ActiveState iptables | sed 's/ActiveState=//g' > "$rutadatos"/servicios/iptables.txt
	echo "" >> "$rutadatos"/servicios/iptables.txt
	echo "-----" >> "$rutadatos"/servicios/iptables.txt
	echo "" >> "$rutadatos"/servicios/iptables.txt
	iptables -L >> "$rutadatos"/servicios/iptables.txt

	firewall-cmd --list-all > "$rutadatos"/servicios/firewalld.txt 2>&1
	echo "" >> "$rutadatos"/servicios/firewalld.txt
	echo "-----" >> "$rutadatos"/servicios/firewalld.txt
	echo "" >> "$rutadatos"/servicios/firewalld.txt
	cat /etc/firewalld/firewalld.conf >> "$rutadatos"/servicios/firewalld.txt

	ufw status verbose > "$rutadatos"/servicios/ufw.txt
	echo "" >> "$rutadatos"/servicios/ufw.txt
	echo "-----" >> "$rutadatos"/servicios/ufw.txt
	echo "" >> "$rutadatos"/servicios/ufw.txt
	cat /etc/default/ufw >> "$rutadatos"/servicios/ufw.txt

	systemctl show -p ActiveState isc-dchp-server | sed 's/ActiveState=//g' > "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	echo "-----" >> "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	echo "/etc/dhcp/dhcpd.conf" >> "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	cat /etc/dhcp/dhcpd.conf >> "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	echo "/etc/dhcp/dhcpd6.conf" >> "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	cat /etc/dhcp/dhcpd6.conf >> "$rutadatos"/servicios/dhcp.txt

	systemctl show -p ActiveState named | sed 's/ActiveState=//g' > "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "-----" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "/etc/bind/named.conf" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	cat /etc/bind/named.conf >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "/etc/bind/named.conf.options" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	cat /etc/bind/named.conf.options >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "/etc/bind/named.conf.local" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	cat /etc/bind/named.conf.local >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "/etc/bind/named.conf.default-zones" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	cat /etc/bind/named.conf.default-zones >> "$rutadatos"/servicios/dns.txt

	systemctl show -p ActiveState vsftpd | sed 's/ActiveState=//g' > "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	echo "-----" >> "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	echo "/etc/vsftpd.conf" >> "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	cat /etc/vsftpd.conf >> "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	echo "/etc/ftpusers" >> "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	cat /etc/ftpusers >> "$rutadatos"/servicios/vsftpd.txt

	systemctl show -p ActiveState smbd | sed 's/ActiveState=//g' > "$rutadatos"/servicios/samba.txt
	echo "" >> "$rutadatos"/servicios/samba.txt
	echo "-----" >> "$rutadatos"/servicios/samba.txt
	echo "" >> "$rutadatos"/servicios/samba.txt
	cat /etc/samba/smb.conf >> "$rutadatos"/servicios/samba.txt

	systemctl show -p ActiveState apache2 | sed 's/ActiveState=//g' > "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	echo "-----" >> "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	echo "/etc/apache2/apache2.conf" >> "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	cat /etc/apache2/apache2.conf >> "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	echo "/etc/apache2/ports.conf" >> "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	cat /etc/apache2/ports.conf >> "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	echo "/etc/apache2/sites-available" >> "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	for i in $(ls /etc/apache2/sites-available/)
	do
		echo "/etc/apache2/sites-available/$i" >> "$rutadatos"/servicios/apache.txt
		echo "" >> "$rutadatos"/servicios/apache.txt
		cat "/etc/apache2/sites-available/$i" >> "$rutadatos"/servicios/apache.txt
		echo "" >> "$rutadatos"/servicios/apache.txt
	done

	systemctl show -p ActiveState mariadb | sed 's/ActiveState=//g' > "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "-----" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "/etc/mysql/my.cnf" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	cat /etc/mysql/my.cnf >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "/etc/mysql/conf.d" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	for i in $(ls /etc/mysql/conf.d/)
	do
		echo "/etc/mysql/conf.d/$i" >> "$rutadatos"/servicios/mariadb.txt
		echo "" >> "$rutadatos"/servicios/mariadb.txt
		cat "/etc/mysql/conf.d/$i" >> "$rutadatos"/servicios/mariadb.txt
		echo "" >> "$rutadatos"/servicios/mariadb.txt
	done
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "/etc/mysql/mariadb.conf.d" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	for i in $(ls /etc/mysql/mariadb.conf.d/)
	do
		echo "/etc/mysql/mariadb.conf.d/$i" >> "$rutadatos"/servicios/mariadb.txt
		echo "" >> "$rutadatos"/servicios/mariadb.txt
		cat "/etc/mysql/mariadb.conf.d/$i" >> "$rutadatos"/servicios/mariadb.txt
		echo "" >> "$rutadatos"/servicios/mariadb.txt
	done

	systemctl show -p ActiveState squid | sed 's/ActiveState=//g' > "$rutadatos"/servicios/squid.txt
	echo "" >> "$rutadatos"/servicios/squid.txt
	echo "-----" >> "$rutadatos"/servicios/squid.txt
	echo "" >> "$rutadatos"/servicios/squid.txt
	echo "/etc/squid/squid.conf" >> "$rutadatos"/servicios/squid.txt
	echo "" >> "$rutadatos"/servicios/squid.txt
	cat /etc/squid/squid.conf >> "$rutadatos"/servicios/squid.txt
	echo "" >> "$rutadatos"/servicios/squid.txt
	echo "/etc/squid/conf.d" >> "$rutadatos"/servicios/squid.txt
	echo "" >> "$rutadatos"/servicios/squid.txt
	echo "" >> "$rutadatos"/servicios/squid.txt
	for i in $(ls /etc/squid/conf.d/)
	do
		echo "/etc/squid/conf.d/$i" >> "$rutadatos"/servicios/squid.txt
		echo "" >> "$rutadatos"/servicios/squid.txt
		cat "/etc/squid/conf.d/$i" >> "$rutadatos"/servicios/squid.txt
		echo "" >> "$rutadatos"/servicios/squid.txt
	done

	systemctl show -p ActiveState sshd | sed 's/ActiveState=//g' > "$rutadatos"/servicios/ssh.txt
	echo "" >> "$rutadatos"/servicios/ssh.txt
	echo "-----" >> "$rutadatos"/servicios/ssh.txt
	echo "" >> "$rutadatos"/servicios/ssh.txt
	cat /etc/ssh/sshd_config >> "$rutadatos"/servicios/ssh.txt

	for i in $(ls /etc/php/)
	do
		echo "/etc/php/$i/apache2/php.ini" >> "$rutadatos"/servicios/php.txt
		echo "" >> "$rutadatos"/servicios/php.txt
		cat "/etc/php/$i/apache2/php.ini" >> "$rutadatos"/servicios/php.txt
		echo "" >> "$rutadatos"/servicios/php.txt
	done

	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo ""

	# Recoge logs del sistema
	echo "${white}[${red}*${white}]${lightblue} Recogiendo los logs del sistema..."
	mkdir  "$rutadatos"/logs-sistema >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/auth >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/dpkg >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/syslog >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/boot >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/kern >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/lastlog >> log.txt 2>&1
	cp /var/log/auth.log*  "$rutadatos"/logs-sistema/auth/ >> log.txt 2>&1
	cp /var/log/dpkg.log*  "$rutadatos"/logs-sistema/dpkg/ >> log.txt 2>&1
	cp /var/log/syslog*  "$rutadatos"/logs-sistema/syslog/ >> log.txt 2>&1
	cp /var/log/boot.log*  "$rutadatos"/logs-sistema/boot/ >> log.txt 2>&1
	cp /var/log/kern.log*  "$rutadatos"/logs-sistema/kern/ >> log.txt 2>&1
	cp /var/log/lastlog* "$rutadatos"/logs-sistema/lastlog/ >> log.txt 2>&1

	# Descomprime todos los logs del sistema y copia su contenido a un solo archivo
	gunzip "$rutadatos"/logs-sistema/auth/auth.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/auth/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
			echo "" >> "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
			cat "$rutadatos"/logs-sistema/auth/"$i" >> "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
			echo "" >> "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/dpkg/dpkg.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/dpkg/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
			echo "" >> "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
			cat "$rutadatos"/logs-sistema/dpkg/"$i" >> "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
			echo "" >> "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/syslog/syslog* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/syslog/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/syslog/logfile_syslog.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/syslog/logfile_syslog.txt
			echo "" >> "$rutadatos"/logs-sistema/syslog/logfile_syslog.txt
			cat "$rutadatos"/logs-sistema/syslog/"$i" >> "$rutadatos"/logs-sistema/syslog/logfile_syslog.txt
			echo "" >> "$rutadatos"/logs-sistema/syslog/logfile_syslog.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/boot/boot.log* >> log.txt 2>&1	
	path=$(ls "$rutadatos"/logs-sistema/boot/)
	if [[ -n $path ]] 2>> log.txt
	then	
		touch "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
			echo "" >> "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
			cat "$rutadatos"/logs-sistema/boot/"$i" >> "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
			echo "" >> "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/kern/kern.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/kern/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
			echo "" >> "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
			cat "$rutadatos"/logs-sistema/kern/"$i" >> "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
			echo "" >> "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/lastlog/lastlog* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/lastlog/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
			echo "" >> "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
			cat "$rutadatos"/logs-sistema/lastlog/"$i" >> "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
			echo "" >> "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
		done
	fi

	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo ""

	# Recoge logs de los servicios
	echo "${white}[${red}*${white}]${lightblue} Recogiendo los logs de los servicios..."
	mkdir  "$rutadatos"/logs-servicios >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-servicios/ufw >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-servicios/samba >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-servicios/apache2 >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-servicios/squid >> log.txt 2>&1
	cp /var/log/ufw* "$rutadatos"/logs-servicios/ufw/ >> log.txt 2>&1
	cp /var/log/samba/log.smbd* "$rutadatos"/logs-servicios/samba/ >> log.txt 2>&1
	cp /var/log/samba/log.nmbd* "$rutadatos"/logs-servicios/samba/ >> log.txt 2>&1
	cp /var/log/apache2/error.log* "$rutadatos"/logs-servicios/apache2/ >> log.txt 2>&1
	cp /var/log/apache2/access.log* "$rutadatos"/logs-servicios/apache2/ >> log.txt 2>&1
	cat /var/log/firewalld > "$rutadatos"/logs-servicios/firewalld.txt 2>> log.txt
	cat /var/log/vsftpd.log > "$rutadatos"/logs-servicios/vsftpd.txt 2>> log.txt
	cat /var/log/mariadb.log > "$rutadatos"/logs-servicios/mariadb.txt 2>> log.txt
	cat /var/log/squid/access.log > "$rutadatos"/logs-servicios/squid/access.txt 2>> log.txt
	cat /var/log/squid/cache.log > "$rutadatos"/logs-servicios/squid/cache.txt 2>> log.txt

	# Descomprime todos los logs del los servicios y copia su contenido a un solo archivo

	gunzip "$rutadatos"/logs-servicios/ufw/ufw* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/ufw/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
			echo "" >> "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
			cat "$rutadatos"/logs-servicios/ufw/"$i" >> "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
			echo "" >> "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
		done
	fi

	gunzip "$rutadatos"/logs-servicios/samba/log.smbd* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/samba/log.smbd*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
		for i in $path
		do
			echo "${i//"$rutadatos/logs-servicios/samba/"/}" >> "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
			echo "" >> "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
			cat "$i" >> "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
			echo "" >> "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
		done
	fi

	gunzip "$rutadatos"/logs-servicios/samba/log.nmbd* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/samba/log.nmbd*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
		for i in $path
		do
			echo "${i//"$rutadatos/logs-servicios/samba/"/}" >> "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
			echo "" >> "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
			cat "$i" >> "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
			echo "" >> "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
		done
	fi
	
	gunzip "$rutadatos"/logs-servicios/apache2/error.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/apache2/error.log*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/apache2/logfile_error.log.txt
		for i in $path
		do
			echo "${i//"$rutadatos/logs-servicios/apache2/"/}" >> "$rutadatos"/logs-servicios/apache2/logfile_error.log.txt
			echo "" >> "$rutadatos"/logs-servicios/apache2/logfile_error.log.txt
			cat "$i" >> "$rutadatos"/logs-servicios/apache2/logfile_error.log.txt
			echo "" >> "$rutadatos"/logs-servicios/apache2/logfile_error.log.txt
		done
	fi

	gunzip "$rutadatos"/logs-servicios/apache2/access.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/apache2/access.log*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/apache2/logfile_access.log.txt
		for i in $path
		do
			echo "${i//"$rutadatos/logs-servicios/apache2/"/}" >> "$rutadatos"/logs-servicios/apache2/logfile_access.log.txt
			echo "" >> "$rutadatos"/logs-servicios/apache2/logfile_access.log.txt
			cat "$i" >> "$rutadatos"/logs-servicios/apache2/logfile_access.log.txt
			echo "" >> "$rutadatos"/logs-servicios/apache2/logfile_access.log.txt
		done
	fi

	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo "${white}"

	# Volcado de RAM
	if [[ $ram == "S" ]] || [[ $ram == "s" ]]
	then
		if [[ ! -d LiME/src ]]
		then
			echo "${white}[${green}!${white}]${lightblue} Realizando volcado de la memoria RAM..."
			echo "${white}"
			echo "Realizando volcado de la memoria RAM" >> log.txt
			cd LiME/src/ || return
			insmod lime-"$(uname -r)".ko "path=$rutadatos/volcado_memoria format=raw"
			rmmod lime
			cd ..
			cd ..
			echo "${white}[${green}!${white}]${lightblue} Listo..."
			echo "${white}"
		else
			echo "No se detectó LiME para hacer el volcado de la memoria RAM"
			echo "No se detectó LiME para hacer el volcado de la memoria RAM" >> log.txt
		fi
	fi
	echo "" >> log.txt
}

function recogidadatosCentOS (){
	# Recogida de información del sistema
	mkdir "$rutadatos"/archivos-de-sistema >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Recogiendo archivos del sistema..."
	sha256sum /boot/vmlinuz-"$(uname -r)" > "$rutadatos"/archivos-de-sistema/kernelfirma.txt
	cat /etc/sudoers > "$rutadatos"/archivos-de-sistema/sudoers.txt
	sha256sum /etc/sudoers > "$rutadatos"/archivos-de-sistema/sudoersfirma.txt
	cat /etc/shadow > "$rutadatos"/archivos-de-sistema/shadow.txt
	sha256sum /etc/shadow > "$rutadatos"/archivos-de-sistema/shadowfirma.txt
	cat /etc/passwd > "$rutadatos"/archivos-de-sistema/passwd.txt
	sha256sum /etc/passwd > "$rutadatos"/archivos-de-sistema/passwdfirma.txt
	cat /root/.bash_history > "$rutadatos"/archivos-de-sistema/root_bash_history.txt
	rpm -qa > "$rutadatos"/archivos-de-sistema/dpkg.txt
	cat /etc/crontab > "$rutadatos"/archivos-de-sistema/crontab.txt
	crontab -l > "$rutadatos"/archivos-de-sistema/crontabl.txt 2>&1
	cat /etc/default/grub > "$rutadatos"/archivos-de-sistema/grub.txt
	for i in $(ls /etc/sysconfig/network-scripts/ifcfg-*)
	do
		echo "$i" >> "$rutadatos"/archivos-de-sistema/interfaces.txt
		echo "" >> "$rutadatos"/archivos-de-sistema/interfaces.txt
		cat "$i" >> "$rutadatos"/archivos-de-sistema/interfaces.txt
		echo "" >> "$rutadatos"/archivos-de-sistema/interfaces.txt
	done
	cat /etc/profile > "$rutadatos"/archivos-de-sistema/profile.txt
	cat /etc/hosts > "$rutadatos"/archivos-de-sistema/hosts.txt
	cat /etc/fstab > "$rutadatos"/archivos-de-sistema/fstab.txt
	cat /etc/mtab > "$rutadatos"/archivos-de-sistema/mtab.txt
	cat /etc/group > "$rutadatos"/archivos-de-sistema/group.txt
	mkdir "$rutadatos"/archivos-de-sistema/rc.d
	cp -r /etc/rc.d/rc*.d/ "$rutadatos"/archivos-de-sistema/rc.d/ >> log.txt 2>&1
	for i in $(ls "$rutadatos"/archivos-de-sistema/rc.d/)
	do
		path="$(ls "$rutadatos"/archivos-de-sistema/rc.d/"$i")"
		rm -rf "$rutadatos"/archivos-de-sistema/rc.d/"$i"/*
		for x in $path
		do
			cat /etc/"$i"/"$x" >> "$rutadatos"/archivos-de-sistema/rc.d/"$i"/"$x"
		done
	done
	cp -r /etc/init.d/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.d/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.hourly/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.dialy/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.weekely/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cp -r /etc/cron.monthly/ "$rutadatos"/archivos-de-sistema/ >> log.txt 2>&1
	cat /proc/cmdline > "$rutadatos"/archivos-de-sistema/cmdline.txt
	blkid > "$rutadatos"/archivos-de-sistema/blkid.txt
	lastlog > "$rutadatos"/archivos-de-sistema/lastlog.txt
	runlevel > "$rutadatos"/archivos-de-sistema/runlevel.txt
	lspci -vvv > "$rutadatos"/archivos-de-sistema/lspci.txt
	fdisk -l > "$rutadatos"/archivos-de-sistema/fdisk.txt
	printenv > "$rutadatos"/archivos-de-sistema/printenv.txt
	cat /etc/machine-id > "$rutadatos"/archivos-de-sistema/machine_id.txt
	cat /sys/class/dmi/id/product_uuid > "$rutadatos"/archivos-de-sistema/product_uuid.txt
	cat /etc/resolv.conf > "$rutadatos"/archivos-de-sistema/resolv.txt
	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo ""

	# Recogiendo información sobre la configuración de red del dispositivo
	mkdir "$rutadatos"/red >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Recogiendo información sobre la configuración de red del dispositivo..."
	nmcli dev show | sed '/^IP[4-6].ROUTE/d' > "$rutadatos"/red/nmcli.txt
	netstat -ltun | awk '{$2=$3=""; print $0}' | awk '($1=$1) || 1' OFS=\\t | tail -n +2 | sort > "$rutadatos"/red/netstat.txt
	dig +short | sort > "$rutadatos"/red/dig.txt
	route > "$rutadatos"/red/route.txt
	arp -v -e > "$rutadatos"/red/arp.txt
	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo ""

	# Recogiendo información sobre los servicios del sistema
	mkdir "$rutadatos"/servicios >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Recogiendo información sobre los servicios del sistema..."

	systemctl show -p ActiveState iptables | sed 's/ActiveState=//g' > "$rutadatos"/servicios/iptables.txt
	echo "" >> "$rutadatos"/servicios/iptables.txt
	echo "-----" >> "$rutadatos"/servicios/iptables.txt
	echo "" >> "$rutadatos"/servicios/iptables.txt
	iptables -L >> "$rutadatos"/servicios/iptables.txt

	firewall-cmd --list-all > "$rutadatos"/servicios/firewalld.txt 2>&1
	echo "" >> "$rutadatos"/servicios/firewalld.txt
	echo "-----" >> "$rutadatos"/servicios/firewalld.txt
	echo "" >> "$rutadatos"/servicios/firewalld.txt
	cat /etc/firewalld/firewalld.conf >> "$rutadatos"/servicios/firewalld.txt

	ufw status verbose > "$rutadatos"/servicios/ufw.txt
	echo "" >> "$rutadatos"/servicios/ufw.txt
	echo "-----" >> "$rutadatos"/servicios/ufw.txt
	echo "" >> "$rutadatos"/servicios/ufw.txt
	cat /etc/default/ufw >> "$rutadatos"/servicios/ufw.txt

	systemctl show -p ActiveState dhcpd | sed 's/ActiveState=//g' > "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	echo "-----" >> "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	echo "/etc/dhcp/dhcpd.conf" >> "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	cat /etc/dhcp/dhcpd.conf >> "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	echo "/etc/dhcp/dhcpd6.conf" >> "$rutadatos"/servicios/dhcp.txt
	echo "" >> "$rutadatos"/servicios/dhcp.txt
	cat /etc/dhcp/dhcpd6.conf >> "$rutadatos"/servicios/dhcp.txt

	systemctl show -p ActiveState named | sed 's/ActiveState=//g' > "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "-----" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "/etc/named.conf" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	cat /etc/named.conf >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "/etc/named.rfc1912.zones" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	cat /etc/named.rfc1912.zones >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "/etc/named.root.key" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	cat /etc/named.root.key >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	echo "/etc/named.iscdlv.key" >> "$rutadatos"/servicios/dns.txt
	echo "" >> "$rutadatos"/servicios/dns.txt
	cat /etc/named.iscdlv.key >> "$rutadatos"/servicios/dns.txt

	systemctl show -p ActiveState vsftpd | sed 's/ActiveState=//g' > "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	echo "-----" >> "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	echo "/etc/vsftpd/vsftpd.conf" >> "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	cat /etc/vsftpd/vsftpd.conf >> "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	echo "/etc/vsftpd/ftpusers" >> "$rutadatos"/servicios/vsftpd.txt
	echo "" >> "$rutadatos"/servicios/vsftpd.txt
	cat /etc/vsftpd/ftpusers >> "$rutadatos"/servicios/vsftpd.txt

	systemctl show -p ActiveState smb | sed 's/ActiveState=//g' > "$rutadatos"/servicios/samba.txt
	echo "" >> "$rutadatos"/servicios/samba.txt
	echo "-----" >> "$rutadatos"/servicios/samba.txt
	echo "" >> "$rutadatos"/servicios/samba.txt
	cat /etc/samba/smb.conf >> "$rutadatos"/servicios/samba.txt

	systemctl show -p ActiveState httpd | sed 's/ActiveState=//g' > "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	echo "-----" >> "$rutadatos"/servicios/apache.txt
	echo "" >> "$rutadatos"/servicios/apache.txt
	cat /etc/httpd/conf/httpd.conf >> "$rutadatos"/servicios/apache.txt

	systemctl show -p ActiveState mariadb | sed 's/ActiveState=//g' > "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "-----" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "/etc/my.cnf" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	cat /etc/my.cnf >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "/etc/my.cnf.d/" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	echo "" >> "$rutadatos"/servicios/mariadb.txt
	for i in $(ls /etc/my.cnf.d/)
	do
		echo "/etc/my.cnf.d/$i" >> "$rutadatos"/servicios/mariadb.txt
		echo "" >> "$rutadatos"/servicios/mariadb.txt
		cat "/etc/my.cnf.d/$i" >> "$rutadatos"/servicios/mariadb.txt
		echo "" >> "$rutadatos"/servicios/mariadb.txt
	done
	
	systemctl show -p ActiveState squid | sed 's/ActiveState=//g' > "$rutadatos"/servicios/squid.txt
	echo "" >> "$rutadatos"/servicios/squid.txt
	echo "-----" >> "$rutadatos"/servicios/squid.txt
	echo "" >> "$rutadatos"/servicios/squid.txt
	cat /etc/squid/squid.conf >> "$rutadatos"/servicios/squid.txt

	systemctl show -p ActiveState sshd | sed 's/ActiveState=//g' > "$rutadatos"/servicios/ssh.txt
	echo "" >> "$rutadatos"/servicios/ssh.txt
	echo "-----" >> "$rutadatos"/servicios/ssh.txt
	echo "" >> "$rutadatos"/servicios/ssh.txt
	cat /etc/ssh/sshd_config >> "$rutadatos"/servicios/ssh.txt

	cat /etc/php.ini >> "$rutadatos"/servicios/php.txt

	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo ""

	# Recoge logs del sistema
	echo "${white}[${red}*${white}]${lightblue} Recogiendo los logs del sistema..."
	mkdir  "$rutadatos"/logs-sistema >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/auth >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/dpkg >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/messages >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/boot >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/kern >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-sistema/lastlog >> log.txt 2>&1
	cp /var/log/auth.log*  "$rutadatos"/logs-sistema/auth/ >> log.txt 2>&1
	cp /var/log/dpkg.log*  "$rutadatos"/logs-sistema/dpkg/ >> log.txt 2>&1
	cp /var/log/messages*  "$rutadatos"/logs-sistema/messages/ >> log.txt 2>&1
	cp /var/log/boot.log*  "$rutadatos"/logs-sistema/boot/ >> log.txt 2>&1
	cp /var/log/kern.log*  "$rutadatos"/logs-sistema/kern/ >> log.txt 2>&1
	cp /var/log/lastlog* "$rutadatos"/logs-sistema/lastlog/ >> log.txt 2>&1

	# Descomprime todos los logs del sistema y copia su contenido a un solo archivo
	gunzip "$rutadatos"/logs-sistema/auth/auth.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/auth/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
			echo "" >> "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
			cat "$rutadatos"/logs-sistema/auth/"$i" >> "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
			echo "" >> "$rutadatos"/logs-sistema/auth/logfile_auth_log.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/dpkg/dpkg.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/dpkg/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
			echo "" >> "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
			cat "$rutadatos"/logs-sistema/dpkg/"$i" >> "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
			echo "" >> "$rutadatos"/logs-sistema/dpkg/logfile_dpkg_log.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/messages/messages* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/messages/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/messages/logfile_messages.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/messages/logfile_messages.txt
			echo "" >> "$rutadatos"/logs-sistema/messages/logfile_messages.txt
			cat "$rutadatos"/logs-sistema/messages/"$i" >> "$rutadatos"/logs-sistema/messages/logfile_messages.txt
			echo "" >> "$rutadatos"/logs-sistema/messages/logfile_messages.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/boot/boot.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/boot/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
			echo "" >> "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
			cat "$rutadatos"/logs-sistema/boot/"$i" >> "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
			echo "" >> "$rutadatos"/logs-sistema/boot/logfile_boot_log.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/kern/kern.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/kern/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
			echo "" >> "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
			cat "$rutadatos"/logs-sistema/kern/"$i" >> "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
			echo "" >> "$rutadatos"/logs-sistema/kern/logfile_kern_log.txt
		done
	fi

	gunzip "$rutadatos"/logs-sistema/lastlog/lastlog* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-sistema/lastlog/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
			echo "" >> "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
			cat "$rutadatos"/logs-sistema/lastlog/"$i" >> "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
			echo "" >> "$rutadatos"/logs-sistema/lastlog/logfile_lastlog.txt
		done
	fi

	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo ""

	# Recoge logs de los servicios
	echo "${white}[${red}*${white}]${lightblue} Recogiendo los logs de los servicios..."
	mkdir  "$rutadatos"/logs-servicios >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-servicios/ufw >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-servicios/samba >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-servicios/httpd >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-servicios/squid >> log.txt 2>&1
	cp /var/log/ufw* "$rutadatos"/logs-servicios/ufw/ >> log.txt 2>&1
	cp /var/log/samba/log.smbd* "$rutadatos"/logs-servicios/samba/ >> log.txt 2>&1
	cp /var/log/samba/log.nmbd* "$rutadatos"/logs-servicios/samba/ >> log.txt 2>&1
	cp /var/log/httpd/error_log* "$rutadatos"/logs-servicios/httpd/ >> log.txt 2>&1
	cp /var/log/httpd/access_log* "$rutadatos"/logs-servicios/httpd/ >> log.txt 2>&1
	cat /var/log/firewalld > "$rutadatos"/logs-servicios/firewalld.txt 2>> log.txt
	cat /var/log/vsftpd.log > "$rutadatos"/logs-servicios/vsftpd.txt 2>> log.txt
	cat /var/log/mariadb/mariadb.log > "$rutadatos"/logs-servicios/mariadb.txt 2>> log.txt
	cat /var/log/squid/access.log > "$rutadatos"/logs-servicios/squid/access.txt 2>> log.txt
	cat /var/log/squid/cache.log > "$rutadatos"/logs-servicios/squid/cache.txt 2>> log.txt

	# Descomprime todos los logs del los servicios y copia su contenido a un solo archivo
	gunzip "$rutadatos"/logs-servicios/ufw/ufw* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/ufw/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
		for i in $path
		do
			echo "$i" >> "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
			echo "" >> "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
			cat "$rutadatos"/logs-servicios/ufw/"$i" >> "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
			echo "" >> "$rutadatos"/logs-servicios/ufw/logfile_ufw.txt
		done
	fi

	gunzip "$rutadatos"/logs-servicios/samba/log.smbd* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/samba/log.smbd*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
		for i in $path
		do
			echo "${i//"$rutadatos/logs-servicios/samba/"/}" >> "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
			echo "" >> "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
			cat "$i" >> "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
			echo "" >> "$rutadatos"/logs-servicios/samba/logfile_log.smbd.txt
		done
	fi

	gunzip "$rutadatos"/logs-servicios/samba/log.nmbd* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/samba/log.nmbd*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
		for i in $path
		do
			echo "${i//"$rutadatos/logs-servicios/samba/"/}" >> "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
			echo "" >> "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
			cat "$i" >> "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
			echo "" >> "$rutadatos"/logs-servicios/samba/logfile_log.nmbd.txt
		done
	fi
	
	gunzip "$rutadatos"/logs-servicios/httpd/error.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/httpd/error.log*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/httpd/logfile_error.log.txt
		for i in $path
		do
			echo "${i//"$rutadatos/logs-servicios/httpd/"/}" >> "$rutadatos"/logs-servicios/httpd/logfile_error.log.txt
			echo "" >> "$rutadatos"/logs-servicios/httpd/logfile_error.log.txt
			cat "$i" >> "$rutadatos"/logs-servicios/httpd/logfile_error.log.txt
			echo "" >> "$rutadatos"/logs-servicios/httpd/logfile_error.log.txt
		done
	fi

	gunzip "$rutadatos"/logs-servicios/httpd/access.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-servicios/httpd/access.log*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-servicios/httpd/logfile_access.log.txt
		for i in $path
		do
			echo "${i//"$rutadatos/logs-servicios/httpd/"/}" >> "$rutadatos"/logs-servicios/httpd/logfile_access.log.txt
			echo "" >> "$rutadatos"/logs-servicios/httpd/logfile_access.log.txt
			cat "$i" >> "$rutadatos"/logs-servicios/httpd/logfile_access.log.txt
			echo "" >> "$rutadatos"/logs-servicios/httpd/logfile_access.log.txt
		done
	fi

	echo "${white}[${green}!${white}]${lightblue} Listo..."
	echo "${white}"

	# Volcado de RAM
	if [[ $ram == "S" ]] || [[ $ram == "s" ]]
	then
		if [[ ! -d LiME/src ]]
		then
			echo "${white}[${green}!${white}]${lightblue} Realizando volcado de la memoria RAM..."
			echo "${white}"
			echo "Realizando volcado de la memoria RAM" >> log.txt
			cd LiME/src/ || return
			insmod lime-"$(uname -r)".ko "path=$rutadatos/volcado_memoria format=raw"
			rmmod lime
			cd ..
			cd ..
			echo "${white}[${green}!${white}]${lightblue} Listo..."
			echo "${white}"
		else
			echo "No se detectó LiME para hacer el volcado de la memoria RAM"
			echo "No se detectó LiME para hacer el volcado de la memoria RAM" >> log.txt
		fi
	fi
	echo "" >> log.txt
}
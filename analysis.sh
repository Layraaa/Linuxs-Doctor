# analysis.sh
# Get system data and create analysis.txt

function analisis (){
	# Create main directory and analysis.txt
	date=$(date +"%Y.%m.%d-%H.%M.%S")
	rutadatos="$rutareporte/evidences-$date"
	mkdir "$rutadatos" >> log.txt 2>&1
	touch "$rutadatos"/analysis.txt >> log.txt 2>&1
	if [ ! -f "$rutadatos"/analysis.txt ]
	then
		echo "It couldn't create analysis.txt, check the log"
		echo "It couldn't get system data because analysis.txt couldn't be created" >> log.txt
		exit
	fi
	{
		echo "*DON'T MODIFY THIS FILE, IT'S POSSIBLE THAT YOU COULD HAVE PROBLEMSIF YOU COMPARE THIS REPORT WITH OTHER REPORT*"
		echo "*YOU CAN DO IT ONLY IF YOU KNOW WHAT ARE YOU DOING*"
		echo ""
		echo "OS: $(< /etc/os-release grep '^NAME=' | awk '{print $1}' FS=' ' | awk '{print $2}' FS='"')"
		echo "Kernel's version: $(uname -r)"
		echo "IP address: $(hostname -I)"
		echo ""
		echo "Tool version: 1.1.2"
		echo "Analysis made: $linuxsdoctor"
		date +"Start time: %T"
		echo "End time: -"
	} > "$rutadatos"/analysis.txt
	
}

function finanalisis (){
	# Delete the last file of analysis.txt and write the end time of the analisys
	tail -n 1 "$rutadatos/analysis.txt" | wc -c | xargs -I {} truncate "$rutadatos/analysis.txt" -s -{}
	date +"End time: %T" >> "$rutadatos"/analysis.txt
}

function recogidadatosDebian (){
	# Get system data
	mkdir "$rutadatos"/system-files >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Getting system data..."
	{
        echo "sha256sum" && sha256sum /boot/vmlinuz-"$(uname -r)" && echo ""
        echo "sha512sum" && sha512sum /boot/vmlinuz-"$(uname -r)" && echo ""
        echo "md5sum" && md5sum /boot/vmlinuz-"$(uname -r)"
    } > "$rutadatos"/system-files/kernelsign.txt
	cat /etc/sudoers > "$rutadatos"/system-files/sudoers.txt
	{
        echo "sha256sum" && sha256sum /etc/sudoers && echo ""
        echo "sha512sum" && sha512sum /etc/sudoers && echo ""
        echo "md5sum" && md5sum /etc/sudoers
    } > "$rutadatos"/system-files/sudoerssign.txt
	cat /etc/shadow > "$rutadatos"/system-files/shadow.txt
	{
        echo "sha256sum" && sha256sum /etc/shadow && echo ""
        echo "sha512sum" && sha512sum /etc/shadow && echo ""
        echo "md5sum" && md5sum /etc/shadow
    } > "$rutadatos"/system-files/shadowsign.txt
	cat /etc/passwd > "$rutadatos"/system-files/passwd.txt
	{
        echo "sha256sum" && sha256sum /etc/passwd && echo ""
        echo "sha512sum" && sha512sum /etc/passwd && echo ""
        echo "md5sum" && md5sum /etc/passwd
    } > "$rutadatos"/system-files/passwdsign.txt
	cat /root/.bash_history > "$rutadatos"/system-files/root_bash_history.txt
	uname -a >> "$rutadatos"/archivos-dinamicos/unamea.txt
	uname -r >> "$rutadatos"/archivos-dinamicos/unamer.txt
	dpkg-query -f '${binary:Package}\n' -W > "$rutadatos"/system-files/dpkg.txt
	cat /etc/crontab > "$rutadatos"/system-files/crontab.txt
	crontab -l > "$rutadatos"/system-files/crontabl.txt 2>&1
	cat /etc/default/grub > "$rutadatos"/system-files/grub.txt
	cat /etc/network/interfaces > "$rutadatos"/system-files/interfaces.txt
	cat /etc/profile > "$rutadatos"/system-files/profile.txt
	cat /etc/hosts > "$rutadatos"/system-files/hosts.txt
	cat /etc/fstab > "$rutadatos"/system-files/fstab.txt
	cat /etc/mtab > "$rutadatos"/system-files/mtab.txt
	cat /etc/group > "$rutadatos"/system-files/group.txt
	mkdir "$rutadatos"/system-files/rc.d
	cp -r /etc/rc*.d/ "$rutadatos"/system-files/rc.d/ >> log.txt 2>&1
	for i in $(ls "$rutadatos"/system-files/rc.d/)
	do
		path="$(ls "$rutadatos"/system-files/rc.d/"$i")"
		rm -rf "$rutadatos"/system-files/rc.d/"$i"/*
		for x in $path
		do
			cat /etc/"$i"/"$x" >> "$rutadatos"/system-files/rc.d/"$i"/"$x"
		done
	done
	{
		cp -r /etc/init.d/ "$rutadatos"/system-files/
		cp -r /etc/cron.d/ "$rutadatos"/system-files/
		cp -r /etc/cron.hourly/ "$rutadatos"/system-files/
		cp -r /etc/cron.dialy/ "$rutadatos"/system-files/
		cp -r /etc/cron.weekely/ "$rutadatos"/system-files/
		cp -r /etc/cron.monthly/ "$rutadatos"/system-files/
	} >> log.txt 2>&1
	cat /proc/cmdline > "$rutadatos"/system-files/cmdline.txt
	blkid > "$rutadatos"/system-files/blkid.txt
	lastlog > "$rutadatos"/system-files/lastlog.txt
	runlevel > "$rutadatos"/system-files/runlevel.txt
	lspci -vvv > "$rutadatos"/system-files/lspci.txt
	fdisk -l > "$rutadatos"/system-files/fdisk.txt
	printenv > "$rutadatos"/system-files/printenv.txt
	cat /etc/selinux/config > "$rutadatos"/system-files/selinuxconfig.txt
	cat /etc/selinux/semanage.conf > "$rutadatos"/system-files/selinuxsemanage.txt
	cat /etc/sestatus.conf > "$rutadatos"/system-files/selinuxstatus.txt
	cat /etc/hosts.allow > "$rutadatos"/system-files/hosts_allow.txt
	cat /etc/hosts.deny > "$rutadatos"/system-files/hosts_deny.txt
	cat /etc/rsyslog.conf > "$rutadatos"/system-files/rsyslog.txt
	cat /proc/devices > "$rutadatos"/system-files/devices.txt
	cat /etc/machine-id > "$rutadatos"/system-files/machine_id.txt
	cat /sys/class/dmi/id/product_uuid > "$rutadatos"/system-files/product_uuid.txt
	cat /etc/resolv.conf > "$rutadatos"/system-files/resolv.txt
	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo ""

	# Getting information of network configuration
	mkdir "$rutadatos"/network >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Getting information of network configuration..."
	nmcli dev show | sed '/^IP[4-6].ROUTE/d' > "$rutadatos"/network/nmcli.txt
	netstat -ltun | awk '{$2=$3=""; print $0}' | awk '($1=$1) || 1' OFS=\\t | tail -n +2 | sort > "$rutadatos"/network/netstat.txt
	dig +short | sort > "$rutadatos"/network/dig.txt
	route > "$rutadatos"/network/route.txt
	arp -v -e > "$rutadatos"/network/arp.txt
	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo ""

	# Get information of system's services
	mkdir "$rutadatos"/services >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Getting information of system's services..."

	{
		systemctl show -p ActiveState iptables | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		iptables -L
	}  >> "$rutadatos"/services/iptables.txt

	{
		firewall-cmd --list-all
		echo "" 
		echo "-----" 
		echo "" 
		cat /etc/firewalld/firewalld.conf 
	} >> "$rutadatos"/services/firewalld.txt

	{
		ufw status verbose
		echo ""
		echo "-----"
		echo ""
		cat /etc/default/ufw
	} >> "$rutadatos"/services/ufw.txt

	{
		systemctl show -p ActiveState isc-dchp-server | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/dhcp/dhcpd.conf"
		echo ""
		cat /etc/dhcp/dhcpd.conf
		echo ""
		echo "/etc/dhcp/dhcpd6.conf"
		echo ""
		cat /etc/dhcp/dhcpd6.conf
	}  >> "$rutadatos"/services/dhcp.txt

	{
		systemctl show -p ActiveState named | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/bind/named.conf"
		echo ""
		cat /etc/bind/named.conf
		echo ""
		echo "/etc/bind/named.conf.options"
		echo ""
		cat /etc/bind/named.conf.options
		echo ""
		echo "/etc/bind/named.conf.local"
		echo ""
		cat /etc/bind/named.conf.local
		echo ""
		echo "/etc/bind/named.conf.default-zones"
		echo ""
		cat /etc/bind/named.conf.default-zones
	}  >> "$rutadatos"/services/dns.txt

	{
		systemctl show -p ActiveState vsftpd | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/vsftpd.conf"
		echo ""
		cat /etc/vsftpd.conf
		echo ""
		echo "/etc/ftpusers"
		echo ""
		cat /etc/ftpusers
	} >> "$rutadatos"/services/vsftpd.txt

	{
		systemctl show -p ActiveState smbd | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		cat /etc/samba/smb.conf
	}  >> "$rutadatos"/services/samba.txt

	{
		systemctl show -p ActiveState apache2 | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/apache2/apache2.conf"
		echo ""
		cat /etc/apache2/apache2.conf
		echo ""
		echo "/etc/apache2/ports.conf"
		echo ""
		cat /etc/apache2/ports.conf
		echo ""
		echo "/etc/apache2/sites-available"
		echo ""
		echo ""
	} >> "$rutadatos"/services/apache.txt
	for i in $(ls /etc/apache2/sites-available/)
	do
		{
			echo "/etc/apache2/sites-available/$i"
			echo ""
			cat "/etc/apache2/sites-available/$i"
			echo ""
		} >> "$rutadatos"/services/apache.txt
	done

	{
		systemctl show -p ActiveState mariadb | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/mysql/my.cnf"
		echo ""
		cat /etc/mysql/my.cnf
		echo ""
		echo "/etc/mysql/conf.d"
		echo ""
		echo ""
	} >> "$rutadatos"/services/mariadb.txt
	for i in $(ls /etc/mysql/conf.d/)
	do
		{
			echo "/etc/mysql/conf.d/$i"
			echo ""
			cat "/etc/mysql/conf.d/$i"
			echo ""
		} >> "$rutadatos"/services/mariadb.txt
	done
	{
		echo ""
		echo "/etc/mysql/mariadb.conf.d"
		echo ""
		echo ""
	} >> "$rutadatos"/services/mariadb.txt
	for i in $(ls /etc/mysql/mariadb.conf.d/)
	do
		{
			echo "/etc/mysql/mariadb.conf.d/$i"
			echo ""
			cat "/etc/mysql/mariadb.conf.d/$i"
			echo ""
		} >> "$rutadatos"/services/mariadb.txt
	done

	{
		systemctl show -p ActiveState squid | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/squid/squid.conf"
		echo ""
		cat /etc/squid/squid.conf
		echo ""
		echo "/etc/squid/conf.d"
		echo ""
		echo ""
	} >> "$rutadatos"/services/squid.txt
	for i in $(ls /etc/squid/conf.d/)
	do
		{
			echo "/etc/squid/conf.d/$i"
			echo ""
			cat "/etc/squid/conf.d/$i"
			echo ""
		} >> "$rutadatos"/services/squid.txt
	done

	{
		systemctl show -p ActiveState sshd | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		cat /etc/ssh/sshd_config
	} >> "$rutadatos"/services/ssh.txt

	for i in $(ls /etc/php/)
	do
		{
			echo "/etc/php/$i/apache2/php.ini"
			echo ""
			cat "/etc/php/$i/apache2/php.ini"
			echo ""
		} >> "$rutadatos"/services/php.txt
	done

	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo ""

	# Get system's logs
	echo "${white}[${red}*${white}]${lightblue} Getting system's logs..."
	{
		mkdir  "$rutadatos"/system-logs
		mkdir  "$rutadatos"/system-logs/auth
		mkdir  "$rutadatos"/system-logs/dpkg
		mkdir  "$rutadatos"/system-logs/syslog
		mkdir  "$rutadatos"/system-logs/boot
		mkdir  "$rutadatos"/system-logs/kern
		mkdir  "$rutadatos"/system-logs/lastlog
		cp /var/log/auth.log*  "$rutadatos"/system-logs/auth/
		cp /var/log/dpkg.log*  "$rutadatos"/system-logs/dpkg/
		cp /var/log/syslog*  "$rutadatos"/system-logs/syslog/
		cp /var/log/boot.log*  "$rutadatos"/system-logs/boot/
		cp /var/log/kern.log*  "$rutadatos"/system-logs/kern/
		cp /var/log/lastlog* "$rutadatos"/system-logs/lastlog/
	} >> log.txt 2>&1

	# Descompress all system's logs and copy their content in a file
	gunzip "$rutadatos"/system-logs/auth/auth.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/auth/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/auth/logfile_auth_log.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/system-logs/auth/"$i"
				echo ""
			} >> "$rutadatos"/system-logs/auth/logfile_auth_log.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/dpkg/dpkg.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/dpkg/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/dpkg/logfile_dpkg_log.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/system-logs/dpkg/"$i"
				echo ""
			} >> "$rutadatos"/system-logs/dpkg/logfile_dpkg_log.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/syslog/syslog* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/syslog/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/syslog/logfile_syslog.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/system-logs/syslog/"$i"
				echo ""
			} >> "$rutadatos"/system-logs/syslog/logfile_syslog.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/boot/boot.log* >> log.txt 2>&1	
	path=$(ls "$rutadatos"/system-logs/boot/)
	if [[ -n $path ]] 2>> log.txt
	then	
		touch "$rutadatos"/system-logs/boot/logfile_boot_log.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/system-logs/boot/"$i"
				echo ""
			} >> "$rutadatos"/system-logs/boot/logfile_boot_log.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/kern/kern.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/kern/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/kern/logfile_kern_log.txt
		for i in $path
		do
			{
				echo "$i"t
				echo ""t
				cat "$rutadatos"/system-logs/kern/"$i"
				echo ""t
			} >> "$rutadatos"/system-logs/kern/logfile_kern_log.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/lastlog/lastlog* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/lastlog/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/lastlog/logfile_lastlog.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/system-logs/lastlog/"$i"
				echo ""
			} >> "$rutadatos"/system-logs/lastlog/logfile_lastlog.txt
		done
	fi

	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo ""

	# Get service's logs
	echo "${white}[${red}*${white}]${lightblue} Getting service's logs..."
	mkdir  "$rutadatos"/logs-services >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-services/ufw >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-services/samba >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-services/apache2 >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-services/squid >> log.txt 2>&1
	cp /var/log/ufw* "$rutadatos"/logs-services/ufw/ >> log.txt 2>&1
	cp /var/log/samba/log.smbd* "$rutadatos"/logs-services/samba/ >> log.txt 2>&1
	cp /var/log/samba/log.nmbd* "$rutadatos"/logs-services/samba/ >> log.txt 2>&1
	cp /var/log/apache2/error.log* "$rutadatos"/logs-services/apache2/ >> log.txt 2>&1
	cp /var/log/apache2/access.log* "$rutadatos"/logs-services/apache2/ >> log.txt 2>&1

	{
		cat /var/log/firewalld > "$rutadatos"/logs-services/firewalld.txt
		cat /var/log/vsftpd.log > "$rutadatos"/logs-services/vsftpd.txt
		cat /var/log/mariadb.log > "$rutadatos"/logs-services/mariadb.txt
		cat /var/log/squid/access.log > "$rutadatos"/logs-services/squid/access.txt
		cat /var/log/squid/cache.log > "$rutadatos"/logs-services/squid/cache.txt
	} 2>> log.txt

	# Descompress logs and copy the content in a file

	gunzip "$rutadatos"/logs-services/ufw/ufw* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/ufw/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/ufw/logfile_ufw.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/logs-services/ufw/"$i"
				echo ""
			} >> "$rutadatos"/logs-services/ufw/logfile_ufw.txt
		done
	fi

	gunzip "$rutadatos"/logs-services/samba/log.smbd* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/samba/log.smbd*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/samba/logfile_log.smbd.txt
		for i in $path
		do
			{
				echo "${i//"$rutadatos/logs-services/samba/"/}"
				echo ""
				cat "$i"
				echo ""
			} >> "$rutadatos"/logs-services/samba/logfile_log.smbd.txt
		done
	fi

	gunzip "$rutadatos"/logs-services/samba/log.nmbd* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/samba/log.nmbd*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/samba/logfile_log.nmbd.txt
		for i in $path
		do
			{
				echo "${i//"$rutadatos/logs-services/samba/"/}"
				echo ""
				cat "$i"
				echo ""
			} >> "$rutadatos"/logs-services/samba/logfile_log.nmbd.txt
		done
	fi
	
	gunzip "$rutadatos"/logs-services/apache2/error.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/apache2/error.log*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/apache2/logfile_error.log.txt
		for i in $path
		do
			{
				echo "${i//"$rutadatos/logs-services/apache2/"/}"
				echo ""
				cat "$i"
				echo ""
			} >> "$rutadatos"/logs-services/apache2/logfile_error.log.txt
		done
	fi

	gunzip "$rutadatos"/logs-services/apache2/access.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/apache2/access.log*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/apache2/logfile_access.log.txt
		for i in $path
		do
			{
				echo "${i//"$rutadatos/logs-services/apache2/"/}"
				echo ""
				cat "$i"
				echo ""
			} >> "$rutadatos"/logs-services/apache2/logfile_access.log.txt
		done
	fi

	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo "${white}"

	# Get dynamic data
	echo "${white}[${red}*${white}]${lightblue} Getting dynamic data..."

	{
		mkdir "$rutadatos"/archivos-dinamicos

		ls -lrtaRh /etc >> "$rutadatos"/archivos-dinamicos/lsetc.txt
		ls -lrtaRh /dev >> "$rutadatos"/archivos-dinamicos/lsdev.txt
		ls -lrtaRh /bin >> "$rutadatos"/archivos-dinamicos/lsbin.txt
		ls -lrtaRh /sbin >> "$rutadatos"/archivos-dinamicos/lssbin.txt
		ls -lrtaRh /usr/bin >> "$rutadatos"/archivos-dinamicos/lsusrbin.txt
		ls -lrtaRh /usr/sbin >> "$rutadatos"/archivos-dinamicos/lsusrsbin.txt
		netstat -tupan >> "$rutadatos"/archivos-dinamicos/netstat.txt
		last >> "$rutadatos"/archivos-dinamicos/last.txt
		w >> "$rutadatos"/archivos-dinamicos/w.txt
		dmesg >> "$rutadatos"/archivos-dinamicos/dmesg.txt
		lsmod >> "$rutadatos"/archivos-dinamicos/lsmod.txt
		ps axufwww >> "$rutadatos"/archivos-dinamicos/ps.txt
		date >> "$rutadatos"/archivos-dinamicos/date.txt
		dpkg -l >> "$rutadatos"/archivos-dinamicos/dpkg.txt 
		free -m >> "$rutadatos"/archivos-dinamicos/free.txt
		lsof >> "$rutadatos"/archivos-dinamicos/lsof.txt
		lsof -i >> "$rutadatos"/archivos-dinamicos/lsofi.txt

		cat /var/log/btmp >> "$rutadatos"/archivos-dinamicos/btmp.txt
		cat /var/log/wtmp >> "$rutadatos"/archivos-dinamicos/wtmp.txt
		cat /etc/os-release >> "$rutadatos"/archivos-dinamicos/os-release.txt
		cat /proc/version >> "$rutadatos"/archivos-dinamicos/version.txt
		cat /proc/cpuinfo >> "$rutadatos"/archivos-dinamicos/cpuinfo.txt
		cat /proc/swaps >> "$rutadatos"/archivos-dinamicos/swaps.txt
		cat /proc/partitions >> "$rutadatos"/archivos-dinamicos/partitions.txt
		cat /proc/self/mounts >> "$rutadatos"/archivos-dinamicos/mounts.txt
		cat /proc/meminfo >> "$rutadatos"/archivos-dinamicos/meminfo.txt
		cat /proc/uptime >> "$rutadatos"/archivos-dinamicos/uptime.txt
		cat /proc/modules >> "$rutadatos"/archivos-dinamicos/modules.txt
		cat /proc/vmstat >> "$rutadatos"/archivos-dinamicos/vmstat.txt

		ls -lah /proc/[0-9]* >> "$rutadatos"/archivos-dinamicos/dataprocess.txt
		ls -lah /proc/[0-9]*/exe >> "$rutadatos"/archivos-dinamicos/exe.txt
		ls -lah /etc/init.d/ >> "$rutadatos"/archivos-dinamicos/initd.txt
	} 2>> log.txt

	mkdir "$rutadatos"/archivos-dinamicos/proc 2>> log.txt

	for i in /proc/[0-9]*
	do
		{
			mkdir "$rutadatos"/archivos-dinamicos/proc/"$i"
			cat "$i"/cgroup >> "$rutadatos"/archivos-dinamicos/proc/"$i"/cgroup.txt
			cat "$i"/cmdline >> "$rutadatos"/archivos-dinamicos/proc/"$i"/cmdline.txt
			cat "$i"/comm >> "$rutadatos"/archivos-dinamicos/proc/"$i"/comm.txt
			cat "$i"/environ >> "$rutadatos"/archivos-dinamicos/proc/"$i"/environ.txt
			cat "$i"/io >> "$rutadatos"/archivos-dinamicos/proc/"$i"/io.txt
			cat "$i"/limits >> "$rutadatos"/archivos-dinamicos/proc/"$i"/limits.txt
			cat "$i"/maps >> "$rutadatos"/archivos-dinamicos/proc/"$i"/maps.txt
			cat "$i"/mountinfo >> "$rutadatos"/archivos-dinamicos/proc/"$i"/mountinfo.txt
			cat "$i"/numa_maps >> "$rutadatos"/archivos-dinamicos/proc/"$i"/numa_maps.txt
			cat "$i"/sched >> "$rutadatos"/archivos-dinamicos/proc/"$i"/sched.txt
			cat "$i"/status >> "$rutadatos"/archivos-dinamicos/proc/"$i"/status.txt
		} 2>> log.txt
	done

	last reboot >> "$rutadatos"/archivos-dinamicos/lastreboot.txt

	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo "${white}"

	# Dump RAM
	if [[ $ram == "Y" ]] || [[ $ram == "y" ]]
	then
		if [[ -d LiME/src ]]
		then
			echo "${white}[${green}!${white}]${lightblue} Dumping RAM..."
			echo "${white}"
			echo "Dumping RAM" >> log.txt
			cd LiME/src/ || return
			insmod lime-"$(uname -r)".ko "path=$rutadatos/volcado_memoria format=raw"
			rmmod lime
			cd ..
			cd ..
			echo "${white}[${green}!${white}]${lightblue} Done!"
			echo "${white}"
		else
			echo "It couldn't detect LiME"
			echo "It couldn't detect LiME" >> log.txt
		fi
	fi
	echo "" >> log.txt
}

function recogidadatosCentOS (){
	# Get system data
	mkdir "$rutadatos"/system-files >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Getting system data..."
	{
        echo "sha256sum" && sha256sum /boot/vmlinuz-"$(uname -r)" && echo ""
        echo "sha512sum" && sha512sum /boot/vmlinuz-"$(uname -r)" && echo ""
        echo "md5sum" && md5sum /boot/vmlinuz-"$(uname -r)"
    } > "$rutadatos"/system-files/kernelsign.txt
	cat /etc/sudoers > "$rutadatos"/system-files/sudoers.txt
	{
        echo "sha256sum" && sha256sum /etc/sudoers && echo ""
        echo "sha512sum" && sha512sum /etc/sudoers && echo ""
        echo "md5sum" && md5sum /etc/sudoers
    } > "$rutadatos"/system-files/sudoerssign.txt
	cat /etc/shadow > "$rutadatos"/system-files/shadow.txt
	{
        echo "sha256sum" && sha256sum /etc/shadow && echo ""
        echo "sha512sum" && sha512sum /etc/shadow && echo ""
        echo "md5sum" && md5sum /etc/shadow
    } > "$rutadatos"/system-files/shadowsign.txt
	cat /etc/passwd > "$rutadatos"/system-files/passwd.txt
	{
        echo "sha256sum" && sha256sum /etc/passwd && echo ""
        echo "sha512sum" && sha512sum /etc/passwd && echo ""
        echo "md5sum" && md5sum /etc/passwd
    } > "$rutadatos"/system-files/passwdsign.txt
	cat /root/.bash_history > "$rutadatos"/system-files/root_bash_history.txt
	uname -a >> "$rutadatos"/archivos-dinamicos/unamea.txt
	uname -r >> "$rutadatos"/archivos-dinamicos/unamer.txt
	rpm -qa > "$rutadatos"/system-files/dpkg.txt
	cat /etc/crontab > "$rutadatos"/system-files/crontab.txt
	crontab -l > "$rutadatos"/system-files/crontabl.txt 2>&1
	cat /etc/default/grub > "$rutadatos"/system-files/grub.txt
	for i in $(ls /etc/sysconfig/network-scripts/ifcfg-*)
	do
		{
			echo "$i"
			echo ""
			cat "$i"
			echo ""
		} >> "$rutadatos"/system-files/interfaces.txt
	done
	cat /etc/profile > "$rutadatos"/system-files/profile.txt
	cat /etc/hosts > "$rutadatos"/system-files/hosts.txt
	cat /etc/fstab > "$rutadatos"/system-files/fstab.txt
	cat /etc/mtab > "$rutadatos"/system-files/mtab.txt
	cat /etc/group > "$rutadatos"/system-files/group.txt
	mkdir "$rutadatos"/system-files/rc.d
	cp -r /etc/rc.d/rc*.d/ "$rutadatos"/system-files/rc.d/ >> log.txt 2>&1
	for i in $(ls "$rutadatos"/system-files/rc.d/)
	do
		path="$(ls "$rutadatos"/system-files/rc.d/"$i")"
		rm -rf "$rutadatos"/system-files/rc.d/"$i"/*
		for x in $path
		do
			cat /etc/"$i"/"$x" >> "$rutadatos"/system-files/rc.d/"$i"/"$x"
		done
	done
	{
		cp -r /etc/init.d/ "$rutadatos"/system-files/
		cp -r /etc/cron.d/ "$rutadatos"/system-files/
		cp -r /etc/cron.hourly/ "$rutadatos"/system-files/
		cp -r /etc/cron.dialy/ "$rutadatos"/system-files/
		cp -r /etc/cron.weekely/ "$rutadatos"/system-files/
		cp -r /etc/cron.monthly/ "$rutadatos"/system-files/
	} >> log.txt 2>&1

	cat /proc/cmdline > "$rutadatos"/system-files/cmdline.txt
	blkid > "$rutadatos"/system-files/blkid.txt
	lastlog > "$rutadatos"/system-files/lastlog.txt
	runlevel > "$rutadatos"/system-files/runlevel.txt
	lspci -vvv > "$rutadatos"/system-files/lspci.txt
	fdisk -l > "$rutadatos"/system-files/fdisk.txt
	printenv > "$rutadatos"/system-files/printenv.txt
	cat /etc/selinux/config > "$rutadatos"/system-files/selinuxconfig.txt
	cat /etc/selinux/semanage.conf > "$rutadatos"/system-files/selinuxsemanage.txt
	cat /etc/sestatus.conf > "$rutadatos"/system-files/selinuxstatus.txt
	cat /etc/hosts.allow > "$rutadatos"/system-files/hosts_allow.txt
	cat /etc/hosts.deny > "$rutadatos"/system-files/hosts_deny.txt
	cat /etc/rsyslog.conf > "$rutadatos"/system-files/rsyslog.txt
	cat /proc/devices > "$rutadatos"/system-files/devices.txt
	cat /etc/machine-id > "$rutadatos"/system-files/machine_id.txt
	cat /sys/class/dmi/id/product_uuid > "$rutadatos"/system-files/product_uuid.txt
	cat /etc/resolv.conf > "$rutadatos"/system-files/resolv.txt
	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo ""

	# Getting information of network configuration
	mkdir "$rutadatos"/network >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Getting information of network configuration..."
	nmcli dev show | sed '/^IP[4-6].ROUTE/d' > "$rutadatos"/network/nmcli.txt
	netstat -ltun | awk '{$2=$3=""; print $0}' | awk '($1=$1) || 1' OFS=\\t | tail -n +2 | sort > "$rutadatos"/network/netstat.txt
	dig +short | sort > "$rutadatos"/network/dig.txt
	route > "$rutadatos"/network/route.txt
	arp -v -e > "$rutadatos"/network/arp.txt
	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo ""

	# Get information of system's services
	mkdir "$rutadatos"/services >> log.txt 2>&1
	echo "${white}[${red}*${white}]${lightblue} Getting information of system's services..."

	{
		systemctl show -p ActiveState iptables | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		iptables -L
	}  >> "$rutadatos"/services/iptables.txt

	{
		firewall-cmd --list-all
		echo "" 
		echo "-----" 
		echo "" 
		cat /etc/firewalld/firewalld.conf 
	} >> "$rutadatos"/services/firewalld.txt

	{
		ufw status verbose
		echo ""
		echo "-----"
		echo ""
		cat /etc/default/ufw
	} >> "$rutadatos"/services/ufw.txt

	{
		systemctl show -p ActiveState dhcpd | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/dhcp/dhcpd.conf"
		echo ""
		cat /etc/dhcp/dhcpd.conf
		echo ""
		echo "/etc/dhcp/dhcpd6.conf"
		echo ""
		cat /etc/dhcp/dhcpd6.conf
	} >> "$rutadatos"/services/dhcp.txt

	{
		systemctl show -p ActiveState named | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/named.conf"
		echo ""
		cat /etc/named.conf
		echo ""
		echo "/etc/named.rfc1912.zones"
		echo ""
		cat /etc/named.rfc1912.zones
		echo ""
		echo "/etc/named.root.key"
		echo ""
		cat /etc/named.root.key
		echo ""
		echo "/etc/named.iscdlv.key"
		echo ""
		cat /etc/named.iscdlv.key
	} >> "$rutadatos"/services/dns.txt

	{
		systemctl show -p ActiveState vsftpd | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/vsftpd/vsftpd.conf"
		echo ""
		cat /etc/vsftpd/vsftpd.conf
		echo ""
		echo "/etc/vsftpd/ftpusers"
		echo ""
		cat /etc/vsftpd/ftpusers
	} >> "$rutadatos"/services/vsftpd.txt

	{
		systemctl show -p ActiveState smb | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		cat /etc/samba/smb.conf
	} >> "$rutadatos"/services/samba.txt

	{
		systemctl show -p ActiveState httpd | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		cat /etc/httpd/conf/httpd.conf
	} >> "$rutadatos"/services/apache.txt

	{
		systemctl show -p ActiveState mariadb | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		echo "/etc/my.cnf"
		echo ""
		cat /etc/my.cnf
		echo ""
		echo "/etc/my.cnf.d/"
		echo ""
		echo ""
	} >> "$rutadatos"/services/mariadb.txt
	for i in $(ls /etc/my.cnf.d/)
	do
		{
			echo "/etc/my.cnf.d/$i"
			echo ""
			cat "/etc/my.cnf.d/$i"
			echo ""
		} >> "$rutadatos"/services/mariadb.txt
	done
	
	{
		systemctl show -p ActiveState squid | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		cat /etc/squid/squid.conf
	} >> "$rutadatos"/services/squid.txt
	
	{
		systemctl show -p ActiveState sshd | sed 's/ActiveState=//g'
		echo ""
		echo "-----"
		echo ""
		cat /etc/ssh/sshd_config
	} >> "$rutadatos"/services/ssh.txt

	cat /etc/php.ini >> "$rutadatos"/services/php.txt

	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo ""

	# Get system's logs
	echo "${white}[${red}*${white}]${lightblue} Getting system's logs..."
	{
		mkdir  "$rutadatos"/system-logs
		mkdir  "$rutadatos"/system-logs/auth
		mkdir  "$rutadatos"/system-logs/dpkg
		mkdir  "$rutadatos"/system-logs/messages
		mkdir  "$rutadatos"/system-logs/boot
		mkdir  "$rutadatos"/system-logs/kern
		mkdir  "$rutadatos"/system-logs/lastlog
		cp /var/log/auth.log*  "$rutadatos"/system-logs/auth/
		cp /var/log/dpkg.log*  "$rutadatos"/system-logs/dpkg/
		cp /var/log/messages*  "$rutadatos"/system-logs/messages/
		cp /var/log/boot.log*  "$rutadatos"/system-logs/boot/
		cp /var/log/kern.log*  "$rutadatos"/system-logs/kern/
		cp /var/log/lastlog* "$rutadatos"/system-logs/lastlog/
	} >> log.txt 2>&1

	# Descompress all system's logs and copy their content in a file
	gunzip "$rutadatos"/system-logs/auth/auth.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/auth/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/auth/logfile_auth_log.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/system-logs/auth/"$i"
				echo ""
			} >> "$rutadatos"/system-logs/auth/logfile_auth_log.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/dpkg/dpkg.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/dpkg/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/dpkg/logfile_dpkg_log.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/system-logs/dpkg/"$i"
				echo ""
			} >> "$rutadatos"/system-logs/dpkg/logfile_dpkg_log.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/messages/messages* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/messages/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/messages/logfile_messages.txt
		for i in $path
		do
			{
				echo "$i" 
				echo "" 
				cat "$rutadatos"/system-logs/messages/"$i" 
				echo "" 
			} >> "$rutadatos"/system-logs/messages/logfile_messages.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/boot/boot.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/boot/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/boot/logfile_boot_log.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/system-logs/boot/"$i"
				echo ""
			} >> "$rutadatos"/system-logs/boot/logfile_boot_log.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/kern/kern.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/kern/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/kern/logfile_kern_log.txt
		for i in $path
		do
			{
				echo "$i"t
				echo ""t
				cat "$rutadatos"/system-logs/kern/"$i"
				echo ""t
			} >> "$rutadatos"/system-logs/kern/logfile_kern_log.txt
		done
	fi

	gunzip "$rutadatos"/system-logs/lastlog/lastlog* >> log.txt 2>&1
	path=$(ls "$rutadatos"/system-logs/lastlog/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/system-logs/lastlog/logfile_lastlog.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/system-logs/lastlog/"$i"
				echo ""
			} >> "$rutadatos"/system-logs/lastlog/logfile_lastlog.txt
		done
	fi

	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo ""

	# Get service's logs
	echo "${white}[${red}*${white}]${lightblue} Getting service's logs..."
	mkdir  "$rutadatos"/logs-services >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-services/ufw >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-services/samba >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-services/httpd >> log.txt 2>&1
	mkdir  "$rutadatos"/logs-services/squid >> log.txt 2>&1
	cp /var/log/ufw* "$rutadatos"/logs-services/ufw/ >> log.txt 2>&1
	cp /var/log/samba/log.smbd* "$rutadatos"/logs-services/samba/ >> log.txt 2>&1
	cp /var/log/samba/log.nmbd* "$rutadatos"/logs-services/samba/ >> log.txt 2>&1
	cp /var/log/httpd/error_log* "$rutadatos"/logs-services/httpd/ >> log.txt 2>&1
	cp /var/log/httpd/access_log* "$rutadatos"/logs-services/httpd/ >> log.txt 2>&1

	{
		cat /var/log/firewalld > "$rutadatos"/logs-services/firewalld.txt
		cat /var/log/vsftpd.log > "$rutadatos"/logs-services/vsftpd.txt
		cat /var/log/mariadb/mariadb.log > "$rutadatos"/logs-services/mariadb.txt
		cat /var/log/squid/access.log > "$rutadatos"/logs-services/squid/access.txt
		cat /var/log/squid/cache.log > "$rutadatos"/logs-services/squid/cache.txt
	} 2>> log.txt

	# Descompress logs and copy the content in a file
	gunzip "$rutadatos"/logs-services/ufw/ufw* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/ufw/)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/ufw/logfile_ufw.txt
		for i in $path
		do
			{
				echo "$i"
				echo ""
				cat "$rutadatos"/logs-services/ufw/"$i"
				echo ""
			} >> "$rutadatos"/logs-services/ufw/logfile_ufw.txt
		done
	fi

	gunzip "$rutadatos"/logs-services/samba/log.smbd* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/samba/log.smbd*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/samba/logfile_log.smbd.txt
		for i in $path
		do
			{
				echo "${i//"$rutadatos/logs-services/samba/"/}"
				echo ""
				cat "$i"
				echo ""
			} >> "$rutadatos"/logs-services/samba/logfile_log.smbd.txt
		done
	fi

	gunzip "$rutadatos"/logs-services/samba/log.nmbd* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/samba/log.nmbd*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/samba/logfile_log.nmbd.txt
		for i in $path
		do
			{
				echo "${i//"$rutadatos/logs-services/samba/"/}"
				echo ""
				cat "$i"
				echo ""
			} >> "$rutadatos"/logs-services/samba/logfile_log.nmbd.txt
		done
	fi
	
	gunzip "$rutadatos"/logs-services/httpd/error.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/httpd/error.log*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/httpd/logfile_error.log.txt
		for i in $path
		do
			{
				echo "${i//"$rutadatos/logs-services/httpd/"/}"
				echo ""
				cat "$i"
				echo ""
			} >> "$rutadatos"/logs-services/httpd/logfile_error.log.txt
		done
	fi

	gunzip "$rutadatos"/logs-services/httpd/access.log* >> log.txt 2>&1
	path=$(ls "$rutadatos"/logs-services/httpd/access.log*)
	if [[ -n $path ]] 2>> log.txt
	then
		touch "$rutadatos"/logs-services/httpd/logfile_access.log.txt
		for i in $path
		do
			{
				echo "${i//"$rutadatos/logs-services/httpd/"/}"
				echo ""
				cat "$i"
				echo ""
			} >> "$rutadatos"/logs-services/httpd/logfile_access.log.txt
		done
	fi

	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo "${white}"

	# Get dynamic data
	echo "${white}[${red}*${white}]${lightblue} Getting dynamic data..."

	{
		mkdir "$rutadatos"/archivos-dinamicos

		ls -lrtaRh /etc >> "$rutadatos"/archivos-dinamicos/lsetc.txt
		ls -lrtaRh /dev >> "$rutadatos"/archivos-dinamicos/lsdev.txt
		ls -lrtaRh /bin >> "$rutadatos"/archivos-dinamicos/lsbin.txt
		ls -lrtaRh /sbin >> "$rutadatos"/archivos-dinamicos/lssbin.txt
		ls -lrtaRh /usr/bin >> "$rutadatos"/archivos-dinamicos/lsusrbin.txt
		ls -lrtaRh /usr/sbin >> "$rutadatos"/archivos-dinamicos/lsusrsbin.txt
		netstat -tupan >> "$rutadatos"/archivos-dinamicos/netstat.txt
		last >> "$rutadatos"/archivos-dinamicos/last.txt
		w >> "$rutadatos"/archivos-dinamicos/w.txt
		dmesg >> "$rutadatos"/archivos-dinamicos/dmesg.txt
		lsmod >> "$rutadatos"/archivos-dinamicos/lsmod.txt
		ps axufwww >> "$rutadatos"/archivos-dinamicos/ps.txt
		date >> "$rutadatos"/archivos-dinamicos/date.txt
		yum list installed >> "$rutadatos"/archivos-dinamicos/yum.txt 
		free -m >> "$rutadatos"/archivos-dinamicos/free.txt
		lsof >> "$rutadatos"/archivos-dinamicos/lsof.txt
		lsof -i >> "$rutadatos"/archivos-dinamicos/lsofi.txt

		cat /var/log/btmp >> "$rutadatos"/archivos-dinamicos/btmp.txt
		cat /var/log/wtmp >> "$rutadatos"/archivos-dinamicos/wtmp.txt
		cat /etc/os-release >> "$rutadatos"/archivos-dinamicos/os-release.txt
		cat /proc/version >> "$rutadatos"/archivos-dinamicos/version.txt
		cat /proc/cpuinfo >> "$rutadatos"/archivos-dinamicos/cpuinfo.txt
		cat /proc/swaps >> "$rutadatos"/archivos-dinamicos/swaps.txt
		cat /proc/partitions >> "$rutadatos"/archivos-dinamicos/partitions.txt
		cat /proc/self/mounts >> "$rutadatos"/archivos-dinamicos/mounts.txt
		cat /proc/meminfo >> "$rutadatos"/archivos-dinamicos/meminfo.txt
		cat /proc/uptime >> "$rutadatos"/archivos-dinamicos/uptime.txt
		cat /proc/modules >> "$rutadatos"/archivos-dinamicos/modules.txt
		cat /proc/vmstat >> "$rutadatos"/archivos-dinamicos/vmstat.txt

		ls -lah /proc/[0-9]* >> "$rutadatos"/archivos-dinamicos/dataprocess.txt
		ls -lah /proc/[0-9]*/exe >> "$rutadatos"/archivos-dinamicos/exe.txt
		ls -lah /etc/init.d/ >> "$rutadatos"/archivos-dinamicos/initd.txt
	} 2>> log.txt

	mkdir "$rutadatos"/archivos-dinamicos/proc 2>> log.txt

	for i in /proc/[0-9]*
	do
		{
			mkdir "$rutadatos"/archivos-dinamicos/proc/"$i"
			cat "$i"/cgroup >> "$rutadatos"/archivos-dinamicos/proc/"$i"/cgroup.txt
			cat "$i"/cmdline >> "$rutadatos"/archivos-dinamicos/proc/"$i"/cmdline.txt
			cat "$i"/comm >> "$rutadatos"/archivos-dinamicos/proc/"$i"/comm.txt
			cat "$i"/environ >> "$rutadatos"/archivos-dinamicos/proc/"$i"/environ.txt
			cat "$i"/io >> "$rutadatos"/archivos-dinamicos/proc/"$i"/io.txt
			cat "$i"/limits >> "$rutadatos"/archivos-dinamicos/proc/"$i"/limits.txt
			cat "$i"/maps >> "$rutadatos"/archivos-dinamicos/proc/"$i"/maps.txt
			cat "$i"/mountinfo >> "$rutadatos"/archivos-dinamicos/proc/"$i"/mountinfo.txt
			cat "$i"/numa_maps >> "$rutadatos"/archivos-dinamicos/proc/"$i"/numa_maps.txt
			cat "$i"/sched >> "$rutadatos"/archivos-dinamicos/proc/"$i"/sched.txt
			cat "$i"/status >> "$rutadatos"/archivos-dinamicos/proc/"$i"/status.txt
		} 2>> log.txt
	done

	last reboot >> "$rutadatos"/archivos-dinamicos/lastreboot.txt

	echo "${white}[${green}!${white}]${lightblue} Done!"
	echo "${white}"

	# Dump RAM
	if [[ $ram == "Y" ]] || [[ $ram == "y" ]]
	then
		if [[ -d LiME/src ]]
		then
			echo "${white}[${green}!${white}]${lightblue} Dumping RAM..."
			echo "${white}"
			echo "Dumping RAM" >> log.txt
			cd LiME/src/ || return
			insmod lime-"$(uname -r)".ko "path=$rutadatos/volcado_memoria format=raw"
			rmmod lime
			cd ..
			cd ..
			echo "${white}[${green}!${white}]${lightblue} Done!"
			echo "${white}"
		else
			echo "It couldn't detect LiME"
			echo "It couldn't detect LiME" >> log.txt
		fi
	fi
	echo "" >> log.txt
}
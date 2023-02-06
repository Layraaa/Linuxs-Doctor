#!/bin/bash
# analysis.sh
# Get system data and create analysis.txt

function startanalysis (){
	# Create main directory and analysis.txt
	date=$(date +"%Y.%m.%d-%H.%M.%S")
	datapath="$reportpath/evidences-$date"
	mkdir "$datapath" >> /lib/linuxsdoctor/log.txt 2>&1
	
	if [[ ! -d $datapath ]]
	then
		echo "${red}It couldn't be created the main folder${reset}"
		exit
	fi

	touch "$datapath"/analysis.txt >> /lib/linuxsdoctor/log.txt 2>&1

	if [ ! -f "$datapath"/analysis.txt ]
	then
		echo "${red}It couldn't create analysis.txt, check the log${reset}"
		echo "It couldn't get system data because analysis.txt couldn't be created" >> /lib/linuxsdoctor/log.txt
		exit
	else
		{
		echo "*DON'T DELETE THIS FILE, IT'S POSSIBLE THAT YOU COULD HAVE PROBLEMS IF YOU COMPARE THESE EVIDENCES WITH OTHERS*"
		echo "*DON'T MODIFY THIS FILE, YOU CAN DO IT ONLY IF YOU KNOW WHAT ARE YOU DOING*"
		echo ""
		echo "OS: $os"
		echo "Hostaname: $(hostname)"
		echo "Kernel's version: $(uname -r)"
		echo "IP address: $(hostname -I)"
		echo ""
		echo "Linux's Doctor version: v1.2"
		echo "Analysis type: $linuxsdoctor"
		date +"Start date: %Y/%m/%d"
		date +"Start time: %T"
		echo "End date: -"
		echo "End time: -"
		} > "$datapath"/analysis.txt
	fi

}

function endanalysis (){
	# Delete the last file of analysis.txt and write the end time of the analisys
	tail -n 2 "$datapath/analysis.txt" | wc -c | xargs -I {} truncate "$datapath/analysis.txt" -s -{}
	{
		date +"End date: %Y/%m/%d"
		date +"End time: %T"
	} >> "$datapath"/analysis.txt
}

function getdataDebian (){

	# Dump RAM
	if [[ $ram == "Y" ]] || [[ $ram == "y" ]]
	then
		if [[ -d /lib/linuxsdoctor/LiME/src ]]
		then
			echo "${white}[${green}*${white}]${lightblue} Dumping RAM..."
			echo ""
			actualdirectory="$(pwd)"
			echo "Dumping RAM" >> /lib/linuxsdoctor/log.txt
			cd /lib/linuxsdoctor/LiME/src/
			insmod lime-"$(uname -r)".ko "path=$datapath/volcado_memoria format=raw"
			rmmod lime
			cd "$actualdirectory"
			echo "${white}[${green}!${white}]${lightblue} Done!"
			echo "${white}"
		else
			echo "${white}[${red}*${white}]${lightblue}It couldn't detect LiME :("
			echo ""
			echo "It couldn't detect LiME" >> /lib/linuxsdoctor/log.txt
		fi
	fi

	if [ "$dynamicdata" == "Y" ] # Get dynamic data
	then
		echo "${white}[${red}*${white}]${lightblue} Getting dynamic data..."
		
		mkdir "$datapath"/dynamic-data
		
		{
			ls -lrtaRh /etc >> "$datapath"/dynamic-data/lsetc.txt
			ls -lrtaRh /dev >> "$datapath"/dynamic-data/lsdev.txt
			ls -lrtaRh /bin >> "$datapath"/dynamic-data/lsbin.txt
			ls -lrtaRh /sbin >> "$datapath"/dynamic-data/lssbin.txt
			ls -lrtaRh /usr/bin >> "$datapath"/dynamic-data/lsusrbin.txt
			ls -lrtaRh /usr/sbin >> "$datapath"/dynamic-data/lsusrsbin.txt
			netstat -tupan >> "$datapath"/dynamic-data/netstat.txt
			netstat -s >> "$datapath"/dynamic-data/infoconnections.txt
			last >> "$datapath"/dynamic-data/last.txt
			w >> "$datapath"/dynamic-data/w.txt
			dmesg >> "$datapath"/dynamic-data/dmesg.txt
			lsmod >> "$datapath"/dynamic-data/lsmod.txt
			ps axufwww >> "$datapath"/dynamic-data/ps.txt
			date >> "$datapath"/dynamic-data/date.txt
			dpkg -l >> "$datapath"/dynamic-data/dpkg.txt 
			free -h >> "$datapath"/dynamic-data/free.txt
			lsof >> "$datapath"/dynamic-data/lsof.txt
			lsof -i >> "$datapath"/dynamic-data/lsofi.txt
			apt-cache policy >> "$datapath"/dynamic-data/respositories.txt
			df -a >> "$datapath"/dynamic-data/diskuse.txt
			mpstat -P ALL >> "$datapath"/dynamic-data/mpstat.txt
			pidstat >> "$datapath"/dynamic-data/pidstat.txt
			iostat -p >> "$datapath"/dynamic-data/iostat.txt
			uname -a >> "$datapath"/dynamic-data/unamea.txt

			cat /var/log/btmp >> "$datapath"/dynamic-data/btmp.txt
			cat /var/log/wtmp >> "$datapath"/dynamic-data/wtmp.txt
			cat /etc/os-release >> "$datapath"/dynamic-data/os-release.txt
			cat /proc/version >> "$datapath"/dynamic-data/version.txt
			cat /proc/cpuinfo >> "$datapath"/dynamic-data/cpuinfo.txt
			cat /proc/swaps >> "$datapath"/dynamic-data/swaps.txt
			cat /proc/partitions >> "$datapath"/dynamic-data/partitions.txt
			cat /proc/self/mounts >> "$datapath"/dynamic-data/mounts.txt
			cat /proc/meminfo >> "$datapath"/dynamic-data/meminfo.txt
			cat /proc/uptime >> "$datapath"/dynamic-data/uptime.txt
			cat /proc/modules >> "$datapath"/dynamic-data/modules.txt
			cat /proc/vmstat >> "$datapath"/dynamic-data/vmstat.txt

			ls -lah /proc/[0-9]* >> "$datapath"/dynamic-data/dataprocess.txt
			ls -lah /proc/[0-9]*/exe >> "$datapath"/dynamic-data/exe.txt
			ls -lah /etc/init.d/ >> "$datapath"/dynamic-data/initd.txt

		} 2>> /lib/linuxsdoctor/log.txt

		for i in $(ps -ax | tail -n +2 | awk '{print $1}')
		do
			{
				lsof -p "$i" 
				echo ""
			} >> "$datapath"/dynamic-data/processes.txt 2>> /dev/null
		done

		for i in $(systemctl --type=service | sed 's/^.//' | awk '{ print $1 }' | head -n -7 | tail -n +2)
		do
			{
				systemctl status "$i"
				echo ""
			}  >> "$datapath"/dynamic-data/systemctlstatus.txt 2>> /dev/null
		done

		mkdir "$datapath"/dynamic-data/proc 2>> /lib/linuxsdoctor/log.txt

		for i in /proc/[0-9]*
		do
			{
				mkdir "$datapath"/dynamic-data/proc/"$i"
				cat "$i"/cgroup >> "$datapath"/dynamic-data/proc/"$i"/cgroup.txt
				cat "$i"/cmdline >> "$datapath"/dynamic-data/proc/"$i"/cmdline.txt
				cat "$i"/comm >> "$datapath"/dynamic-data/proc/"$i"/comm.txt
				cat "$i"/environ >> "$datapath"/dynamic-data/proc/"$i"/environ.txt
				cat "$i"/io >> "$datapath"/dynamic-data/proc/"$i"/io.txt
				cat "$i"/limits >> "$datapath"/dynamic-data/proc/"$i"/limits.txt
				cat "$i"/maps >> "$datapath"/dynamic-data/proc/"$i"/maps.txt
				cat "$i"/mountinfo >> "$datapath"/dynamic-data/proc/"$i"/mountinfo.txt
				cat "$i"/numa_maps >> "$datapath"/dynamic-data/proc/"$i"/numa_maps.txt
				cat "$i"/sched >> "$datapath"/dynamic-data/proc/"$i"/sched.txt
				cat "$i"/status >> "$datapath"/dynamic-data/proc/"$i"/status.txt
			} 2>> /lib/linuxsdoctor/log.txt
		done

		{
			last reboot >> "$datapath"/dynamic-data/lastreboot.txt
			inxi -Fxxa >> "$datapath"/dynamic-data/inxi.txt
		} 2>> /lib/linuxsdoctor/log.txt

		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo "${white}"
	fi

	if [ "$systemdata" == "Y" ] # Get system data
	then
		mkdir "$datapath"/system-files >> /lib/linuxsdoctor/log.txt 2>&1
		echo "${white}[${red}*${white}]${lightblue} Getting system data..."
		{
			echo "sha256sum" && sha256sum /boot/vmlinuz-"$(uname -r)" && echo ""
			echo "sha512sum" && sha512sum /boot/vmlinuz-"$(uname -r)" && echo ""
			echo "md5sum" && md5sum /boot/vmlinuz-"$(uname -r)"
		} > "$datapath"/system-files/kernelsign.txt
		cat /etc/sudoers > "$datapath"/system-files/sudoers.txt
		{
			echo "sha256sum" && sha256sum /etc/sudoers && echo ""
			echo "sha512sum" && sha512sum /etc/sudoers && echo ""
			echo "md5sum" && md5sum /etc/sudoers
		} > "$datapath"/system-files/sudoerssign.txt
		cat /etc/shadow > "$datapath"/system-files/shadow.txt
		{
			echo "sha256sum" && sha256sum /etc/shadow && echo ""
			echo "sha512sum" && sha512sum /etc/shadow && echo ""
			echo "md5sum" && md5sum /etc/shadow
		} > "$datapath"/system-files/shadowsign.txt
		cat /etc/passwd > "$datapath"/system-files/passwd.txt
		{
			echo "sha256sum" && sha256sum /etc/passwd && echo ""
			echo "sha512sum" && sha512sum /etc/passwd && echo ""
			echo "md5sum" && md5sum /etc/passwd
		} > "$datapath"/system-files/passwdsign.txt
		cat /root/.bash_history > "$datapath"/system-files/root_bash_history.txt
		uname -r >> "$datapath"/system-files/unamer.txt
		dpkg-query -f '${binary:Package}\n' -W > "$datapath"/system-files/dpkg.txt
		cat /etc/crontab > "$datapath"/system-files/crontab.txt
		crontab -l > "$datapath"/system-files/crontabl.txt 2>&1
		cat /etc/default/grub > "$datapath"/system-files/grub.txt
		cat /etc/network/interfaces > "$datapath"/system-files/interfaces.txt
		cat /etc/profile > "$datapath"/system-files/profile.txt
		cat /etc/hosts > "$datapath"/system-files/hosts.txt
		cat /etc/fstab > "$datapath"/system-files/fstab.txt
		cat /etc/mtab > "$datapath"/system-files/mtab.txt
		cat /etc/group > "$datapath"/system-files/group.txt
		mkdir "$datapath"/system-files/rc.d
		cp -p -r /etc/rc*.d/ "$datapath"/system-files/rc.d/ >> /lib/linuxsdoctor/log.txt 2>&1
		for i in $(ls "$datapath"/system-files/rc.d/)
		do
			path="$(ls "$datapath"/system-files/rc.d/"$i")"
			rm -rf "$datapath"/system-files/rc.d/"$i"/*
			for x in $path
			do
				cat /etc/"$i"/"$x" >> "$datapath"/system-files/rc.d/"$i"/"$x"
			done
		done
		{
			cp -p -r /etc/init.d/ "$datapath"/system-files/
			cp -p -r /etc/cron.d/ "$datapath"/system-files/
			cp -p -r /etc/cron.hourly/ "$datapath"/system-files/
			cp -p -r /etc/cron.daily/ "$datapath"/system-files/
			cp -p -r /etc/cron.weekly/ "$datapath"/system-files/
			cp -p -r /etc/cron.monthly/ "$datapath"/system-files/
		} >> /lib/linuxsdoctor/log.txt 2>&1
		cat /proc/cmdline > "$datapath"/system-files/cmdline.txt
		blkid > "$datapath"/system-files/blkid.txt
		lastlog > "$datapath"/system-files/lastlog.txt
		runlevel > "$datapath"/system-files/runlevel.txt
		lspci -vvv > "$datapath"/system-files/lspci.txt
		fdisk -l > "$datapath"/system-files/fdisk.txt
		printenv > "$datapath"/system-files/printenv.txt
		cat /etc/selinux/config > "$datapath"/system-files/selinuxconfig.txt
		cat /etc/selinux/semanage.conf > "$datapath"/system-files/selinuxsemanage.txt
		cat /etc/sestatus.conf > "$datapath"/system-files/selinuxstatus.txt
		cat /etc/hosts.allow > "$datapath"/system-files/hosts_allow.txt
		cat /etc/hosts.deny > "$datapath"/system-files/hosts_deny.txt
		cat /etc/rsyslog.conf > "$datapath"/system-files/rsyslog.txt
		cat /proc/devices > "$datapath"/system-files/devices.txt
		cat /etc/machine-id > "$datapath"/system-files/machine_id.txt
		cat /sys/class/dmi/id/product_uuid > "$datapath"/system-files/product_uuid.txt
		cat /etc/resolv.conf > "$datapath"/system-files/resolv.txt
		mount | column -t > "$datapath"/system-files/mount.txt
		lshw > "$datapath"/system-files/lshw.txt
		lsblk > "$datapath"/system-files/lsblk.txt
		lspci > "$datapath"/system-files/lspci.txt
		lsusb > "$datapath"/system-files/lsusb.txt
		lsscsi -lswP > "$datapath"/system-files/lsscsi.txt
		lscpu > "$datapath"/system-files/lscpu.txt
		dmidecode > "$datapath"/system-files/dmidecode.txt
		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo ""
	fi
	
	if [ "$networkconfiguration" == "Y" ] # Getting information of network configuration
	then
		mkdir "$datapath"/network >> /lib/linuxsdoctor/log.txt 2>&1
		echo "${white}[${red}*${white}]${lightblue} Getting information of network configuration..."
		nmcli dev show | sed '/^IP[4-6].ROUTE/d' > "$datapath"/network/nmcli.txt
		netstat -ltun | awk '{$2=$3=""; print $0}' | tail -n +3 | sort | sed '1 i\Protocol Local_Address Foregein_Address State' | column -t > "$datapath"/network/netstat.txt
		dig +short | sort > "$datapath"/network/dig.txt
		route > "$datapath"/network/route.txt
		arp -v -e > "$datapath"/network/arp.txt
		for i in $(netstat -i | awk '{ print $1 }' | tail -n -2)
		do
			{
				ethtool "$i"
				echo ""
			}  >> "$datapath"/network/ethtool.txt
		done
		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo ""
	fi

	if [ "$systemservices" == "Y" ] # Get information of system's services
	then	
		mkdir "$datapath"/services >> /lib/linuxsdoctor/log.txt 2>&1
		echo "${white}[${red}*${white}]${lightblue} Getting information of system's services..."

		{
			systemctl show -p ActiveState iptables | sed 's/ActiveState=//g'
			echo ""
			echo "-----"
			echo ""
			iptables -L
		}  >> "$datapath"/services/iptables.txt

		{
			firewall-cmd --list-all
			echo "" 
			echo "-----" 
			echo "" 
			cat /etc/firewalld/firewalld.conf 
		} >> "$datapath"/services/firewalld.txt 2>&1

		{
			ufw status verbose
			echo ""
			echo "-----"
			echo ""
			cat /etc/default/ufw
		} >> "$datapath"/services/ufw.txt

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
		}  >> "$datapath"/services/dhcp.txt

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
		}  >> "$datapath"/services/dns.txt

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
		} >> "$datapath"/services/vsftpd.txt

		{
			systemctl show -p ActiveState smbd | sed 's/ActiveState=//g'
			echo ""
			echo "-----"
			echo ""
			cat /etc/samba/smb.conf
		}  >> "$datapath"/services/samba.txt

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
		} >> "$datapath"/services/apache.txt
		for i in $(ls /etc/apache2/sites-available/)
		do
			{
				echo "/etc/apache2/sites-available/$i"
				echo ""
				cat "/etc/apache2/sites-available/$i"
				echo ""
			} >> "$datapath"/services/apache.txt
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
		} >> "$datapath"/services/mariadb.txt
		for i in $(ls /etc/mysql/conf.d/)
		do
			{
				echo "/etc/mysql/conf.d/$i"
				echo ""
				cat "/etc/mysql/conf.d/$i"
				echo ""
			} >> "$datapath"/services/mariadb.txt
		done
		{
			echo ""
			echo "/etc/mysql/mariadb.conf.d"
			echo ""
			echo ""
		} >> "$datapath"/services/mariadb.txt
		for i in $(ls /etc/mysql/mariadb.conf.d/)
		do
			{
				echo "/etc/mysql/mariadb.conf.d/$i"
				echo ""
				cat "/etc/mysql/mariadb.conf.d/$i"
				echo ""
			} >> "$datapath"/services/mariadb.txt
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
		} >> "$datapath"/services/squid.txt
		for i in $(ls /etc/squid/conf.d/)
		do
			{
				echo "/etc/squid/conf.d/$i"
				echo ""
				cat "/etc/squid/conf.d/$i"
				echo ""
			} >> "$datapath"/services/squid.txt
		done

		{
			systemctl show -p ActiveState sshd | sed 's/ActiveState=//g'
			echo ""
			echo "-----"
			echo ""
			cat /etc/ssh/sshd_config
		} >> "$datapath"/services/ssh.txt

		for i in $(ls /etc/php/)
		do
			{
				echo "/etc/php/$i/apache2/php.ini"
				echo ""
				cat "/etc/php/$i/apache2/php.ini"
				echo ""
			} >> "$datapath"/services/php.txt
		done

		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo ""
	fi

	if [ "$systemlogs" == "Y" ] # Get system's logs
	then
		echo "${white}[${red}*${white}]${lightblue} Getting system's logs..."
		{
			mkdir  "$datapath"/system-logs
			mkdir  "$datapath"/system-logs/auth
			mkdir  "$datapath"/system-logs/dpkg
			mkdir  "$datapath"/system-logs/syslog
			mkdir  "$datapath"/system-logs/boot
			mkdir  "$datapath"/system-logs/kern
			mkdir  "$datapath"/system-logs/lastlog
			cp -p /var/log/auth.log* "$datapath"/system-logs/auth/
			cp -p /var/log/dpkg.log* "$datapath"/system-logs/dpkg/
			cp -p /var/log/syslog* "$datapath"/system-logs/syslog/
			cp -p /var/log/boot.log* "$datapath"/system-logs/boot/
			cp -p /var/log/kern.log* "$datapath"/system-logs/kern/
			cp -p /var/log/lastlog* "$datapath"/system-logs/lastlog/
		} >> /lib/linuxsdoctor/log.txt 2>&1

		# Descompress all system's logs and copy their content in a file
		gunzip "$datapath"/system-logs/auth/auth.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/auth/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/auth/logfile_auth_log.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/system-logs/auth/"$i"
					echo ""
				} >> "$datapath"/system-logs/auth/logfile_auth_log.txt
			done
		fi

		gunzip "$datapath"/system-logs/dpkg/dpkg.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/dpkg/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/dpkg/logfile_dpkg_log.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/system-logs/dpkg/"$i"
					echo ""
				} >> "$datapath"/system-logs/dpkg/logfile_dpkg_log.txt
			done
		fi

		gunzip "$datapath"/system-logs/syslog/syslog* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/syslog/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/syslog/logfile_syslog.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/system-logs/syslog/"$i"
					echo ""
				} >> "$datapath"/system-logs/syslog/logfile_syslog.txt
			done
		fi

		gunzip "$datapath"/system-logs/boot/boot.log* >> /lib/linuxsdoctor/log.txt 2>&1	
		path=$(ls "$datapath"/system-logs/boot/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then	
			touch "$datapath"/system-logs/boot/logfile_boot_log.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/system-logs/boot/"$i"
					echo ""
				} >> "$datapath"/system-logs/boot/logfile_boot_log.txt
			done
		fi

		gunzip "$datapath"/system-logs/kern/kern.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/kern/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/kern/logfile_kern_log.txt
			for i in $path
			do
				{
					echo "$i"t
					echo ""t
					cat "$datapath"/system-logs/kern/"$i"
					echo ""t
				} >> "$datapath"/system-logs/kern/logfile_kern_log.txt
			done
		fi

		gunzip "$datapath"/system-logs/lastlog/lastlog* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/lastlog/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/lastlog/logfile_lastlog.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/system-logs/lastlog/"$i"
					echo ""
				} >> "$datapath"/system-logs/lastlog/logfile_lastlog.txt
			done
		fi

		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo ""
	fi

	if [ "$serviceslogs" == "Y" ] # Get services' logs
	then
		echo "${white}[${red}*${white}]${lightblue} Getting services' logs..."
		mkdir  "$datapath"/logs-services >> /lib/linuxsdoctor/log.txt 2>&1
		mkdir  "$datapath"/logs-services/ufw >> /lib/linuxsdoctor/log.txt 2>&1
		mkdir  "$datapath"/logs-services/samba >> /lib/linuxsdoctor/log.txt 2>&1
		mkdir  "$datapath"/logs-services/apache2 >> /lib/linuxsdoctor/log.txt 2>&1
		mkdir  "$datapath"/logs-services/squid >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/ufw* "$datapath"/logs-services/ufw/ >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/samba/log.smbd* "$datapath"/logs-services/samba/ >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/samba/log.nmbd* "$datapath"/logs-services/samba/ >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/apache2/error.log* "$datapath"/logs-services/apache2/ >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/apache2/access.log* "$datapath"/logs-services/apache2/ >> /lib/linuxsdoctor/log.txt 2>&1

		{
			cat /var/log/firewalld > "$datapath"/logs-services/firewalld.txt
			cat /var/log/vsftpd.log > "$datapath"/logs-services/vsftpd.txt
			cat /var/log/mariadb.log > "$datapath"/logs-services/mariadb.txt
			cat /var/log/squid/access.log > "$datapath"/logs-services/squid/access.txt
			cat /var/log/squid/cache.log > "$datapath"/logs-services/squid/cache.txt
		} 2>> /lib/linuxsdoctor/log.txt

		# Descompress logs and copy the content in a file
		gunzip "$datapath"/logs-services/ufw/ufw* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/ufw/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/ufw/logfile_ufw.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/logs-services/ufw/"$i"
					echo ""
				} >> "$datapath"/logs-services/ufw/logfile_ufw.txt
			done
		fi

		gunzip "$datapath"/logs-services/samba/log.smbd* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/samba/log.smbd*)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/samba/logfile_log.smbd.txt
			for i in $path
			do
				{
					echo "${i//"$datapath/logs-services/samba/"/}"
					echo ""
					cat "$i"
					echo ""
				} >> "$datapath"/logs-services/samba/logfile_log.smbd.txt
			done
		fi

		gunzip "$datapath"/logs-services/samba/log.nmbd* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/samba/log.nmbd*)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/samba/logfile_log.nmbd.txt
			for i in $path
			do
				{
					echo "${i//"$datapath/logs-services/samba/"/}"
					echo ""
					cat "$i"
					echo ""
				} >> "$datapath"/logs-services/samba/logfile_log.nmbd.txt
			done
		fi
		
		gunzip "$datapath"/logs-services/apache2/error.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/apache2/error.log*)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/apache2/logfile_error_log.txt
			for i in $path
			do
				{
					echo "${i//"$datapath/logs-services/apache2/"/}"
					echo ""
					cat "$i"
					echo ""
				} >> "$datapath"/logs-services/apache2/logfile_error_log.txt
			done
		fi

		gunzip "$datapath"/logs-services/apache2/access.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/apache2/access.log*)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/apache2/logfile_access_log.txt
			for i in $path
			do
				{
					echo "${i//"$datapath/logs-services/apache2/"/}"
					echo ""
					cat "$i"
					echo ""
				} >> "$datapath"/logs-services/apache2/logfile_access_log.txt
			done
		fi

		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo "${white}"
	fi

	echo "" >> /lib/linuxsdoctor/log.txt
}

function getdataCentOS (){
	
	# Dump RAM
	if [[ $ram == "Y" ]] || [[ $ram == "y" ]]
	then
		if [[ -d /lib/linuxsdoctor/LiME/src ]]
		then
			echo "${white}[${green}*${white}]${lightblue} Dumping RAM..."
			echo ""
			actualdirectory="$(pwd)"
			echo "Dumping RAM" >> /lib/linuxsdoctor/log.txt
			cd /lib/linuxsdoctor/LiME/src/
			insmod lime-"$(uname -r)".ko "path=$datapath/volcado_memoria format=raw"
			rmmod lime
			cd "$actualdirectory"
			echo "${white}[${green}!${white}]${lightblue} Done!"
			echo "${white}"
		else
			echo "${white}[${red}*${white}]${lightblue}It couldn't detect LiME :("
			echo "It couldn't detect LiME" >> /lib/linuxsdoctor/log.txt
		fi
	fi

	if [ "$dynamicdata" == "Y" ] # Get dynamic data
	then
		echo "${white}[${red}*${white}]${lightblue} Getting dynamic data..."

		mkdir "$datapath"/dynamic-data

		{
			ls -lrtaRh /etc >> "$datapath"/dynamic-data/lsetc.txt
			ls -lrtaRh /dev >> "$datapath"/dynamic-data/lsdev.txt
			ls -lrtaRh /bin >> "$datapath"/dynamic-data/lsbin.txt
			ls -lrtaRh /sbin >> "$datapath"/dynamic-data/lssbin.txt
			ls -lrtaRh /usr/bin >> "$datapath"/dynamic-data/lsusrbin.txt
			ls -lrtaRh /usr/sbin >> "$datapath"/dynamic-data/lsusrsbin.txt
			netstat -tupan >> "$datapath"/dynamic-data/netstat.txt
			last >> "$datapath"/dynamic-data/last.txt
			w >> "$datapath"/dynamic-data/w.txt
			dmesg >> "$datapath"/dynamic-data/dmesg.txt
			lsmod >> "$datapath"/dynamic-data/lsmod.txt
			ps axufwww >> "$datapath"/dynamic-data/ps.txt
			date >> "$datapath"/dynamic-data/date.txt
			yum list installed >> "$datapath"/dynamic-data/yum.txt 
			free -h >> "$datapath"/dynamic-data/free.txt
			lsof >> "$datapath"/dynamic-data/lsof.txt
			lsof -i >> "$datapath"/dynamic-data/lsofi.txt
			yum -v repolist all >> "$datapath"/dynamic-data/respositories.txt
			uname -a >> "$datapath"/dynamic-data/unamea.txt

			cat /var/log/btmp >> "$datapath"/dynamic-data/btmp.txt
			cat /var/log/wtmp >> "$datapath"/dynamic-data/wtmp.txt
			cat /etc/os-release >> "$datapath"/dynamic-data/os-release.txt
			cat /proc/version >> "$datapath"/dynamic-data/version.txt
			cat /proc/cpuinfo >> "$datapath"/dynamic-data/cpuinfo.txt
			cat /proc/swaps >> "$datapath"/dynamic-data/swaps.txt
			cat /proc/partitions >> "$datapath"/dynamic-data/partitions.txt
			cat /proc/self/mounts >> "$datapath"/dynamic-data/mounts.txt
			cat /proc/meminfo >> "$datapath"/dynamic-data/meminfo.txt
			cat /proc/uptime >> "$datapath"/dynamic-data/uptime.txt
			cat /proc/modules >> "$datapath"/dynamic-data/modules.txt
			cat /proc/vmstat >> "$datapath"/dynamic-data/vmstat.txt

			ls -lah /proc/[0-9]* >> "$datapath"/dynamic-data/dataprocess.txt
			ls -lah /proc/[0-9]*/exe >> "$datapath"/dynamic-data/exe.txt
			ls -lah /etc/init.d/ >> "$datapath"/dynamic-data/initd.txt

		} 2>> /lib/linuxsdoctor/log.txt

		for i in $(ps -ax | tail -n +2 | awk '{print $1}')
		do
			{
				lsof -p "$i" 
				echo ""
			} >> "$datapath"/dynamic-data/processes.txt 2>> /dev/null
		done

		for i in $(systemctl --type=service | sed 's/^.//' | awk '{ print $1 }' | head -n -7 | tail -n +2)
		do
			{
				systemctl status "$i"
				echo ""
			}  >> "$datapath"/dynamic-data/systemctlstatus.txt 2>> /dev/null
		done

		mkdir "$datapath"/dynamic-data/proc 2>> /lib/linuxsdoctor/log.txt

		for i in /proc/[0-9]*
		do
			{
				mkdir "$datapath"/dynamic-data/proc/"$i"
				cat "$i"/cgroup >> "$datapath"/dynamic-data/proc/"$i"/cgroup.txt
				cat "$i"/cmdline >> "$datapath"/dynamic-data/proc/"$i"/cmdline.txt
				cat "$i"/comm >> "$datapath"/dynamic-data/proc/"$i"/comm.txt
				cat "$i"/environ >> "$datapath"/dynamic-data/proc/"$i"/environ.txt
				cat "$i"/io >> "$datapath"/dynamic-data/proc/"$i"/io.txt
				cat "$i"/limits >> "$datapath"/dynamic-data/proc/"$i"/limits.txt
				cat "$i"/maps >> "$datapath"/dynamic-data/proc/"$i"/maps.txt
				cat "$i"/mountinfo >> "$datapath"/dynamic-data/proc/"$i"/mountinfo.txt
				cat "$i"/numa_maps >> "$datapath"/dynamic-data/proc/"$i"/numa_maps.txt
				cat "$i"/sched >> "$datapath"/dynamic-data/proc/"$i"/sched.txt
				cat "$i"/status >> "$datapath"/dynamic-data/proc/"$i"/status.txt
			} 2>> /lib/linuxsdoctor/log.txt
		done

		{
			last reboot >> "$datapath"/dynamic-data/lastreboot.txt
			inxi -Fxxa >> "$datapath"/dynamic-data/inxi.txt
		} 2>> /lib/linuxsdoctor/log.txt

		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo "${white}"
	fi

	if [ "$systemdata" == "Y" ] # Get system data
	then
		mkdir "$datapath"/system-files >> /lib/linuxsdoctor/log.txt 2>&1
		echo "${white}[${red}*${white}]${lightblue} Getting system data..."
		{
			echo "sha256sum" && sha256sum /boot/vmlinuz-"$(uname -r)" && echo ""
			echo "sha512sum" && sha512sum /boot/vmlinuz-"$(uname -r)" && echo ""
			echo "md5sum" && md5sum /boot/vmlinuz-"$(uname -r)"
		} > "$datapath"/system-files/kernelsign.txt
		cat /etc/sudoers > "$datapath"/system-files/sudoers.txt
		{
			echo "sha256sum" && sha256sum /etc/sudoers && echo ""
			echo "sha512sum" && sha512sum /etc/sudoers && echo ""
			echo "md5sum" && md5sum /etc/sudoers
		} > "$datapath"/system-files/sudoerssign.txt
		cat /etc/shadow > "$datapath"/system-files/shadow.txt
		{
			echo "sha256sum" && sha256sum /etc/shadow && echo ""
			echo "sha512sum" && sha512sum /etc/shadow && echo ""
			echo "md5sum" && md5sum /etc/shadow
		} > "$datapath"/system-files/shadowsign.txt
		cat /etc/passwd > "$datapath"/system-files/passwd.txt
		{
			echo "sha256sum" && sha256sum /etc/passwd && echo ""
			echo "sha512sum" && sha512sum /etc/passwd && echo ""
			echo "md5sum" && md5sum /etc/passwd
		} > "$datapath"/system-files/passwdsign.txt
		cat /root/.bash_history > "$datapath"/system-files/root_bash_history.txt
		uname -r >> "$datapath"/system-files/unamer.txt
		rpm -qa > "$datapath"/system-files/dpkg.txt
		cat /etc/crontab > "$datapath"/system-files/crontab.txt
		crontab -l > "$datapath"/system-files/crontabl.txt 2>&1
		cat /etc/default/grub > "$datapath"/system-files/grub.txt
		for i in $(ls /etc/sysconfig/network-scripts/ifcfg-*)
		do
			{
				echo "$i"
				echo ""
				cat "$i"
				echo ""
			} >> "$datapath"/system-files/interfaces.txt
		done
		cat /etc/profile > "$datapath"/system-files/profile.txt
		cat /etc/hosts > "$datapath"/system-files/hosts.txt
		cat /etc/fstab > "$datapath"/system-files/fstab.txt
		cat /etc/mtab > "$datapath"/system-files/mtab.txt
		cat /etc/group > "$datapath"/system-files/group.txt
		mkdir "$datapath"/system-files/rc.d
		cp -p -r /etc/rc.d/rc*.d/ "$datapath"/system-files/rc.d/ >> /lib/linuxsdoctor/log.txt 2>&1
		for i in $(ls "$datapath"/system-files/rc.d/)
		do
			path="$(ls "$datapath"/system-files/rc.d/"$i")"
			rm -rf "$datapath"/system-files/rc.d/"$i"/*
			for x in $path
			do
				cat /etc/"$i"/"$x" >> "$datapath"/system-files/rc.d/"$i"/"$x"
			done
		done
		{
			cp -p -r /etc/init.d/ "$datapath"/system-files/
			cp -p -r /etc/cron.d/ "$datapath"/system-files/
			cp -p -r /etc/cron.hourly/ "$datapath"/system-files/
			cp -p -r /etc/cron.daily/ "$datapath"/system-files/
			cp -p -r /etc/cron.weekly/ "$datapath"/system-files/
			cp -p -r /etc/cron.monthly/ "$datapath"/system-files/
		} >> /lib/linuxsdoctor/log.txt 2>&1

		cat /proc/cmdline > "$datapath"/system-files/cmdline.txt
		blkid > "$datapath"/system-files/blkid.txt
		lastlog > "$datapath"/system-files/lastlog.txt
		runlevel > "$datapath"/system-files/runlevel.txt
		lspci -vvv > "$datapath"/system-files/lspci.txt
		fdisk -l > "$datapath"/system-files/fdisk.txt
		printenv > "$datapath"/system-files/printenv.txt
		cat /etc/selinux/config > "$datapath"/system-files/selinuxconfig.txt
		cat /etc/selinux/semanage.conf > "$datapath"/system-files/selinuxsemanage.txt
		cat /etc/sestatus.conf > "$datapath"/system-files/selinuxstatus.txt
		cat /etc/hosts.allow > "$datapath"/system-files/hosts_allow.txt
		cat /etc/hosts.deny > "$datapath"/system-files/hosts_deny.txt
		cat /etc/rsyslog.conf > "$datapath"/system-files/rsyslog.txt
		cat /proc/devices > "$datapath"/system-files/devices.txt
		cat /etc/machine-id > "$datapath"/system-files/machine_id.txt
		cat /sys/class/dmi/id/product_uuid > "$datapath"/system-files/product_uuid.txt
		cat /etc/resolv.conf > "$datapath"/system-files/resolv.txt
		mount | column -t > "$datapath"/system-files/mount.txt
		lshw > "$datapath"/system-files/lshw.txt
		lsblk > "$datapath"/system-files/lsblk.txt
		lspci > "$datapath"/system-files/lspci.txt
		lsusb > "$datapath"/system-files/lsusb.txt
		lsscsi -lswP > "$datapath"/system-files/lsscsi.txt
		lscpu > "$datapath"/system-files/lscpu.txt
		dmidecode > "$datapath"/system-files/dmidecode.txt
		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo ""
	fi

	if [ "$networkconfiguration" == "Y" ] # Getting information of network configuration
	then
		mkdir "$datapath"/network >> /lib/linuxsdoctor/log.txt 2>&1
		echo "${white}[${red}*${white}]${lightblue} Getting information of network configuration..."
		nmcli dev show | sed '/^IP[4-6].ROUTE/d' > "$datapath"/network/nmcli.txt
		netstat -ltun | awk '{$2=$3=""; print $0}' | tail -n +3 | sort | sed '1 i\Protocol Local_Address Foregein_Address State' | column -t > "$datapath"/network/netstat.txt
		dig +short | sort > "$datapath"/network/dig.txt
		route > "$datapath"/network/route.txt
		arp -v -e > "$datapath"/network/arp.txt
		for i in $(netstat -i | awk '{ print $1 }' | tail -n -2)
		do
			{
				ethtool "$i"
				echo ""
			}  >> "$datapath"/network/ethtool.txt
		done
		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo ""
	fi

	if [ "$systemservices" == "Y" ] # Get information of system's services
	then
		mkdir "$datapath"/services >> /lib/linuxsdoctor/log.txt 2>&1
		echo "${white}[${red}*${white}]${lightblue} Getting information of system's services..."

		{
			systemctl show -p ActiveState iptables | sed 's/ActiveState=//g'
			echo ""
			echo "-----"
			echo ""
			iptables -L
		}  >> "$datapath"/services/iptables.txt

		{
			firewall-cmd --list-all
			echo "" 
			echo "-----" 
			echo "" 
			cat /etc/firewalld/firewalld.conf 
		} >> "$datapath"/services/firewalld.txt

		{
			ufw status verbose
			echo ""
			echo "-----"
			echo ""
			cat /etc/default/ufw
		} >> "$datapath"/services/ufw.txt

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
		} >> "$datapath"/services/dhcp.txt

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
		} >> "$datapath"/services/dns.txt

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
		} >> "$datapath"/services/vsftpd.txt

		{
			systemctl show -p ActiveState smb | sed 's/ActiveState=//g'
			echo ""
			echo "-----"
			echo ""
			cat /etc/samba/smb.conf
		} >> "$datapath"/services/samba.txt

		{
			systemctl show -p ActiveState httpd | sed 's/ActiveState=//g'
			echo ""
			echo "-----"
			echo ""
			cat /etc/httpd/conf/httpd.conf
		} >> "$datapath"/services/apache.txt

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
		} >> "$datapath"/services/mariadb.txt
		for i in $(ls /etc/my.cnf.d/)
		do
			{
				echo "/etc/my.cnf.d/$i"
				echo ""
				cat "/etc/my.cnf.d/$i"
				echo ""
			} >> "$datapath"/services/mariadb.txt
		done
		
		{
			systemctl show -p ActiveState squid | sed 's/ActiveState=//g'
			echo ""
			echo "-----"
			echo ""
			cat /etc/squid/squid.conf
		} >> "$datapath"/services/squid.txt
		
		{
			systemctl show -p ActiveState sshd | sed 's/ActiveState=//g'
			echo ""
			echo "-----"
			echo ""
			cat /etc/ssh/sshd_config
		} >> "$datapath"/services/ssh.txt

		cat /etc/php.ini >> "$datapath"/services/php.txt

		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo ""
	fi

	if [ "$systemlogs" == "Y" ] # Get system's logs
	then
		echo "${white}[${red}*${white}]${lightblue} Getting system's logs..."
		{
			mkdir  "$datapath"/system-logs
			mkdir  "$datapath"/system-logs/auth
			mkdir  "$datapath"/system-logs/dpkg
			mkdir  "$datapath"/system-logs/messages
			mkdir  "$datapath"/system-logs/boot
			mkdir  "$datapath"/system-logs/kern
			mkdir  "$datapath"/system-logs/lastlog
			cp -p /var/log/auth.log*  "$datapath"/system-logs/auth/
			cp -p /var/log/dpkg.log*  "$datapath"/system-logs/dpkg/
			cp -p /var/log/messages*  "$datapath"/system-logs/messages/
			cp -p /var/log/boot.log*  "$datapath"/system-logs/boot/
			cp -p /var/log/kern.log*  "$datapath"/system-logs/kern/
			cp -p /var/log/lastlog* "$datapath"/system-logs/lastlog/
		} >> /lib/linuxsdoctor/log.txt 2>&1

		# Descompress all system's logs and copy their content in a file
		gunzip "$datapath"/system-logs/auth/auth.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/auth/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/auth/logfile_auth_log.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/system-logs/auth/"$i"
					echo ""
				} >> "$datapath"/system-logs/auth/logfile_auth_log.txt
			done
		fi

		gunzip "$datapath"/system-logs/dpkg/dpkg.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/dpkg/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/dpkg/logfile_dpkg_log.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/system-logs/dpkg/"$i"
					echo ""
				} >> "$datapath"/system-logs/dpkg/logfile_dpkg_log.txt
			done
		fi

		gunzip "$datapath"/system-logs/messages/messages* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/messages/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/messages/logfile_messages.txt
			for i in $path
			do
				{
					echo "$i" 
					echo "" 
					cat "$datapath"/system-logs/messages/"$i" 
					echo "" 
				} >> "$datapath"/system-logs/messages/logfile_messages.txt
			done
		fi

		gunzip "$datapath"/system-logs/boot/boot.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/boot/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/boot/logfile_boot_log.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/system-logs/boot/"$i"
					echo ""
				} >> "$datapath"/system-logs/boot/logfile_boot_log.txt
			done
		fi

		gunzip "$datapath"/system-logs/kern/kern.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/kern/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/kern/logfile_kern_log.txt
			for i in $path
			do
				{
					echo "$i"t
					echo ""t
					cat "$datapath"/system-logs/kern/"$i"
					echo ""t
				} >> "$datapath"/system-logs/kern/logfile_kern_log.txt
			done
		fi

		gunzip "$datapath"/system-logs/lastlog/lastlog* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/system-logs/lastlog/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/system-logs/lastlog/logfile_lastlog.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/system-logs/lastlog/"$i"
					echo ""
				} >> "$datapath"/system-logs/lastlog/logfile_lastlog.txt
			done
		fi

		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo ""
	fi

	if [ "$serviceslogs" == "Y" ] # Get services' logs
	then
		echo "${white}[${red}*${white}]${lightblue} Getting services' logs..."
		mkdir  "$datapath"/logs-services >> /lib/linuxsdoctor/log.txt 2>&1
		mkdir  "$datapath"/logs-services/ufw >> /lib/linuxsdoctor/log.txt 2>&1
		mkdir  "$datapath"/logs-services/samba >> /lib/linuxsdoctor/log.txt 2>&1
		mkdir  "$datapath"/logs-services/httpd >> /lib/linuxsdoctor/log.txt 2>&1
		mkdir  "$datapath"/logs-services/squid >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/ufw* "$datapath"/logs-services/ufw/ >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/samba/log.smbd* "$datapath"/logs-services/samba/ >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/samba/log.nmbd* "$datapath"/logs-services/samba/ >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/httpd/error_log* "$datapath"/logs-services/httpd/ >> /lib/linuxsdoctor/log.txt 2>&1
		cp -p /var/log/httpd/access_log* "$datapath"/logs-services/httpd/ >> /lib/linuxsdoctor/log.txt 2>&1

		{
			cat /var/log/firewalld > "$datapath"/logs-services/firewalld.txt
			cat /var/log/vsftpd.log > "$datapath"/logs-services/vsftpd.txt
			cat /var/log/mariadb/mariadb.log > "$datapath"/logs-services/mariadb.txt
			cat /var/log/squid/access.log > "$datapath"/logs-services/squid/access.txt
			cat /var/log/squid/cache.log > "$datapath"/logs-services/squid/cache.txt
		} 2>> /lib/linuxsdoctor/log.txt

		# Descompress logs and copy the content in a file
		gunzip "$datapath"/logs-services/ufw/ufw* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/ufw/)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/ufw/logfile_ufw.txt
			for i in $path
			do
				{
					echo "$i"
					echo ""
					cat "$datapath"/logs-services/ufw/"$i"
					echo ""
				} >> "$datapath"/logs-services/ufw/logfile_ufw.txt
			done
		fi

		gunzip "$datapath"/logs-services/samba/log.smbd* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/samba/log.smbd*)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/samba/logfile_log.smbd.txt
			for i in $path
			do
				{
					echo "${i//"$datapath/logs-services/samba/"/}"
					echo ""
					cat "$i"
					echo ""
				} >> "$datapath"/logs-services/samba/logfile_log.smbd.txt
			done
		fi

		gunzip "$datapath"/logs-services/samba/log.nmbd* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/samba/log.nmbd*)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/samba/logfile_log.nmbd.txt
			for i in $path
			do
				{
					echo "${i//"$datapath/logs-services/samba/"/}"
					echo ""
					cat "$i"
					echo ""
				} >> "$datapath"/logs-services/samba/logfile_log.nmbd.txt
			done
		fi
		
		gunzip "$datapath"/logs-services/httpd/error.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/httpd/error.log*)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/httpd/logfile_error_log.txt
			for i in $path
			do
				{
					echo "${i//"$datapath/logs-services/httpd/"/}"
					echo ""
					cat "$i"
					echo ""
				} >> "$datapath"/logs-services/httpd/logfile_error_log.txt
			done
		fi

		gunzip "$datapath"/logs-services/httpd/access.log* >> /lib/linuxsdoctor/log.txt 2>&1
		path=$(ls "$datapath"/logs-services/httpd/access.log*)
		if [[ -n $path ]] 2>> /lib/linuxsdoctor/log.txt
		then
			touch "$datapath"/logs-services/httpd/logfile_access_log.txt
			for i in $path
			do
				{
					echo "${i//"$datapath/logs-services/httpd/"/}"
					echo ""
					cat "$i"
					echo ""
				} >> "$datapath"/logs-services/httpd/logfile_access_log.txt
			done
		fi

		echo "${white}[${green}!${white}]${lightblue} Done!"
		echo "${white}"
	fi

	echo "" >> /lib/linuxsdoctor/log.txt
}
# comparision.sh
# Check that system can make comparisions correctly
# and hold functions that make these comparisions

function comparacionDebian (){
    # Starting report
	touch "$rutadatos"/report.txt
	date +"Report made the %d/%m/%Y - %T" >> log.txt
	date +"Report made the %d/%m/%Y - %T" >> "$rutadatos"/report.txt
	echo "" >> "$rutadatos"/report.txt
    echo ""
	echo "${white}[${red}*${white}]${lightblue} Starting files comparisions..."

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/system-files || ! -d $rutadatos/system-files ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's files can't be compared"
		echo ""
	else
		# Comparisions system's files
		echo "${white}[${red}*${white}]${lightblue} Comparising system's files..."

		if [[ ! -f $rutauno/system-files/kernelsign.txt || ! -f $rutadatos/system-files/kernelsign.txt ]]
        then
            echo "[?] It couldn't analyze the information of kernel, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/kernelsign.txt "$rutadatos"/system-files/kernelsign.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The kernel has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] The kernel has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/kernelsign.txt "$rutadatos"/system-files/kernelsign.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/sudoerssign.txt || ! -f $rutadatos/system-files/sudoerssign.txt ]]
        then
            echo "[?] It couldn't analyze the information of sudoers file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/sudoerssign.txt "$rutadatos"/system-files/sudoerssign.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Sudoers file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Sudoers file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/sudoers.txt "$rutadatos"/system-files/sudoers.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/shadowsign.txt || ! -f $rutadatos/system-files/shadowsign.txt ]]
        then
            echo "[?] It couldn't analyze the information of shadow file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/shadowsign.txt "$rutadatos"/system-files/shadowsign.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Shadow file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Shadow file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/shadow.txt "$rutadatos"/system-files/shadow.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/passwdsign.txt || ! -f $rutadatos/system-files/passwdsign.txt ]]
        then
            echo "[?] It couldn't analyze the information of passwd file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/passwdsign.txt "$rutadatos"/system-files/passwdsign.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Passwd file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Passwd file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/passwdsign.txt "$rutadatos"/system-files/passwdsign.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/root_bash_history.txt || ! -f $rutadatos/system-files/root_bash_history.txt ]]
        then
            echo "[?] It couldn't analyze the information of bash history file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/root_bash_history.txt "$rutadatos"/system-files/root_bash_history.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The bash history has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] The bash history has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/root_bash_history.txt "$rutadatos"/system-files/root_bash_history.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/unamea.txt || ! -f $rutadatos/system-files/unamea.txt ]]
        then
            echo "[?] It couldn't analyze linux system information, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/unamea.txt "$rutadatos"/system-files/unamea.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Linux system information has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Linux system information has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/unamea.txt "$rutadatos"/system-files/unamea.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/unamer.txt || ! -f $rutadatos/system-files/unamer.txt ]]
        then
            echo "[?] It couldn't analyze information about kernel, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/unamer.txt "$rutadatos"/system-files/unamer.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Kernel information has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Kernel information has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/unamer.txt "$rutadatos"/system-files/unamer.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/dpkg.txt || ! -f $rutadatos/system-files/dpkg.txt ]]
        then
            echo "[?] It couldn't analyze the information of dpkg file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/dpkg.txt "$rutadatos"/system-files/dpkg.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't been detected changes on installed packages" >> "$rutadatos"/report.txt
        else
            echo "[!] It has been detected changes on installed packages" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/dpkg.txt "$rutadatos"/system-files/dpkg.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/crontab.txt || ! -f $rutadatos/system-files/crontab.txt ]]
        then
            echo "[?] It couldn't analyze the information of crontab file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/crontab.txt "$rutadatos"/system-files/crontab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Crontab file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Crontab file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/crontab.txt "$rutadatos"/system-files/crontab.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/crontabl.txt || ! -f $rutadatos/system-files/crontabl.txt ]]
        then
            echo "[?] It couldn't analyze the information of Cron's tables, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/crontabl.txt "$rutadatos"/system-files/crontabl.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Cron's tables have not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Cron's tables have been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/crontabl.txt "$rutadatos"/system-files/crontabl.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/grub.txt || ! -f $rutadatos/system-files/grub.txt ]]
        then
            echo "[?] It couldn't analyze the information of GRUB, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/grub.txt "$rutadatos"/system-files/grub.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The GRUB has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] The GRUB has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/grub.txt "$rutadatos"/system-files/grub.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/interfaces.txt || ! -f $rutadatos/system-files/interfaces.txt ]]
        then
            echo "[?] It couldn't analyze the information of interfaces file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/interfaces.txt "$rutadatos"/system-files/interfaces.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Interfaces file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Interfaces file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/interfaces.txt "$rutadatos"/system-files/interfaces.txt >> "$rutadatos"/report.txt
        fi
        
        if [[ ! -f $rutauno/system-files/profile.txt || ! -f $rutadatos/system-files/profile.txt ]]
        then
            echo "[?] It couldn't analyze the information of profile file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/profile.txt "$rutadatos"/system-files/profile.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Profile file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Profile file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/profile.txt "$rutadatos"/system-files/profile.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/hosts.txt || ! -f $rutadatos/system-files/hosts.txt ]]
        then
            echo "[?] It couldn't analyze the information of hosts file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/hosts.txt "$rutadatos"/system-files/hosts.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Hosts file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Hosts file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/hosts.txt "$rutadatos"/system-files/hosts.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/fstab.txt || ! -f $rutadatos/system-files/fstab.txt ]]
        then
            echo "[?] It couldn't analyze the information of fstab file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/fstab.txt "$rutadatos"/system-files/fstab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Fstab file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Fstab file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/fstab.txt "$rutadatos"/system-files/fstab.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/mtab.txt || ! -f $rutadatos/system-files/mtab.txt ]]
        then
            echo "[?] It couldn't analyze the information of mtab file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/mtab.txt "$rutadatos"/system-files/mtab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Mtab file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Mtab file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/mtab.txt "$rutadatos"/system-files/mtab.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/group.txt || ! -f $rutadatos/system-files/group.txt ]]
        then
            echo "[?] It couldn't analyze the information of group file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/group.txt "$rutadatos"/system-files/group.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Group file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Group file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/group.txt "$rutadatos"/system-files/group.txt >> "$rutadatos"/report.txt
        fi

        path1=$(ls "$rutauno"/system-files/rc.d/)
        path2=$(ls "$rutadatos"/system-files/rc.d/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/rc.d/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                path3=$(ls "$rutauno"/system-files/rc.d/"$i")
                for x in $path3
                do
                    if [[ ! -f $rutauno/system-files/rc.d/$i/$x || ! -f $rutadatos/system-files/rc.d/$i/$x ]]
                    then
                        echo "[?] It couldn't analyze the information of $i/$x file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                    elif [[ $(cmp "$rutauno"/system-files/rc.d/"$i"/"$x" "$rutadatos"/system-files/rc.d/"$i"/"$x") == "" ]] >> log.txt 2>&1
                    then
                        echo "[*] $i/$x file has not been modified" >> "$rutadatos"/report.txt
                    else
                        echo "[!] $i/$x file has been modified" >> "$rutadatos"/report.txt
                        diff "$rutauno"/system-files/rc.d/"$i"/"$x" "$rutadatos"/system-files/rc.d/"$i"/"$x" >> "$rutadatos"/report.txt
                    fi
                done
            done
        fi

        path1=$(ls "$rutauno"/system-files/init.d/)
        path2=$(ls "$rutadatos"/system-files/init.d/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/init.d/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/init.d/$i || ! -f $rutadatos/system-files/init.d/$i ]]
                then
                    echo "[?] It couldn't analyze the information of init.d/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/init.d/"$i" "$rutadatos"/system-files/init.d/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] init.d/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] init.d/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/init.d/"$i" "$rutadatos"/system-files/init.d/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.d/)
        path2=$(ls "$rutadatos"/system-files/cron.d/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.d/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.d/$i || ! -f $rutadatos/system-files/cron.d/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.d/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.d/"$i" "$rutadatos"/system-files/cron.d/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.d/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.d/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.d/"$i" "$rutadatos"/system-files/cron.d/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.hourly/)
        path2=$(ls "$rutadatos"/system-files/cron.hourly/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.hourly/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.hourly/$i || ! -f $rutadatos/system-files/cron.hourly/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.hourly/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.hourly/"$i" "$rutadatos"/system-files/cron.hourly/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.hourly/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.hourly/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.hourly/"$i" "$rutadatos"/system-files/cron.hourly/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.dialy/)
        path2=$(ls "$rutadatos"/system-files/cron.dialy/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.dialy/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.dialy/$i || ! -f $rutadatos/system-files/cron.dialy/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.dialy/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.dialy/"$i" "$rutadatos"/system-files/cron.dialy/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.dialy/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.dialy/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.dialy/"$i" "$rutadatos"/system-files/cron.dialy/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.weekely/)
        path2=$(ls "$rutadatos"/system-files/cron.weekely/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.weekely/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.weekely/$i || ! -f $rutadatos/system-files/cron.weekely/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.weekely/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.weekely/"$i" "$rutadatos"/system-files/cron.weekely/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.weekely/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.weekely/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.weekely/"$i" "$rutadatos"/system-files/cron.weekely/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.monthly/)
        path2=$(ls "$rutadatos"/system-files/cron.monthly/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.monthly/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.monthly/$i || ! -f $rutadatos/system-files/cron.monthly/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.monthly/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.monthly/"$i" "$rutadatos"/system-files/cron.monthly/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.monthly/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.monthly/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.monthly/"$i" "$rutadatos"/system-files/cron.monthly/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        if [[ ! -f $rutauno/system-files/cmdline.txt || ! -f $rutadatos/system-files/cmdline.txt ]]
        then
            echo "[?] It couldn't analyze the information of cmdline file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/cmdline.txt "$rutadatos"/system-files/cmdline.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Cmdline file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Cmdline file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/cmdline.txt "$rutadatos"/system-files/cmdline.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/blkid.txt || ! -f $rutadatos/system-files/blkid.txt ]]
        then
            echo "[?] It couldn't analyze the information of system's partitions, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/blkid.txt "$rutadatos"/system-files/blkid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] System's partitions have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] System's partitions have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/blkid.txt "$rutadatos"/system-files/blkid.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/lastlog.txt || ! -f $rutadatos/system-files/lastlog.txt ]]
        then
            echo "[?] It couldn't analyze the information of lastlog, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/lastlog.txt "$rutadatos"/system-files/lastlog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected a new login" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected a new login" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/lastlog.txt "$rutadatos"/system-files/lastlog.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/runlevel.txt || ! -f $rutadatos/system-files/runlevel.txt ]]
        then
            echo "[?] It couldn't analyze the information of runlevel, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/runlevel.txt "$rutadatos"/system-files/runlevel.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Runlevel has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Runlevel has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/runlevel.txt "$rutadatos"/system-files/runlevel.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/lspci.txt || ! -f $rutadatos/system-files/lspci.txt ]]
        then
            echo "[?] It couldn't analyze the information of system's devices and buses, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/lspci.txt "$rutadatos"/system-files/lspci.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] System's devices and buses have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] System's devices and buses have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/lspci.txt "$rutadatos"/system-files/lspci.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/fdisk.txt || ! -f $rutadatos/system-files/fdisk.txt ]]
        then
            echo "[?] It couldn't analyze the information of disks or disks' partitions, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/fdisk.txt "$rutadatos"/system-files/fdisk.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Disks or disks' partitions have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Disks or disks' partitions have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/fdisk.txt "$rutadatos"/system-files/fdisk.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/printenv.txt || ! -f $rutadatos/system-files/printenv.txt ]]
        then
            echo "[?] It couldn't analyze the information of system's variables, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/printenv.txt "$rutadatos"/system-files/printenv.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] System's variables have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] System's variables have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/printenv.txt "$rutadatos"/system-files/printenv.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/selinuxconfig.txt || ! -f $rutadatos/system-files/selinuxconfig.txt ]]
        then
            echo "[?] It couldn't analyze the information of selinux's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/selinuxconfig.txt "$rutadatos"/system-files/selinuxconfig.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Selinux's configuration has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Selinux's configuration has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/selinuxconfig.txt "$rutadatos"/system-files/selinuxconfig.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/selinuxsemanage.txt || ! -f $rutadatos/system-files/selinuxsemanage.txt ]]
        then
            echo "[?] It couldn't analyze the information of selinux's politics configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/selinuxsemanage.txt "$rutadatos"/system-files/selinuxsemanage.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Selinux's politics configuration have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Selinux's politics configuration have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/selinuxsemanage.txt "$rutadatos"/system-files/selinuxsemanage.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/selinuxstatus.txt || ! -f $rutadatos/system-files/selinuxstatus.txt ]]
        then
            echo "[?] It couldn't analyze the information of sestatus.conf file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/selinuxstatus.txt "$rutadatos"/system-files/selinuxstatus.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Sestatus.conf file has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Sestatus.conf file has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/selinuxstatus.txt "$rutadatos"/system-files/selinuxstatus.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/hosts_allow.txt || ! -f $rutadatos/system-files/hosts_allow.txt ]]
        then
            echo "[?] It couldn't analyze the information of allowed hosts, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/hosts_allow.txt "$rutadatos"/system-files/hosts_allow.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Allowed hosts has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Allowed hosts has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/hosts_allow.txt "$rutadatos"/system-files/hosts_allow.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/hosts_deny.txt || ! -f $rutadatos/system-files/hosts_deny.txt ]]
        then
            echo "[?] It couldn't analyze the information of denied hosts, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/hosts_deny.txt "$rutadatos"/system-files/hosts_deny.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Denied hosts has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Denied hosts has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/hosts_deny.txt "$rutadatos"/system-files/hosts_deny.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/rsyslog.txt || ! -f $rutadatos/system-files/rsyslog.txt ]]
        then
            echo "[?] It couldn't analyze the information of rsyslog's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/rsyslog.txt "$rutadatos"/system-files/rsyslog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Rsyslog's configuration has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Rsyslog's configuration has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/rsyslog.txt "$rutadatos"/system-files/rsyslog.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/devices.txt || ! -f $rutadatos/system-files/devices.txt ]]
        then
            echo "[?] It couldn't analyze the information of /proc/devices file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/devices.txt "$rutadatos"/system-files/devices.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] /proc/devices file has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] /proc/devices file has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/devices.txt "$rutadatos"/system-files/devices.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/machine_id.txt || ! -f $rutadatos/system-files/machine_id.txt ]]
        then
            echo "[?] It couldn't analyze the information of machine's ID, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/machine_id.txt "$rutadatos"/system-files/machine_id.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The machine's ID has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] The machine's ID has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/machine_id.txt "$rutadatos"/system-files/machine_id.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/product_uuid.txt || ! -f $rutadatos/system-files/product_uuid.txt ]]
        then
            echo "[?] It couldn't analyze the information of machine's product UUID, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/product_uuid.txt "$rutadatos"/system-files/product_uuid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The machine's product UUID has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] The machine's product UUID has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/product_uuid.txt "$rutadatos"/system-files/product_uuid.txt >> "$rutadatos"/report.txt
        fi
        
        if [[ ! -f $rutauno/system-files/resolv.txt || ! -f $rutadatos/system-files/resolv.txt ]]
        then
            echo "[?] It couldn't analyze the information of resolv.conf file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/resolv.txt "$rutadatos"/system-files/resolv.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Resolv.conf file has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Resolv.conf file has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/resolv.txt "$rutadatos"/system-files/resolv.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's files comparisions done!"
        echo ""
	fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/network || ! -d $rutadatos/network ]]
	then
		echo "${white}[${red}!${white}]${lightblue} Network configuration can't be compared"
		echo ""
	else
		# Comparisions network configurations
        echo "${white}[${red}*${white}]${lightblue} Comparising network configuration..."

        if [[ ! -f $rutauno/network/nmcli.txt || ! -f $rutadatos/network/nmcli.txt ]]
        then
            echo "[?] It couldn't analyze the information of network configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/nmcli.txt "$rutadatos"/network/nmcli.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in network configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in network configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/nmcli.txt "$rutadatos"/network/nmcli.txt >> "$rutadatos"/report.txt
        fi
        
        if [[ ! -f $rutauno/network/netstat.txt || ! -f $rutadatos/network/netstat.txt ]]
        then
            echo "[?] It couldn't analyze the information of connections, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/netstat.txt "$rutadatos"/network/netstat.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in connections" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in connections" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/netstat.txt "$rutadatos"/network/netstat.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/network/dig.txt || ! -f $rutadatos/network/dig.txt ]]
        then
            echo "[?] It couldn't analyze the information of DNS queries, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/dig.txt "$rutadatos"/network/dig.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in DNS queries" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in DNS queries" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/dig.txt "$rutadatos"/network/dig.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/network/route.txt || ! -f $rutadatos/network/route.txt ]]
        then
            echo "[?] It couldn't analyze the information of routing tables, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/route.txt "$rutadatos"/network/route.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in routing tables" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in routing tables" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/route.txt "$rutadatos"/network/route.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/network/arp.txt || ! -f $rutadatos/network/arp.txt ]]
        then
            echo "[?] It couldn't analyze the information of ARP tables, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/arp.txt "$rutadatos"/network/arp.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in ARP tables" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in ARP tables" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/arp.txt "$rutadatos"/network/arp.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Network configuration comparisions done!"
        echo ""
	fi
	
	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/services || ! -d $rutadatos/services ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's services can't be compared"
		echo ""
	else
		# Comparisions system's services
        echo "${white}[${red}*${white}]${lightblue} Comparising system's services..."
        
        if [[ ! -f $rutauno/services/iptables.txt || ! -f $rutadatos/services/iptables.txt ]]
        then
            echo "[?] It couldn't analyze the information of iptable's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/iptables.txt "$rutadatos"/services/iptables.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in iptable's configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in iptable's configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/iptables.txt "$rutadatos"/services/iptables.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/firewalld.txt || ! -f $rutadatos/services/firewalld.txt ]]
        then
            echo "[?] It couldn't analyze the information of firewalld's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/firewalld.txt "$rutadatos"/services/firewalld.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in firewalld's configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in firewalld's configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/firewalld.txt "$rutadatos"/services/firewalld.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/ufw.txt || ! -f $rutadatos/services/ufw.txt ]]
        then
            echo "[?] It couldn't analyze the information of ufw's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/ufw.txt "$rutadatos"/services/ufw.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in ufw's configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in ufw's configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/ufw.txt "$rutadatos"/services/ufw.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/dhcp.txt || ! -f $rutadatos/services/dhcp.txt ]]
        then
            echo "[?] It couldn't analyze the information of DHCP service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/dhcp.txt "$rutadatos"/services/dhcp.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in DHCP service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in DHCP service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/dhcp.txt "$rutadatos"/services/dhcp.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/dns.txt || ! -f $rutadatos/services/dns.txt ]]
        then
            echo "[?] It couldn't analyze the information of DNS service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/dns.txt "$rutadatos"/services/dns.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in DNS service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in DNS service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/dns.txt "$rutadatos"/services/dns.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/vsftpd.txt || ! -f $rutadatos/services/vsftpd.txt ]]
        then
            echo "[?] It couldn't analyze the information of vsftpd service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/vsftpd.txt "$rutadatos"/services/vsftpd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in vsftpd service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in vsftpd service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/vsftpd.txt "$rutadatos"/services/vsftpd.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/samba.txt || ! -f $rutadatos/services/samba.txt ]]
        then
            echo "[?] It couldn't analyze the information of samba service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/samba.txt "$rutadatos"/services/samba.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in samba service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in samba service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/samba.txt "$rutadatos"/services/samba.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/apache.txt || ! -f $rutadatos/services/apache.txt ]]
        then
            echo "[?] It couldn't analyze the information of apache service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/apache.txt "$rutadatos"/services/apache.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in apache service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in apache service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/apache.txt "$rutadatos"/services/apache.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/mariadb.txt || ! -f $rutadatos/services/mariadb.txt ]]
        then
            echo "[?] It couldn't analyze the information of mariadb service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/mariadb.txt "$rutadatos"/services/mariadb.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in mariadb service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in mariadb service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/mariadb.txt "$rutadatos"/services/mariadb.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/squid.txt || ! -f $rutadatos/services/squid.txt ]]
        then
            echo "[?] It couldn't analyze the information of squid service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/squid.txt "$rutadatos"/services/squid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in squid service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in squid service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/squid.txt "$rutadatos"/services/squid.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/ssh.txt || ! -f $rutadatos/services/ssh.txt ]]
        then
            echo "[?] It couldn't analyze the information of SSH service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/ssh.txt "$rutadatos"/services/ssh.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in SSH service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in SSH service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/ssh.txt "$rutadatos"/services/ssh.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/php.txt || ! -f $rutadatos/services/php.txt ]]
        then
            echo "[?] It couldn't analyze the information of PHP configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/php.txt "$rutadatos"/services/php.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in PHP configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in PHP configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/php.txt "$rutadatos"/services/php.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's services comparisions done!"
        echo ""
	fi
	
	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/system-logs || ! -d $rutadatos/system-logs ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's logs can't be compared"
		echo ""
	else
		# Comparisions system's logs
        echo "${white}[${red}*${white}]${lightblue} Comparising system's logs..."

        if [[ ! -f $rutauno/system-logs/auth/logfile_auth_log.txt || ! -f $rutadatos/system-logs/auth/logfile_auth_log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_auth_log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/auth/logfile_auth_log.txt "$rutadatos"/system-logs/auth/logfile_auth_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_auth_log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_auth_log" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/auth/logfile_auth_log.txt "$rutadatos"/system-logs/auth/logfile_auth_log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-logs/dpkg/logfile_dpkg_log.txt || ! -f $rutadatos/system-logs/dpkg/logfile_dpkg_log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_dpkg_log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/dpkg/logfile_dpkg_log.txt "$rutadatos"/system-logs/dpkg/logfile_dpkg_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_dpkg_log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_dpkg:log" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/dpkg/logfile_dpkg_log.txt "$rutadatos"/system-logs/dpkg/logfile_dpkg_log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-logs/syslog/logfile_syslog.txt || ! -f $rutadatos/system-logs/syslog/logfile_syslog.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_syslog, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/syslog/logfile_syslog.txt "$rutadatos"/system-logs/syslog/logfile_syslog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_syslog" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_syslog" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/syslog/logfile_syslog.txt "$rutadatos"/system-logs/syslog/logfile_syslog.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-logs/boot/logfile_boot_log.txt || ! -f $rutadatos/system-logs/boot/logfile_boot_log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_boot_log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/boot/logfile_boot_log.txt "$rutadatos"/system-logs/boot/logfile_boot_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_boot_log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_boot_log" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/boot/logfile_boot_log.txt "$rutadatos"/system-logs/boot/logfile_boot_log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-logs/kern/logfile_kern_log.txt || ! -f $rutadatos/system-logs/kern/logfile_kern_log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_kern_log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/kern/logfile_kern_log.txt "$rutadatos"/system-logs/kern/logfile_kern_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_kern_log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_kern_log" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/kern/logfile_kern_log.txt "$rutadatos"/system-logs/kern/logfile_kern_log.txt >> "$rutadatos"/report.txt
        fi
        
        if [[ ! -f $rutauno/system-logs/lastlog/logfile_lastlog.txt || ! -f $rutadatos/system-logs/lastlog/logfile_lastlog.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_lastlog, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/lastlog/logfile_lastlog.txt "$rutadatos"/system-logs/lastlog/logfile_lastlog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_lastlog" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_lastlog" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/lastlog/logfile_lastlog.txt "$rutadatos"/system-logs/lastlog/logfile_lastlog.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's logs comparisions done!"
        echo ""
	fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/logs-services || ! -d $rutadatos/logs-services ]]
	then
		echo "${white}[${red}!${white}]${lightblue} Service's logs can't be compared"
		echo ""
	else
		# Comparisions service's logs
        echo "${white}[${red}*${white}]${lightblue} Comparising service's logs..."

        if [[ ! -f $rutauno/logs-services/firewalld.txt || ! -f $rutadatos/logs-services/firewalld.txt ]]
        then
            echo "[?] It couldn't analyze the information of firewalld's logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/firewalld.txt "$rutadatos"/logs-services/firewalld.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in firewalld's logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in firewalld's logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/firewalld.txt "$rutadatos"/logs-services/firewalld.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/ufw/logfile_ufw.txt || ! -f $rutadatos/logs-services/ufw/logfile_ufw.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_ufw, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/ufw/logfile_ufw.txt "$rutadatos"/logs-services/ufw/logfile_ufw.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_ufw" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_ufw" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/ufw/logfile_ufw.txt "$rutadatos"/logs-services/ufw/logfile_ufw.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/vsftpd.txt || ! -f $rutadatos/logs-services/vsftpd.txt ]]
        then
            echo "[?] It couldn't analyze the information of vsftpd's logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/vsftpd.txt "$rutadatos"/logs-services/vsftpd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in vsftpd's logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in vsftpd's logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/vsftpd.txt "$rutadatos"/logs-services/vsftpd.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/samba/logfile_log.smbd.txt || ! -f $rutadatos/logs-services/samba/logfile_log.smbd.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_log.smbd, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/samba/logfile_log.smbd.txt "$rutadatos"/logs-services/samba/logfile_log.smbd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_log.smbd" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_log.smbd" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/samba/logfile_log.smbd.txt "$rutadatos"/logs-services/samba/logfile_log.smbd.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/samba/logfile_log.nmbd.txt || ! -f $rutadatos/logs-services/samba/logfile_log.nmbd.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_log.nmbd, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/samba/logfile_log.nmbd.txt "$rutadatos"/logs-services/samba/logfile_log.nmbd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_log.nmbd" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_log.nmbd" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/samba/logfile_log.nmbd.txt "$rutadatos"/logs-services/samba/logfile_log.nmbd.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/apache2/logfile_error.log.txt || ! -f $rutadatos/logs-services/apache2/logfile_error.log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_error.log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/apache2/logfile_error.log.txt "$rutadatos"/logs-services/apache2/logfile_error.log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_error.log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_error.log" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/apache2/logfile_error.log.txt "$rutadatos"/logs-services/apache2/logfile_error.log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/apache2/logfile_access.log.txt || ! -f $rutadatos/logs-services/apache2/logfile_access.log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_access.log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/apache2/logfile_access.log.txt "$rutadatos"/logs-services/apache2/logfile_access.log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_access.log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_access.log" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/apache2/logfile_access.log.txt "$rutadatos"/logs-services/apache2/logfile_access.log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/mariadb.txt || ! -f $rutadatos/logs-services/mariadb.txt ]]
        then
            echo "[?] It couldn't analyze the information of mariadb's logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/mariadb.txt "$rutadatos"/logs-services/mariadb.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in mariadb's logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in mariadb's logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/mariadb.txt "$rutadatos"/logs-services/mariadb.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/access.txt || ! -f $rutadatos/logs-services/access.txt ]]
        then
            echo "[?] It couldn't analyze the information of squid/access' logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/access.txt "$rutadatos"/logs-services/access.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in squid/access' logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in squid/access' logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/access.txt "$rutadatos"/logs-services/access.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/cache.txt || ! -f $rutadatos/logs-services/cache.txt ]]
        then
            echo "[?] It couldn't analyze the information of squid/cache's logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/cache.txt "$rutadatos"/logs-services/cache.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in squid/cache's logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in squid/cache's logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/cache.txt "$rutadatos"/logs-services/cache.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Service's logs comparisions done!"
        echo ""
	fi

}

function comparacionCentOS (){
    # Starting report
	touch "$rutadatos"/report.txt
	date +"Report made the %d/%m/%Y - %T" >> log.txt
	date +"Report made the %d/%m/%Y - %T" >> "$rutadatos"/report.txt
	echo "" >> "$rutadatos"/report.txt
    echo ""
	echo "${white}[${red}*${white}]${lightblue} Starting files comparisions..."

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/system-files || ! -d $rutadatos/system-files ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's files can't be compared"
		echo ""
	else
		# Comparisions system's files
		echo "${white}[${red}*${white}]${lightblue} Comparising system's files..."
		
		if [[ ! -f $rutauno/system-files/kernelsign.txt || ! -f $rutadatos/system-files/kernelsign.txt ]]
        then
            echo "[?] It couldn't analyze the information of kernel, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/kernelsign.txt "$rutadatos"/system-files/kernelsign.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The kernel has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] The kernel has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/kernelsign.txt "$rutadatos"/system-files/kernelsign.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/sudoerssign.txt || ! -f $rutadatos/system-files/sudoerssign.txt ]]
        then
            echo "[?] It couldn't analyze the information of sudoers file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/sudoerssign.txt "$rutadatos"/system-files/sudoerssign.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Sudoers file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Sudoers file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/sudoers.txt "$rutadatos"/system-files/sudoers.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/shadowsign.txt || ! -f $rutadatos/system-files/shadowsign.txt ]]
        then
            echo "[?] It couldn't analyze the information of shadow file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/shadowsign.txt "$rutadatos"/system-files/shadowsign.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Shadow file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Shadow file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/shadow.txt "$rutadatos"/system-files/shadow.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/passwdsign.txt || ! -f $rutadatos/system-files/passwdsign.txt ]]
        then
            echo "[?] It couldn't analyze the information of passwd file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/passwdsign.txt "$rutadatos"/system-files/passwdsign.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Passwd file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Passwd file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/passwdsign.txt "$rutadatos"/system-files/passwdsign.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/root_bash_history.txt || ! -f $rutadatos/system-files/root_bash_history.txt ]]
        then
            echo "[?] It couldn't analyze the information of bash history file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/root_bash_history.txt "$rutadatos"/system-files/root_bash_history.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The bash history has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] The bash history has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/root_bash_history.txt "$rutadatos"/system-files/root_bash_history.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/unamea.txt || ! -f $rutadatos/system-files/unamea.txt ]]
        then
            echo "[?] It couldn't analyze linux system information, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/unamea.txt "$rutadatos"/system-files/unamea.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Linux system information has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Linux system information has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/unamea.txt "$rutadatos"/system-files/unamea.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/unamer.txt || ! -f $rutadatos/system-files/unamer.txt ]]
        then
            echo "[?] It couldn't analyze information about kernel, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/unamer.txt "$rutadatos"/system-files/unamer.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Kernel information has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Kernel information has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/unamer.txt "$rutadatos"/system-files/unamer.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/dpkg.txt || ! -f $rutadatos/system-files/dpkg.txt ]]
        then
            echo "[?] It couldn't analyze the information of dpkg file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/dpkg.txt "$rutadatos"/system-files/dpkg.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't been detected changes on installed packages" >> "$rutadatos"/report.txt
        else
            echo "[!] It has been detected changes on installed packages" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/dpkg.txt "$rutadatos"/system-files/dpkg.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/crontab.txt || ! -f $rutadatos/system-files/crontab.txt ]]
        then
            echo "[?] It couldn't analyze the information of crontab file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/crontab.txt "$rutadatos"/system-files/crontab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Crontab file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Crontab file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/crontab.txt "$rutadatos"/system-files/crontab.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/crontabl.txt || ! -f $rutadatos/system-files/crontabl.txt ]]
        then
            echo "[?] It couldn't analyze the information of Cron's tables, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/crontabl.txt "$rutadatos"/system-files/crontabl.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Cron's tables have not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Cron's tables have been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/crontabl.txt "$rutadatos"/system-files/crontabl.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/grub.txt || ! -f $rutadatos/system-files/grub.txt ]]
        then
            echo "[?] It couldn't analyze the information of GRUB, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/grub.txt "$rutadatos"/system-files/grub.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The GRUB has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] The GRUB has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/grub.txt "$rutadatos"/system-files/grub.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/interfaces.txt || ! -f $rutadatos/system-files/interfaces.txt ]]
        then
            echo "[?] It couldn't analyze the information of interfaces file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/interfaces.txt "$rutadatos"/system-files/interfaces.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Interfaces file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Interfaces file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/interfaces.txt "$rutadatos"/system-files/interfaces.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/profile.txt || ! -f $rutadatos/system-files/profile.txt ]]
        then
            echo "[?] It couldn't analyze the information of profile file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/profile.txt "$rutadatos"/system-files/profile.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Profile file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Profile file has been modified" >> "$rutadatos"/report.txt
            diff
            "$rutauno"/system-files/profile.txt "$rutadatos"/system-files/profile.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/hosts.txt || ! -f $rutadatos/system-files/hosts.txt ]]
        then
            echo "[?] It couldn't analyze the information of hosts file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/hosts.txt "$rutadatos"/system-files/hosts.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Hosts file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Hosts file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/hosts.txt "$rutadatos"/system-files/hosts.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/fstab.txt || ! -f $rutadatos/system-files/fstab.txt ]]
        then
            echo "[?] It couldn't analyze the information of fstab file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/fstab.txt "$rutadatos"/system-files/fstab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Fstab file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Fstab file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/fstab.txt "$rutadatos"/system-files/fstab.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/mtab.txt || ! -f $rutadatos/system-files/mtab.txt ]]
        then
            echo "[?] It couldn't analyze the information of mtab file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/mtab.txt "$rutadatos"/system-files/mtab.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Mtab file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Mtab file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/mtab.txt "$rutadatos"/system-files/mtab.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/group.txt || ! -f $rutadatos/system-files/group.txt ]]
        then
            echo "[?] It couldn't analyze the information of group file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/group.txt "$rutadatos"/system-files/group.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Group file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Group file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/group.txt "$rutadatos"/system-files/group.txt >> "$rutadatos"/report.txt
        fi

        path1=$(ls "$rutauno"/system-files/rc.d/)
        path2=$(ls "$rutadatos"/system-files/rc.d/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/rc.d/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                path3=$(ls "$rutauno"/system-files/rc.d/"$i")
                for x in $path3
                do
                    if [[ ! -f $rutauno/system-files/rc.d/$i/$x || ! -f $rutadatos/system-files/rc.d/$i/$x ]]
                    then
                        echo "[?] It couldn't analyze the information of $i/$x file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                    elif [[ $(cmp "$rutauno"/system-files/rc.d/"$i"/"$x" "$rutadatos"/system-files/rc.d/"$i"/"$x") == "" ]] >> log.txt 2>&1
                    then
                        echo "[*] $i/$x file has not been modified" >> "$rutadatos"/report.txt
                    else
                        echo "[!] $i/$x file has been modified" >> "$rutadatos"/report.txt
                        diff "$rutauno"/system-files/rc.d/"$i"/"$x" "$rutadatos"/system-files/rc.d/"$i"/"$x" >> "$rutadatos"/report.txt
                    fi
                done
            done
        fi

        path1=$(ls "$rutauno"/system-files/init.d/)
        path2=$(ls "$rutadatos"/system-files/init.d/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/init.d/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/init.d/$i || ! -f $rutadatos/system-files/init.d/$i ]]
                then
                    echo "[?] It couldn't analyze the information of init.d/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/init.d/"$i" "$rutadatos"/system-files/init.d/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] init.d/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] init.d/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/init.d/"$i" "$rutadatos"/system-files/init.d/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.d/)
        path2=$(ls "$rutadatos"/system-files/cron.d/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.d/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.d/$i || ! -f $rutadatos/system-files/cron.d/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.d/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.d/"$i" "$rutadatos"/system-files/cron.d/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.d/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.d/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.d/"$i" "$rutadatos"/system-files/cron.d/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.hourly/)
        path2=$(ls "$rutadatos"/system-files/cron.hourly/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.hourly/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.hourly/$i || ! -f $rutadatos/system-files/cron.hourly/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.hourly/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.hourly/"$i" "$rutadatos"/system-files/cron.hourly/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.hourly/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.hourly/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.hourly/"$i" "$rutadatos"/system-files/cron.hourly/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.dialy/)
        path2=$(ls "$rutadatos"/system-files/cron.dialy/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.dialy/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.dialy/$i || ! -f $rutadatos/system-files/cron.dialy/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.dialy/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.dialy/"$i" "$rutadatos"/system-files/cron.dialy/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.dialy/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.dialy/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.dialy/"$i" "$rutadatos"/system-files/cron.dialy/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.weekely/)
        path2=$(ls "$rutadatos"/system-files/cron.weekely/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.weekely/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.weekely/$i || ! -f $rutadatos/system-files/cron.weekely/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.weekely/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.weekely/"$i" "$rutadatos"/system-files/cron.weekely/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.weekely/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.weekely/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.weekely/"$i" "$rutadatos"/system-files/cron.weekely/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        path1=$(ls "$rutauno"/system-files/cron.monthly/)
        path2=$(ls "$rutadatos"/system-files/cron.monthly/)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            echo "[?] It has been detected diffenret files inside of system-files/cron.monthly/" >> "$rutadatos"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$rutadatos"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $rutauno/system-files/cron.monthly/$i || ! -f $rutadatos/system-files/cron.monthly/$i ]]
                then
                    echo "[?] It couldn't analyze the information of cron.monthly/$i file, check Linux's Doctor log" >> "$rutadatos"/report.txt
                elif [[ $(cmp "$rutauno"/system-files/cron.monthly/"$i" "$rutadatos"/system-files/cron.monthly/"$i") == "" ]] >> log.txt 2>&1
                then
                    echo "[*] cron.monthly/$i file has not been modified" >> "$rutadatos"/report.txt
                else
                    echo "[!] cron.monthly/$i file has been modified" >> "$rutadatos"/report.txt
                    diff "$rutauno"/system-files/cron.monthly/"$i" "$rutadatos"/system-files/cron.monthly/"$i" >> "$rutadatos"/report.txt
                fi
            done
        fi

        if [[ ! -f $rutauno/system-files/cmdline.txt || ! -f $rutadatos/system-files/cmdline.txt ]]
        then
            echo "[?] It couldn't analyze the information of cmdline file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/cmdline.txt "$rutadatos"/system-files/cmdline.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Cmdline file has not been modified" >> "$rutadatos"/report.txt
        else
            echo "[!] Cmdline file has been modified" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/cmdline.txt "$rutadatos"/system-files/cmdline.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/blkid.txt || ! -f $rutadatos/system-files/blkid.txt ]]
        then
            echo "[?] It couldn't analyze the information of system's partitions, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/blkid.txt "$rutadatos"/system-files/blkid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] System's partitions have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] System's partitions have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/blkid.txt "$rutadatos"/system-files/blkid.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/lastlog.txt || ! -f $rutadatos/system-files/lastlog.txt ]]
        then
            echo "[?] It couldn't analyze the information of lastlog, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/lastlog.txt "$rutadatos"/system-files/lastlog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected a new login" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected a new login" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/lastlog.txt "$rutadatos"/system-files/lastlog.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/runlevel.txt || ! -f $rutadatos/system-files/runlevel.txt ]]
        then
            echo "[?] It couldn't analyze the information of runlevel, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/runlevel.txt "$rutadatos"/system-files/runlevel.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Runlevel has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Runlevel has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/runlevel.txt "$rutadatos"/system-files/runlevel.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/lspci.txt || ! -f $rutadatos/system-files/lspci.txt ]]
        then
            echo "[?] It couldn't analyze the information of system's devices and buses, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/lspci.txt "$rutadatos"/system-files/lspci.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] System's devices and buses have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] System's devices and buses have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/lspci.txt "$rutadatos"/system-files/lspci.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/fdisk.txt || ! -f $rutadatos/system-files/fdisk.txt ]]
        then
            echo "[?] It couldn't analyze the information of disks or disks' partitions, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/fdisk.txt "$rutadatos"/system-files/fdisk.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Disks or disks' partitions have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Disks or disks' partitions have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/fdisk.txt "$rutadatos"/system-files/fdisk.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/printenv.txt || ! -f $rutadatos/system-files/printenv.txt ]]
        then
            echo "[?] It couldn't analyze the information of system's variables, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/printenv.txt "$rutadatos"/system-files/printenv.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] System's variables have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] System's variables have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/printenv.txt "$rutadatos"/system-files/printenv.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/selinuxconfig.txt || ! -f $rutadatos/system-files/selinuxconfig.txt ]]
        then
            echo "[?] It couldn't analyze the information of selinux's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/selinuxconfig.txt "$rutadatos"/system-files/selinuxconfig.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Selinux's configuration has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Selinux's configuration has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/selinuxconfig.txt "$rutadatos"/system-files/selinuxconfig.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/selinuxsemanage.txt || ! -f $rutadatos/system-files/selinuxsemanage.txt ]]
        then
            echo "[?] It couldn't analyze the information of selinux's politics configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/selinuxsemanage.txt "$rutadatos"/system-files/selinuxsemanage.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Selinux's politics configuration have not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Selinux's politics configuration have changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/selinuxsemanage.txt "$rutadatos"/system-files/selinuxsemanage.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/selinuxstatus.txt || ! -f $rutadatos/system-files/selinuxstatus.txt ]]
        then
            echo "[?] It couldn't analyze the information of sestatus.conf file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/selinuxstatus.txt "$rutadatos"/system-files/selinuxstatus.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Sestatus.conf file has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Sestatus.conf file has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/selinuxstatus.txt "$rutadatos"/system-files/selinuxstatus.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/hosts_allow.txt || ! -f $rutadatos/system-files/hosts_allow.txt ]]
        then
            echo "[?] It couldn't analyze the information of allowed hosts, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/hosts_allow.txt "$rutadatos"/system-files/hosts_allow.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Allowed hosts has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Allowed hosts has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/hosts_allow.txt "$rutadatos"/system-files/hosts_allow.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/hosts_deny.txt || ! -f $rutadatos/system-files/hosts_deny.txt ]]
        then
            echo "[?] It couldn't analyze the information of denied hosts, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/hosts_deny.txt "$rutadatos"/system-files/hosts_deny.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Denied hosts has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Denied hosts has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/hosts_deny.txt "$rutadatos"/system-files/hosts_deny.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/rsyslog.txt || ! -f $rutadatos/system-files/rsyslog.txt ]]
        then
            echo "[?] It couldn't analyze the information of rsyslog's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/rsyslog.txt "$rutadatos"/system-files/rsyslog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Rsyslog's configuration has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Rsyslog's configuration has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/rsyslog.txt "$rutadatos"/system-files/rsyslog.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/devices.txt || ! -f $rutadatos/system-files/devices.txt ]]
        then
            echo "[?] It couldn't analyze the information of /proc/devices file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/devices.txt "$rutadatos"/system-files/devices.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] /proc/devices file has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] /proc/devices file has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/devices.txt "$rutadatos"/system-files/devices.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/machine_id.txt || ! -f $rutadatos/system-files/machine_id.txt ]]
        then
            echo "[?] It couldn't analyze the information of machine's ID, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/machine_id.txt "$rutadatos"/system-files/machine_id.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The machine's ID has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] The machine's ID has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/machine_id.txt "$rutadatos"/system-files/machine_id.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/product_uuid.txt || ! -f $rutadatos/system-files/product_uuid.txt ]]
        then
            echo "[?] It couldn't analyze the information of machine's product UUID, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/product_uuid.txt "$rutadatos"/system-files/product_uuid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] The machine's product UUID has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] The machine's product UUID has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/product_uuid.txt "$rutadatos"/system-files/product_uuid.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-files/resolv.txt || ! -f $rutadatos/system-files/resolv.txt ]]
        then
            echo "[?] It couldn't analyze the information of resolv.conf file, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-files/resolv.txt "$rutadatos"/system-files/resolv.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] Resolv.conf file has not changed" >> "$rutadatos"/report.txt
        else
            echo "[!] Resolv.conf file has changed" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-files/resolv.txt "$rutadatos"/system-files/resolv.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's files comparisions done!"
        echo ""

    fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/network || ! -d $rutadatos/network ]]
	then
		echo "${white}[${red}!${white}]${lightblue} Network configuration can't be compared"
		echo ""
	else
		    # Comparisions network configurations
        echo "${white}[${red}*${white}]${lightblue} Comparising network configuration..."

        if [[ ! -f $rutauno/network/nmcli.txt || ! -f $rutadatos/network/nmcli.txt ]]
        then
            echo "[?] It couldn't analyze the information of network configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/nmcli.txt "$rutadatos"/network/nmcli.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in network configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in network configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/nmcli.txt "$rutadatos"/network/nmcli.txt >> "$rutadatos"/report.txt
        fi
        
        if [[ ! -f $rutauno/network/netstat.txt || ! -f $rutadatos/network/netstat.txt ]]
        then
            echo "[?] It couldn't analyze the information of connections, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/netstat.txt "$rutadatos"/network/netstat.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in connections" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in connections" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/netstat.txt "$rutadatos"/network/netstat.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/network/dig.txt || ! -f $rutadatos/network/dig.txt ]]
        then
            echo "[?] It couldn't analyze the information of DNS queries, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/dig.txt "$rutadatos"/network/dig.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in DNS queries" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in DNS queries" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/dig.txt "$rutadatos"/network/dig.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/network/route.txt || ! -f $rutadatos/network/route.txt ]]
        then
            echo "[?] It couldn't analyze the information of routing tables, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/route.txt "$rutadatos"/network/route.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in routing tables" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in routing tables" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/route.txt "$rutadatos"/network/route.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/network/arp.txt || ! -f $rutadatos/network/arp.txt ]]
        then
            echo "[?] It couldn't analyze the information of ARP tables, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/network/arp.txt "$rutadatos"/network/arp.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in ARP tables" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in ARP tables" >> "$rutadatos"/report.txt
            diff "$rutauno"/network/arp.txt "$rutadatos"/network/arp.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Network configuration comparisions done!"
        echo ""
	fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/services || ! -d $rutadatos/services ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's services can't be compared"
		echo ""
	else
		    # Comparisions system's services
        echo "${white}[${red}*${white}]${lightblue} Comparising system's services..."
        
        if [[ ! -f $rutauno/services/iptables.txt || ! -f $rutadatos/services/iptables.txt ]]
        then
            echo "[?] It couldn't analyze the information of iptables's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/iptables.txt "$rutadatos"/services/iptables.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in iptable's configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in iptable's configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/iptables.txt "$rutadatos"/services/iptables.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/firewalld.txt || ! -f $rutadatos/services/firewalld.txt ]]
        then
            echo "[?] It couldn't analyze the information of firewalld's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/firewalld.txt "$rutadatos"/services/firewalld.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in firewalld's configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in firewalld's configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/firewalld.txt "$rutadatos"/services/firewalld.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/ufw.txt || ! -f $rutadatos/services/ufw.txt ]]
        then
            echo "[?] It couldn't analyze the information of ufw's configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/ufw.txt "$rutadatos"/services/ufw.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in ufw's configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in ufw's configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/ufw.txt "$rutadatos"/services/ufw.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/dhcp.txt || ! -f $rutadatos/services/dhcp.txt ]]
        then
            echo "[?] It couldn't analyze the information of DHCP service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/dhcp.txt "$rutadatos"/services/dhcp.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in DHCP service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in DHCP service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/dhcp.txt "$rutadatos"/services/dhcp.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/dns.txt || ! -f $rutadatos/services/dns.txt ]]
        then
            echo "[?] It couldn't analyze the information of DNS service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/dns.txt "$rutadatos"/services/dns.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in DNS service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in DNS service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/dns.txt "$rutadatos"/services/dns.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/vsftpd.txt || ! -f $rutadatos/services/vsftpd.txt ]]
        then
            echo "[?] It couldn't analyze the information of vsftpd service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/vsftpd.txt "$rutadatos"/services/vsftpd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in vsftpd service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in vsftpd service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/vsftpd.txt "$rutadatos"/services/vsftpd.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/samba.txt || ! -f $rutadatos/services/samba.txt ]]
        then
            echo "[?] It couldn't analyze the information of samba service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/samba.txt "$rutadatos"/services/samba.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in samba service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in samba service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/samba.txt "$rutadatos"/services/samba.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/apache.txt || ! -f $rutadatos/services/apache.txt ]]
        then
            echo "[?] It couldn't analyze the information of apache service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/apache.txt "$rutadatos"/services/apache.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in apache service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in apache service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/apache.txt "$rutadatos"/services/apache.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/mariadb.txt || ! -f $rutadatos/services/mariadb.txt ]]
        then
            echo "[?] It couldn't analyze the information of mariadb service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/mariadb.txt "$rutadatos"/services/mariadb.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in mariadb service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in mariadb service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/mariadb.txt "$rutadatos"/services/mariadb.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/squid.txt || ! -f $rutadatos/services/squid.txt ]]
        then
            echo "[?] It couldn't analyze the information of squid service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/squid.txt "$rutadatos"/services/squid.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in squid service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in squid service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/squid.txt "$rutadatos"/services/squid.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/ssh.txt || ! -f $rutadatos/services/ssh.txt ]]
        then
            echo "[?] It couldn't analyze the information of SSH service configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/ssh.txt "$rutadatos"/services/ssh.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in SSH service configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in SSH service configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/ssh.txt "$rutadatos"/services/ssh.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/services/php.txt || ! -f $rutadatos/services/php.txt ]]
        then
            echo "[?] It couldn't analyze the information of PHP configuration, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/services/php.txt "$rutadatos"/services/php.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in PHP configuration" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in PHP configuration" >> "$rutadatos"/report.txt
            diff "$rutauno"/services/php.txt "$rutadatos"/services/php.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's services comparisions done!"
        echo ""
	fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/system-logs || ! -d $rutadatos/system-logs ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's logs can't be compared"
		echo ""
	else
		# Comparisions system's logs
        echo "${white}[${red}*${white}]${lightblue} Comparising system's logs..."

        if [[ ! -f $rutauno/system-logs/auth/logfile_auth_log.txt || ! -f $rutadatos/system-logs/auth/logfile_auth_log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_auth_log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/auth/logfile_auth_log.txt "$rutadatos"/system-logs/auth/logfile_auth_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_auth_log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_auth_log" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/auth/logfile_auth_log.txt "$rutadatos"/system-logs/auth/logfile_auth_log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-logs/dpkg/logfile_dpkg_log.txt || ! -f $rutadatos/system-logs/dpkg/logfile_dpkg_log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_dpkg_log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/dpkg/logfile_dpkg_log.txt "$rutadatos"/system-logs/dpkg/logfile_dpkg_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_dpkg_log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_dpkg:log" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/dpkg/logfile_dpkg_log.txt "$rutadatos"/system-logs/dpkg/logfile_dpkg_log.txt >> "$rutadatos"/report.txt
        fi
        
        if [[ ! -f $rutauno/system-logs/messages/logfile_messages.txt || ! -f $rutadatos/system-logs/messages/logfile_messages.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_messages, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/messages/logfile_messages.txt "$rutadatos"/system-logs/messages/logfile_messages.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_messages" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_messages" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/messages/logfile_messages.txt "$rutadatos"/system-logs/messages/logfile_messages.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-logs/boot/logfile_boot_log.txt || ! -f $rutadatos/system-logs/boot/logfile_boot_log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_boot_log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/boot/logfile_boot_log.txt "$rutadatos"/system-logs/boot/logfile_boot_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_boot_log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_boot_log" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/boot/logfile_boot_log.txt "$rutadatos"/system-logs/boot/logfile_boot_log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-logs/kern/logfile_kern_log.txt || ! -f $rutadatos/system-logs/kern/logfile_kern_log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_kern_log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/kern/logfile_kern_log.txt "$rutadatos"/system-logs/kern/logfile_kern_log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_kern_log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_kern_log" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/kern/logfile_kern_log.txt "$rutadatos"/system-logs/kern/logfile_kern_log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/system-logs/lastlog/logfile_lastlog.txt || ! -f $rutadatos/system-logs/lastlog/logfile_lastlog.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_lastlog, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/system-logs/lastlog/logfile_lastlog.txt "$rutadatos"/system-logs/lastlog/logfile_lastlog.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_lastlog" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_lastlog" >> "$rutadatos"/report.txt
            diff "$rutauno"/system-logs/lastlog/logfile_lastlog.txt "$rutadatos"/system-logs/lastlog/logfile_lastlog.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's logs comparisions done!"
        echo ""
	fi


	# Check if folders exists. If they exists, compare files
	if [[ ! -d $rutauno/logs-services || ! -d $rutadatos/logs-services ]]
	then
		echo "${white}[${red}!${white}]${lightblue} Service's logs can't be compared"
		echo ""
	else
		# Comparisions service's logs
        echo "${white}[${red}*${white}]${lightblue} Comparising service's logs..."

        if [[ ! -f $rutauno/logs-services/firewalld.txt || ! -f $rutadatos/logs-services/firewalld.txt ]]
        then
            echo "[?] It couldn't analyze the information of firewalld's logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/firewalld.txt "$rutadatos"/logs-services/firewalld.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in firewalld's logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in firewalld's logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/firewalld.txt "$rutadatos"/logs-services/firewalld.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/ufw/logfile_ufw.txt || ! -f $rutadatos/logs-services/ufw/logfile_ufw.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_ufw, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/ufw/logfile_ufw.txt "$rutadatos"/logs-services/ufw/logfile_ufw.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_ufw" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_ufw" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/ufw/logfile_ufw.txt "$rutadatos"/logs-services/ufw/logfile_ufw.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/vsftpd.txt || ! -f $rutadatos/logs-services/vsftpd.txt ]]
        then
            echo "[?] It couldn't analyze the information of vsftpd's logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/vsftpd.txt "$rutadatos"/logs-services/vsftpd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in vsftpd's logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in vsftpd's logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/vsftpd.txt "$rutadatos"/logs-services/vsftpd.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/samba/logfile_log.smbd.txt || ! -f $rutadatos/logs-services/samba/logfile_log.smbd.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_log.smbd, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/samba/logfile_log.smbd.txt "$rutadatos"/logs-services/samba/logfile_log.smbd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_log.smbd" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_log.smbd" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/samba/logfile_log.smbd.txt "$rutadatos"/logs-services/samba/logfile_log.smbd.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/samba/logfile_log.nmbd.txt || ! -f $rutadatos/logs-services/samba/logfile_log.nmbd.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_log.nmbd, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/samba/logfile_log.nmbd.txt "$rutadatos"/logs-services/samba/logfile_log.nmbd.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_log.nmbd" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_log.nmbd" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/samba/logfile_log.nmbd.txt "$rutadatos"/logs-services/samba/logfile_log.nmbd.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/httpd/logfile_error.log.txt || ! -f $rutadatos/logs-services/httpd/logfile_error.log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_error.log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/httpd/logfile_error.log.txt "$rutadatos"/logs-services/httpd/logfile_error.log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_error.log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_error.log" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/httpd/logfile_error.log.txt "$rutadatos"/logs-services/httpd/logfile_error.log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/httpd/logfile_access.log.txt || ! -f $rutadatos/logs-services/httpd/logfile_access.log.txt ]]
        then
            echo "[?] It couldn't analyze the information of logfile_access.log, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/httpd/logfile_access.log.txt "$rutadatos"/logs-services/httpd/logfile_access.log.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in logfile_access.log" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in logfile_access.log" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/httpd/logfile_access.log.txt "$rutadatos"/logs-services/httpd/logfile_access.log.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/mariadb.txt || ! -f $rutadatos/logs-services/mariadb.txt ]]
        then
            echo "[?] It couldn't analyze the information of mariadb's logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/mariadb.txt "$rutadatos"/logs-services/mariadb.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in mariadb's logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in mariadb's logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/mariadb.txt "$rutadatos"/logs-services/mariadb.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/access.txt || ! -f $rutadatos/logs-services/access.txt ]]
        then
            echo "[?] It couldn't analyze the information of squid/access' logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/access.txt "$rutadatos"/logs-services/access.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in squid/access' logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in squid/access' logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/access.txt "$rutadatos"/logs-services/access.txt >> "$rutadatos"/report.txt
        fi

        if [[ ! -f $rutauno/logs-services/cache.txt || ! -f $rutadatos/logs-services/cache.txt ]]
        then
            echo "[?] It couldn't analyze the information of squid/cache's logs, check Linux's Doctor log" >> "$rutadatos"/report.txt
        elif [[ $(cmp "$rutauno"/logs-services/cache.txt "$rutadatos"/logs-services/cache.txt) == "" ]] >> log.txt 2>&1
        then
            echo "[*] It hasn't detected changes in squid/cache's logs" >> "$rutadatos"/report.txt
        else
            echo "[!] It has detected changes in squid/cache's logs" >> "$rutadatos"/report.txt
            diff "$rutauno"/logs-services/cache.txt "$rutadatos"/logs-services/cache.txt >> "$rutadatos"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Service's logs comparisions done!"
        echo ""
	fi

}

function comprobarcomparacion (){
	if [[ ! -f $rutauno/analysis.txt || ! -f $rutadatos/analysis.txt ]]
	then
		while true
		do
			read -r -p "${lightblue}It couldn't detected analysis.txt in any of the specified paths. It couldn't be checked if it could be possible compare evidences in a safe way. ¿Do you want continue?${green} [Y/N]${white} " comprobaranalisis
			if [[ $comprobar == "Y" ]] || [[ $comprobar == "y" ]]
			then
				while true
				do
					read -r -p "${lightblue}¿What is the operating system of the evidences that you want compare?${green} [Debain/Ubuntu/Kali/CentOS]${white} " comprobaranalisis
					case $comprobaranalisis in
					Debian | debian | Ubuntu | ubuntu | Kali | kali)
						comparacion_so="Debian"
					;;
					CentOS | Centos | centos)
						comparacion_so="CentOS"
					;;
					*)
						continue
					esac
					break
				done

				comparacion"$comparacion_so"

			elif [[ $comprobar == "N" ]] || [[ $comprobar == "n" ]]
			then
				exit
			else
				continue
			fi
			break
		done
	else
		if [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') ]]
		then
			while true
			do
				read -r -p "${lightblue}It has been detected different OS${green} ("$(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }')" / "$(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }')").${lightblue} Check that you want compare the evidences specified. ¿Do you want continue?${green} [Y/N]${white} " comprobaranalisis
				if [[ $comprobaranalisis == "Y" ]] || [[ $comprobaranalisis == "y" ]]
				then
					while true
					do
						read -r -p "${lightblue}¿What is the operating system of the evidences that you want compare?${green} [Debain/Ubuntu/Kali/CentOS]${white} " comprobaranalisis
						case $comprobaranalisis in
						Debian | debian | Ubuntu | ubuntu | Kali | kali)
							comparacion_so="Debian"
						;;
						CentOS | Centos | centos)
							comparacion_so="CentOS"
						;;
						*)
							continue
						esac
						break
					done
					break
				elif [[ $comprobaranalisis == "N" ]] || [[ $comprobaranalisis == "n" ]]
				then
					exit
				else
					continue
				fi
				break
			done
		fi

		if [[ $(sed '8q;d' "$rutauno"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') != $(sed '8q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') ]]
		then
			while true
			do
				read -r -p "${lightblue}It has been detected different versions of Linux's Doctor${green} ("$(sed '8q;d' "$rutauno"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }')" / "$(sed '8q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }')").${lightblue} This can provoke that it couldn't be able to do all the comparisions that is expected. ¿Do you want continue?${green} [Y/N]${white} " comprobaranalisis
				if [[ $comprobaranalisis == "Y" ]] || [[ $comprobaranalisis == "y" ]]
				then
					break
				elif [[ $comprobaranalisis == "N" ]] || [[ $comprobaranalisis == "n" ]]
				then
					exit
				else
					continue
				fi
				break
			done
		fi

		if [[ -z $comparacion_so ]]
        then
			if [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]]
			then
				while true
				do
					read -r -p "${lightblue}We detected an unsupported OS${green} ("$(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }')").${lightblue} ¿Do you want continue?${green} [Y/N]${white} " comprobaranalisis
					if [[ $comprobaranalisis == "Y" ]] || [[ $comprobaranalisis == "y" ]]
					then
						break
					elif [[ $comprobaranalisis == "N" ]] || [[ $comprobaranalisis == "n" ]]
					then
						exit
					else
						continue
					fi
					break
				done
			fi

			if [[ $(sed '4q;d' "$rutauno"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$rutadatos"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]]
			then
				comparacion_so="Debian"
			else
				comparacion_so="CentOS"
			fi

			comparacion"$comparacion_so"

		fi
	fi
}
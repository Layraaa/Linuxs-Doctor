#!/bin/bash
# comparision.sh
# Check that system can make comparisions correctly
# and hold functions that make these comparisions

function comparisionsDebian (){
    # Starting report
	touch "$datapath"/report.txt
	date +"Report made the %D - %T" >> /lib/linuxsdoctor/log.txt
	date +"Report made the %D - %T" >> "$datapath"/report.txt
    echo ""
	echo "${white}[${red}*${white}]${lightblue} Starting files comparisions..."
    echo ""

    # Declaring vars for detect unmodified/modified/errors files
    errorssystemsfiles=0
    errorsnetworkconfiguration=0
    errorssystemsservices=0
    errorssystemslogs=0
    errorsserviceslogs=0
    modifiedsystemsfiles=0
    modifiednetworkconfiguration=0
    modifiedsystemsservices=0
    modifiedsystemslogs=0
    modifiedserviceslogs=0
    unmodifiedsystemsfiles=0
    unmodifiednetworkconfiguration=0
    unmodifiedsystemsservices=0
    unmodifiedsystemslogs=0
    unmodifiedserviceslogs=0

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/system-files || ! -d $datapath/system-files ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's files aren't going to be compared, or can't be compared"
		echo ""
        {
            echo ""
            echo "[;] System's files aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions system's files
		echo "${white}[${red}*${white}]${lightblue} Comparising system's files..."
        {
            echo ""
            echo "[@] System's files comparisions:"
            echo ""
        } >> "$datapath"/report.txt


		if [[ ! -f $firstpath/system-files/kernelsign.txt || ! -f $datapath/system-files/kernelsign.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of kernel, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/kernelsign.txt "$datapath"/system-files/kernelsign.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The kernel has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The kernel has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/kernelsign.txt "$datapath"/system-files/kernelsign.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/sudoerssign.txt || ! -f $datapath/system-files/sudoerssign.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of sudoers file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/sudoerssign.txt "$datapath"/system-files/sudoerssign.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Sudoers file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Sudoers file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/sudoers.txt "$datapath"/system-files/sudoers.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/shadowsign.txt || ! -f $datapath/system-files/shadowsign.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of shadow file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/shadowsign.txt "$datapath"/system-files/shadowsign.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Shadow file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Shadow file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/shadow.txt "$datapath"/system-files/shadow.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/passwdsign.txt || ! -f $datapath/system-files/passwdsign.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of passwd file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/passwdsign.txt "$datapath"/system-files/passwdsign.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Passwd file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Passwd file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/passwdsign.txt "$datapath"/system-files/passwdsign.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/root_bash_history.txt || ! -f $datapath/system-files/root_bash_history.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of bash history file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/root_bash_history.txt "$datapath"/system-files/root_bash_history.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The bash history has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The bash history has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/root_bash_history.txt "$datapath"/system-files/root_bash_history.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/unamer.txt || ! -f $datapath/system-files/unamer.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze information about kernel, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/unamer.txt "$datapath"/system-files/unamer.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Kernel information has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Kernel information has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/unamer.txt "$datapath"/system-files/unamer.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/dpkg.txt || ! -f $datapath/system-files/dpkg.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of dpkg file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/dpkg.txt "$datapath"/system-files/dpkg.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] It hasn't been detected changes on installed packages" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] It has been detected changes on installed packages" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/dpkg.txt "$datapath"/system-files/dpkg.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/crontab.txt || ! -f $datapath/system-files/crontab.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of crontab file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/crontab.txt "$datapath"/system-files/crontab.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Crontab file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Crontab file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/crontab.txt "$datapath"/system-files/crontab.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/crontabl.txt || ! -f $datapath/system-files/crontabl.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of Cron's tables, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/crontabl.txt "$datapath"/system-files/crontabl.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Cron's tables have not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Cron's tables have been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/crontabl.txt "$datapath"/system-files/crontabl.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/grub.txt || ! -f $datapath/system-files/grub.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of GRUB, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/grub.txt "$datapath"/system-files/grub.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The GRUB has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The GRUB has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/grub.txt "$datapath"/system-files/grub.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/interfaces.txt || ! -f $datapath/system-files/interfaces.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of interfaces file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/interfaces.txt "$datapath"/system-files/interfaces.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Interfaces file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Interfaces file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/interfaces.txt "$datapath"/system-files/interfaces.txt >> "$datapath"/report.txt
        fi
        
        if [[ ! -f $firstpath/system-files/profile.txt || ! -f $datapath/system-files/profile.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of profile file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/profile.txt "$datapath"/system-files/profile.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Profile file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Profile file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/profile.txt "$datapath"/system-files/profile.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/hosts.txt || ! -f $datapath/system-files/hosts.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of hosts file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/hosts.txt "$datapath"/system-files/hosts.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Hosts file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Hosts file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/hosts.txt "$datapath"/system-files/hosts.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/fstab.txt || ! -f $datapath/system-files/fstab.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of fstab file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/fstab.txt "$datapath"/system-files/fstab.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Fstab file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Fstab file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/fstab.txt "$datapath"/system-files/fstab.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/mtab.txt || ! -f $datapath/system-files/mtab.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of mtab file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/mtab.txt "$datapath"/system-files/mtab.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Mtab file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Mtab file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/mtab.txt "$datapath"/system-files/mtab.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/group.txt || ! -f $datapath/system-files/group.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of group file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/group.txt "$datapath"/system-files/group.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Group file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Group file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/group.txt "$datapath"/system-files/group.txt >> "$datapath"/report.txt
        fi

        path1=$(ls "$firstpath"/system-files/rc.d/ 2>&1)
        path2=$(ls "$datapath"/system-files/rc.d/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/rc.d/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                path3=$(ls "$firstpath"/system-files/rc.d/"$i" 2>&1)
                for x in $path3
                do
                    if [[ ! -f $firstpath/system-files/rc.d/$i/$x || ! -f $datapath/system-files/rc.d/$i/$x ]]
                    then
                        ((errorssystemsfiles++))
                        echo "[?] It couldn't analyze the information of $i/$x file, check Linux's Doctor log" >> "$datapath"/report.txt
                    elif [[ $(cmp "$firstpath"/system-files/rc.d/"$i"/"$x" "$datapath"/system-files/rc.d/"$i"/"$x") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                    then
                        ((unmodifiedsystemsfiles++))
                        echo "[*] $i/$x file has not been modified" >> "$datapath"/report.txt
                    else
                        ((modifiedsystemsfiles++))
                        echo "[!] $i/$x file has been modified" >> "$datapath"/report.txt
                        diff "$firstpath"/system-files/rc.d/"$i"/"$x" "$datapath"/system-files/rc.d/"$i"/"$x" >> "$datapath"/report.txt
                    fi
                done
            done
        fi

        path1=$(ls "$firstpath"/system-files/init.d/ 2>&1)
        path2=$(ls "$datapath"/system-files/init.d/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/init.d/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/init.d/$i || ! -f $datapath/system-files/init.d/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of init.d/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/init.d/"$i" "$datapath"/system-files/init.d/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] init.d/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] init.d/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/init.d/"$i" "$datapath"/system-files/init.d/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.d/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.d/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.d/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.d/$i || ! -f $datapath/system-files/cron.d/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.d/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.d/"$i" "$datapath"/system-files/cron.d/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.d/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.d/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.d/"$i" "$datapath"/system-files/cron.d/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.hourly/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.hourly/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.hourly/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.hourly/$i || ! -f $datapath/system-files/cron.hourly/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.hourly/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.hourly/"$i" "$datapath"/system-files/cron.hourly/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.hourly/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.hourly/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.hourly/"$i" "$datapath"/system-files/cron.hourly/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.daily/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.daily/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.daily/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.daily/$i || ! -f $datapath/system-files/cron.daily/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.daily/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.daily/"$i" "$datapath"/system-files/cron.daily/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.daily/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.daily/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.daily/"$i" "$datapath"/system-files/cron.daily/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.weekly/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.weekly/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.weekly/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.weekly/$i || ! -f $datapath/system-files/cron.weekly/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.weekly/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.weekly/"$i" "$datapath"/system-files/cron.weekly/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.weekly/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.weekly/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.weekly/"$i" "$datapath"/system-files/cron.weekly/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.monthly/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.monthly/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.monthly/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.monthly/$i || ! -f $datapath/system-files/cron.monthly/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.monthly/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.monthly/"$i" "$datapath"/system-files/cron.monthly/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.monthly/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.monthly/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.monthly/"$i" "$datapath"/system-files/cron.monthly/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        if [[ ! -f $firstpath/system-files/cmdline.txt || ! -f $datapath/system-files/cmdline.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of cmdline file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/cmdline.txt "$datapath"/system-files/cmdline.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Cmdline file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Cmdline file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/cmdline.txt "$datapath"/system-files/cmdline.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/blkid.txt || ! -f $datapath/system-files/blkid.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of system's partitions, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/blkid.txt "$datapath"/system-files/blkid.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] System's partitions have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] System's partitions have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/blkid.txt "$datapath"/system-files/blkid.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lastlog.txt || ! -f $datapath/system-files/lastlog.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of lastlog, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lastlog.txt "$datapath"/system-files/lastlog.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] It hasn't detected a new login" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] It has detected a new login" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lastlog.txt "$datapath"/system-files/lastlog.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/runlevel.txt || ! -f $datapath/system-files/runlevel.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of runlevel, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/runlevel.txt "$datapath"/system-files/runlevel.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Runlevel has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Runlevel has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/runlevel.txt "$datapath"/system-files/runlevel.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lspci.txt || ! -f $datapath/system-files/lspci.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of system's devices and buses, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lspci.txt "$datapath"/system-files/lspci.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] System's devices and buses have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] System's devices and buses have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lspci.txt "$datapath"/system-files/lspci.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/fdisk.txt || ! -f $datapath/system-files/fdisk.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of disks or disks' partitions, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/fdisk.txt "$datapath"/system-files/fdisk.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Disks or disks' partitions have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Disks or disks' partitions have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/fdisk.txt "$datapath"/system-files/fdisk.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/printenv.txt || ! -f $datapath/system-files/printenv.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of system's variables, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/printenv.txt "$datapath"/system-files/printenv.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] System's variables have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] System's variables have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/printenv.txt "$datapath"/system-files/printenv.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/selinuxconfig.txt || ! -f $datapath/system-files/selinuxconfig.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of selinux's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/selinuxconfig.txt "$datapath"/system-files/selinuxconfig.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Selinux's configuration has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Selinux's configuration has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/selinuxconfig.txt "$datapath"/system-files/selinuxconfig.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/selinuxsemanage.txt || ! -f $datapath/system-files/selinuxsemanage.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of selinux's politics configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/selinuxsemanage.txt "$datapath"/system-files/selinuxsemanage.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Selinux's politics configuration have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Selinux's politics configuration have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/selinuxsemanage.txt "$datapath"/system-files/selinuxsemanage.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/selinuxstatus.txt || ! -f $datapath/system-files/selinuxstatus.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of sestatus.conf file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/selinuxstatus.txt "$datapath"/system-files/selinuxstatus.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Sestatus.conf file has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Sestatus.conf file has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/selinuxstatus.txt "$datapath"/system-files/selinuxstatus.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/hosts_allow.txt || ! -f $datapath/system-files/hosts_allow.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of allowed hosts, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/hosts_allow.txt "$datapath"/system-files/hosts_allow.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Allowed hosts has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Allowed hosts has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/hosts_allow.txt "$datapath"/system-files/hosts_allow.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/hosts_deny.txt || ! -f $datapath/system-files/hosts_deny.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of denied hosts, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/hosts_deny.txt "$datapath"/system-files/hosts_deny.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Denied hosts has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Denied hosts has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/hosts_deny.txt "$datapath"/system-files/hosts_deny.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/rsyslog.txt || ! -f $datapath/system-files/rsyslog.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of rsyslog's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/rsyslog.txt "$datapath"/system-files/rsyslog.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Rsyslog's configuration has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Rsyslog's configuration has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/rsyslog.txt "$datapath"/system-files/rsyslog.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/devices.txt || ! -f $datapath/system-files/devices.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of /proc/devices file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/devices.txt "$datapath"/system-files/devices.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] /proc/devices file has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] /proc/devices file has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/devices.txt "$datapath"/system-files/devices.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/machine_id.txt || ! -f $datapath/system-files/machine_id.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of machine's ID, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/machine_id.txt "$datapath"/system-files/machine_id.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The machine's ID has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The machine's ID has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/machine_id.txt "$datapath"/system-files/machine_id.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/product_uuid.txt || ! -f $datapath/system-files/product_uuid.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of machine's product UUID, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/product_uuid.txt "$datapath"/system-files/product_uuid.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The machine's product UUID has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The machine's product UUID has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/product_uuid.txt "$datapath"/system-files/product_uuid.txt >> "$datapath"/report.txt
        fi
        
        if [[ ! -f $firstpath/system-files/resolv.txt || ! -f $datapath/system-files/resolv.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of resolv.conf file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/resolv.txt "$datapath"/system-files/resolv.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Resolv.conf file has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Resolv.conf file has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/resolv.txt "$datapath"/system-files/resolv.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lsblk.txt || ! -f $datapath/system-files/lsblk.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of block devices, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lsblk.txt "$datapath"/system-files/lsblk.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Block devices have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Block devices have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lsblk.txt "$datapath"/system-files/lsblk.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lspci.txt || ! -f $datapath/system-files/lspci.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of PCI devices, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lspci.txt "$datapath"/system-files/lspci.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] PCI devices have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] PCI devices have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lspci.txt "$datapath"/system-files/lspci.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lsusb.txt || ! -f $datapath/system-files/lsusb.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of USB devices, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lsusb.txt "$datapath"/system-files/lsusb.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] USB devices have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] USB devices have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lsusb.txt "$datapath"/system-files/lsusb.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lsscsi.txt || ! -f $datapath/system-files/lsscsi.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of SCSI devices, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lsscsi.txt "$datapath"/system-files/lsscsi.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] SCSI devices have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] SCSI devices have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lsscsi.txt "$datapath"/system-files/lsscsi.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lscpu.txt || ! -f $datapath/system-files/lscpu.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of CPU, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lscpu.txt "$datapath"/system-files/lscpu.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Information of CPU has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Information of CPU has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lscpu.txt "$datapath"/system-files/lscpu.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/dmidecode.txt || ! -f $datapath/system-files/dmidecode.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of system's hardware, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/dmidecode.txt "$datapath"/system-files/dmidecode.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Information of system's hardware has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Information of system's hardware has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/dmidecode.txt "$datapath"/system-files/dmidecode.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's files comparisions done!"
        echo ""
	fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/network || ! -d $datapath/network ]]
	then
		echo "${white}[${red}!${white}]${lightblue} Network configuration can't be compared"
		echo ""
        {
            echo ""
            echo "[;] Network configuration aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions network configurations
        echo "${white}[${red}*${white}]${lightblue} Comparising network configuration..."

        {
            echo "" 
            echo "[@] Network configuration comparisions:"
            echo ""
        } >> "$datapath"/report.txt
        

        if [[ ! -f $firstpath/network/nmcli.txt || ! -f $datapath/network/nmcli.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of network configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/nmcli.txt "$datapath"/network/nmcli.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in network configuration" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in network configuration" >> "$datapath"/report.txt
            diff "$firstpath"/network/nmcli.txt "$datapath"/network/nmcli.txt >> "$datapath"/report.txt
        fi
        
        if [[ ! -f $firstpath/network/netstat.txt || ! -f $datapath/network/netstat.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of connections, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/netstat.txt "$datapath"/network/netstat.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in connections" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in connections" >> "$datapath"/report.txt
            diff "$firstpath"/network/netstat.txt "$datapath"/network/netstat.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/network/dig.txt || ! -f $datapath/network/dig.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of DNS queries, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/dig.txt "$datapath"/network/dig.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in DNS queries" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in DNS queries" >> "$datapath"/report.txt
            diff "$firstpath"/network/dig.txt "$datapath"/network/dig.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/network/route.txt || ! -f $datapath/network/route.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of routing tables, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/route.txt "$datapath"/network/route.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in routing tables" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in routing tables" >> "$datapath"/report.txt
            diff "$firstpath"/network/route.txt "$datapath"/network/route.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/network/arp.txt || ! -f $datapath/network/arp.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of ARP tables, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/arp.txt "$datapath"/network/arp.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in ARP tables" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in ARP tables" >> "$datapath"/report.txt
            diff "$firstpath"/network/arp.txt "$datapath"/network/arp.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/network/ethtool.txt || ! -f $datapath/network/ethtool.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of interfaces' configurations, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/ethtool.txt "$datapath"/network/ethtool.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes of interfaces' configurations" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes of interfaces' configurations" >> "$datapath"/report.txt
            diff "$firstpath"/network/ethtool.txt "$datapath"/network/ethtool.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Network configuration comparisions done!"
        echo ""
	fi
	
	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/services || ! -d $datapath/services ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's services can't be compared"
		echo ""
        {
            echo ""
            echo "[;] System's services aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions system's services
        echo "${white}[${red}*${white}]${lightblue} Comparising system's services..."

        {
            echo ""
            echo "[@] System's services comparisions:"
            echo ""
        } >> "$datapath"/report.txt
        
        
        if [[ ! -f $firstpath/services/iptables.txt || ! -f $datapath/services/iptables.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of iptable's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/iptables.txt "$datapath"/services/iptables.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in iptable's configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in iptable's configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/iptables.txt "$datapath"/services/iptables.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/firewalld.txt || ! -f $datapath/services/firewalld.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of firewalld's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/firewalld.txt "$datapath"/services/firewalld.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in firewalld's configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in firewalld's configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/firewalld.txt "$datapath"/services/firewalld.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/ufw.txt || ! -f $datapath/services/ufw.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of ufw's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/ufw.txt "$datapath"/services/ufw.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in ufw's configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in ufw's configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/ufw.txt "$datapath"/services/ufw.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/dhcp.txt || ! -f $datapath/services/dhcp.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of DHCP service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/dhcp.txt "$datapath"/services/dhcp.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in DHCP service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in DHCP service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/dhcp.txt "$datapath"/services/dhcp.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/dns.txt || ! -f $datapath/services/dns.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of DNS service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/dns.txt "$datapath"/services/dns.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in DNS service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in DNS service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/dns.txt "$datapath"/services/dns.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/vsftpd.txt || ! -f $datapath/services/vsftpd.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of vsftpd service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/vsftpd.txt "$datapath"/services/vsftpd.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in vsftpd service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in vsftpd service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/vsftpd.txt "$datapath"/services/vsftpd.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/samba.txt || ! -f $datapath/services/samba.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of samba service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/samba.txt "$datapath"/services/samba.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in samba service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in samba service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/samba.txt "$datapath"/services/samba.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/apache.txt || ! -f $datapath/services/apache.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of apache service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/apache.txt "$datapath"/services/apache.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in apache service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in apache service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/apache.txt "$datapath"/services/apache.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/mariadb.txt || ! -f $datapath/services/mariadb.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of mariadb service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/mariadb.txt "$datapath"/services/mariadb.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in mariadb service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in mariadb service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/mariadb.txt "$datapath"/services/mariadb.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/squid.txt || ! -f $datapath/services/squid.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of squid service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/squid.txt "$datapath"/services/squid.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in squid service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in squid service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/squid.txt "$datapath"/services/squid.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/ssh.txt || ! -f $datapath/services/ssh.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of SSH service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/ssh.txt "$datapath"/services/ssh.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in SSH service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in SSH service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/ssh.txt "$datapath"/services/ssh.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/php.txt || ! -f $datapath/services/php.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of PHP configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/php.txt "$datapath"/services/php.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in PHP configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in PHP configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/php.txt "$datapath"/services/php.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's services comparisions done!"
        echo ""
	fi
	
	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/system-logs || ! -d $datapath/system-logs ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's logs can't be compared"
		echo ""
        {
            echo ""
            echo "[;] System's logs aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions system's logs
        echo "${white}[${red}*${white}]${lightblue} Comparising system's logs..."
        {
            echo ""
            echo "[@] System's logs comparisions:"
            echo ""
        } >> "$datapath"/report.txt

        if [[ ! -f $firstpath/system-logs/auth/logfile_auth_log.txt || ! -f $datapath/system-logs/auth/logfile_auth_log.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_auth_log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/auth/logfile_auth_log.txt "$datapath"/system-logs/auth/logfile_auth_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_auth_log" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_auth_log" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/auth/logfile_auth_log.txt "$datapath"/system-logs/auth/logfile_auth_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-logs/dpkg/logfile_dpkg_log.txt || ! -f $datapath/system-logs/dpkg/logfile_dpkg_log.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_dpkg_log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/dpkg/logfile_dpkg_log.txt "$datapath"/system-logs/dpkg/logfile_dpkg_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_dpkg_log" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_dpkg:log" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/dpkg/logfile_dpkg_log.txt "$datapath"/system-logs/dpkg/logfile_dpkg_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-logs/syslog/logfile_syslog.txt || ! -f $datapath/system-logs/syslog/logfile_syslog.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_syslog, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/syslog/logfile_syslog.txt "$datapath"/system-logs/syslog/logfile_syslog.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_syslog" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_syslog" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/syslog/logfile_syslog.txt "$datapath"/system-logs/syslog/logfile_syslog.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-logs/boot/logfile_boot_log.txt || ! -f $datapath/system-logs/boot/logfile_boot_log.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_boot_log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/boot/logfile_boot_log.txt "$datapath"/system-logs/boot/logfile_boot_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_boot_log" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_boot_log" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/boot/logfile_boot_log.txt "$datapath"/system-logs/boot/logfile_boot_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-logs/kern/logfile_kern_log.txt || ! -f $datapath/system-logs/kern/logfile_kern_log.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_kern_log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/kern/logfile_kern_log.txt "$datapath"/system-logs/kern/logfile_kern_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_kern_log" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_kern_log" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/kern/logfile_kern_log.txt "$datapath"/system-logs/kern/logfile_kern_log.txt >> "$datapath"/report.txt
        fi
        
        if [[ ! -f $firstpath/system-logs/lastlog/logfile_lastlog.txt || ! -f $datapath/system-logs/lastlog/logfile_lastlog.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_lastlog, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/lastlog/logfile_lastlog.txt "$datapath"/system-logs/lastlog/logfile_lastlog.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_lastlog" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_lastlog" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/lastlog/logfile_lastlog.txt "$datapath"/system-logs/lastlog/logfile_lastlog.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's logs comparisions done!"
        echo ""
	fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/logs-services || ! -d $datapath/logs-services ]]
	then
		echo "${white}[${red}!${white}]${lightblue} Services' logs can't be compared"
		echo ""
        {
            echo ""
            echo "[;] Services' logs aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions services' logs
        echo "${white}[${red}*${white}]${lightblue} Comparising services' logs..."
        {
            echo ""
            echo "[@] Services' logs comparisions:"
            echo ""
        } >> "$datapath"/report.txt

        if [[ ! -f $firstpath/logs-services/firewalld.txt || ! -f $datapath/logs-services/firewalld.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of firewalld's logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/firewalld.txt "$datapath"/logs-services/firewalld.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in firewalld's logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in firewalld's logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/firewalld.txt "$datapath"/logs-services/firewalld.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/ufw/logfile_ufw.txt || ! -f $datapath/logs-services/ufw/logfile_ufw.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_ufw, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/ufw/logfile_ufw.txt "$datapath"/logs-services/ufw/logfile_ufw.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_ufw" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_ufw" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/ufw/logfile_ufw.txt "$datapath"/logs-services/ufw/logfile_ufw.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/vsftpd.txt || ! -f $datapath/logs-services/vsftpd.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of vsftpd's logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/vsftpd.txt "$datapath"/logs-services/vsftpd.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in vsftpd's logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in vsftpd's logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/vsftpd.txt "$datapath"/logs-services/vsftpd.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/samba/logfile_log.smbd.txt || ! -f $datapath/logs-services/samba/logfile_log.smbd.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_log.smbd, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/samba/logfile_log.smbd.txt "$datapath"/logs-services/samba/logfile_log.smbd.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_log.smbd" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_log.smbd" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/samba/logfile_log.smbd.txt "$datapath"/logs-services/samba/logfile_log.smbd.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/samba/logfile_log.nmbd.txt || ! -f $datapath/logs-services/samba/logfile_log.nmbd.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_log.nmbd, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/samba/logfile_log.nmbd.txt "$datapath"/logs-services/samba/logfile_log.nmbd.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_log.nmbd" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_log.nmbd" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/samba/logfile_log.nmbd.txt "$datapath"/logs-services/samba/logfile_log.nmbd.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/apache2/logfile_error_log.txt || ! -f $datapath/logs-services/apache2/logfile_error_log.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_error.log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/apache2/logfile_error_log.txt "$datapath"/logs-services/apache2/logfile_error_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_error.log" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_error.log" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/apache2/logfile_error_log.txt "$datapath"/logs-services/apache2/logfile_error_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/apache2/logfile_access_log.txt || ! -f $datapath/logs-services/apache2/logfile_access_log.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_access.log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/apache2/logfile_access_log.txt "$datapath"/logs-services/apache2/logfile_access_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_access.log" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_access.log" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/apache2/logfile_access_log.txt "$datapath"/logs-services/apache2/logfile_access_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/mariadb.txt || ! -f $datapath/logs-services/mariadb.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of mariadb's logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/mariadb.txt "$datapath"/logs-services/mariadb.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in mariadb's logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in mariadb's logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/mariadb.txt "$datapath"/logs-services/mariadb.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/access.txt || ! -f $datapath/logs-services/access.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of squid/access' logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/access.txt "$datapath"/logs-services/access.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in squid/access' logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in squid/access' logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/access.txt "$datapath"/logs-services/access.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/cache.txt || ! -f $datapath/logs-services/cache.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of squid/cache's logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/cache.txt "$datapath"/logs-services/cache.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in squid/cache's logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in squid/cache's logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/cache.txt "$datapath"/logs-services/cache.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Services' logs comparisions done!"
        echo ""
	fi

    # Write summary of comparisions if it has been detected that they were selected

    echo "${white}Summary:"
    echo ""
    
    if [[ $errorssystemsfiles != "0" ]] || [[ $modifiedsystemsfiles != "0" ]] || [[ $unmodifiedsystemsfiles != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of system's files: ${white}$errorssystemsfiles"
        echo "${lightblue}Modified in system's files: ${white}$modifiedsystemsfiles"
        echo "${lightblue}Unmodified system's files: ${white}$unmodifiedsystemsfiles"
        echo ""
    fi

    if [[ $errorsnetworkconfiguration != "0" ]] || [[ $modifiednetworkconfiguration != "0" ]] || [[ $unmodifiednetworkconfiguration != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of network configuration: ${white}$errorsnetworkconfiguration"
        echo "${lightblue}Modified network configuration: ${white}$modifiednetworkconfiguration"
        echo "${lightblue}Unmodified network configuration: ${white}$unmodifiednetworkconfiguration"
        echo ""
    fi

    if [[ $errorssystemsservices != "0" ]] || [[ $modifiedsystemsservices != "0" ]] || [[ $unmodifiedsystemsservices != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of system's services: ${white}$errorssystemsservices"
        echo "${lightblue}Modified system's services: ${white}$modifiedsystemsservices"
        echo "${lightblue}Unmodified system's services: ${white}$unmodifiedsystemsservices"
        echo ""
    fi

    if [[ $errorssystemslogs != "0" ]] || [[ $modifiedsystemslogs != "0" ]] || [[ $unmodifiedsystemslogs != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of system's logs: ${white}$errorssystemslogs"
        echo "${lightblue}Modified system's logs: ${white}$modifiedsystemslogs"
        echo "${lightblue}Unmodified system's logs: ${white}$unmodifiedsystemslogs"
        echo ""
    fi
    
    if [[ $errorsserviceslogs != "0" ]] || [[ $modifiedserviceslogs != "0" ]] || [[ $unmodifiedserviceslogs != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of services' logs: ${white}$errorsserviceslogs"
        echo "${lightblue}Modified services' logs: ${white}$modifiedserviceslogs"
        echo "${lightblue}Unmodified services' logs: ${white}$unmodifiedserviceslogs"
        echo ""
    fi

    {
        echo ""
        echo "Summary:"

        if [[ $errorssystemsfiles != "0" ]] || [[ $modifiedsystemsfiles != "0" ]] || [[ $unmodifiedsystemsfiles != "0" ]]
        then
            echo "Errors in comparisions of system's files: $errorssystemsfiles"
            echo "Modified in system's files: $modifiedsystemsfiles"
            echo "Unmodified system's files: $unmodifiedsystemsfiles"
            echo ""
        fi

        if [[ $errorsnetworkconfiguration != "0" ]] || [[ $modifiednetworkconfiguration != "0" ]] || [[ $unmodifiednetworkconfiguration != "0" ]]
        then
            echo "Errors in comparisions of network configuration: $errorsnetworkconfiguration"
            echo "Modified network configuration: $modifiednetworkconfiguration"
            echo "Unmodified network configuration: $unmodifiednetworkconfiguration"
            echo ""
        fi

        if [[ $errorssystemsservices != "0" ]] || [[ $modifiedsystemsservices != "0" ]] || [[ $unmodifiedsystemsservices != "0" ]]
        then
            echo "Errors in comparisions of system's services: $errorssystemsservices"
            echo "Modified system's services: $modifiedsystemsservices"
            echo "Unmodified system's services: $unmodifiedsystemsservices"
            echo ""
        fi

        if [[ $errorssystemslogs != "0" ]] || [[ $modifiedsystemslogs != "0" ]] || [[ $unmodifiedsystemslogs != "0" ]]
        then
            echo "Errors in comparisions of system's logs: $errorssystemslogs"
            echo "Modified system's logs: $modifiedsystemslogs"
            echo "Unmodified system's logs: $unmodifiedsystemslogs"
            echo ""
        fi
        
        if [[ $errorsserviceslogs != "0" ]] || [[ $modifiedserviceslogs != "0" ]] || [[ $unmodifiedserviceslogs != "0" ]]
        then
            echo "Errors in comparisions of services' logs: $errorsserviceslogs"
            echo "Modified services' logs: $modifiedserviceslogs"
            echo "Unmodified services' logs: $unmodifiedserviceslogs"
            echo ""
        fi

    } >> "$datapath"/report.txt  
    
    # Check if user want generate an HTML report
    if [ "$htmlreport" == "Y" ]
    then
        echo "${white}[${red}*${white}]${lightblue} Generating HTML report..."
        touch "$datapath"/report-"$date".html
        source /lib/linuxsdoctor/generatehtml.sh
        generatehtml
        if [ "$?" -eq 0 ]
        then
            echo "${white}[${green}!${white}]${lightblue} Complete!"
        else
            echo "${red}Something went wrong"
        fi
        echo "${white}"
    fi

}

function comparisionsCentOS (){
    # Starting report
	touch "$datapath"/report.txt
	date +"Report made the %D - %T" >> /lib/linuxsdoctor/log.txt
	date +"Report made the %D - %T" >> "$datapath"/report.txt
    echo ""
	echo "${white}[${red}*${white}]${lightblue} Starting files comparisions..."
    echo ""

    errorssystemsfiles=0
    errorsnetworkconfiguration=0
    errorssystemsservices=0
    errorssystemslogs=0
    errorsserviceslogs=0   
    modifiedsystemsfiles=0
    modifiednetworkconfiguration=0
    modifiedsystemsservices=0
    modifiedsystemslogs=0
    modifiedserviceslogs=0
    unmodifiedsystemsfiles=0
    unmodifiednetworkconfiguration=0
    unmodifiedsystemsservices=0
    unmodifiedsystemslogs=0
    unmodifiedserviceslogs=0

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/system-files || ! -d $datapath/system-files ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's files aren't going to be compared, or can't be compared"
		echo ""
        {
            echo ""
            echo "[;] System's files aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions system's files
		echo "${white}[${red}*${white}]${lightblue} Comparising system's files..."

        {
            echo ""
            echo "[@] System's files comparisions:"
            echo ""
        } >> "$datapath"/report.txt
		
		if [[ ! -f $firstpath/system-files/kernelsign.txt || ! -f $datapath/system-files/kernelsign.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of kernel, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/kernelsign.txt "$datapath"/system-files/kernelsign.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The kernel has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The kernel has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/kernelsign.txt "$datapath"/system-files/kernelsign.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/sudoerssign.txt || ! -f $datapath/system-files/sudoerssign.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of sudoers file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/sudoerssign.txt "$datapath"/system-files/sudoerssign.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Sudoers file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Sudoers file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/sudoers.txt "$datapath"/system-files/sudoers.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/shadowsign.txt || ! -f $datapath/system-files/shadowsign.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of shadow file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/shadowsign.txt "$datapath"/system-files/shadowsign.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Shadow file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Shadow file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/shadow.txt "$datapath"/system-files/shadow.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/passwdsign.txt || ! -f $datapath/system-files/passwdsign.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of passwd file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/passwdsign.txt "$datapath"/system-files/passwdsign.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Passwd file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Passwd file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/passwdsign.txt "$datapath"/system-files/passwdsign.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/root_bash_history.txt || ! -f $datapath/system-files/root_bash_history.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of bash history file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/root_bash_history.txt "$datapath"/system-files/root_bash_history.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The bash history has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The bash history has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/root_bash_history.txt "$datapath"/system-files/root_bash_history.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/unamer.txt || ! -f $datapath/system-files/unamer.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze information about kernel, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/unamer.txt "$datapath"/system-files/unamer.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Kernel information has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Kernel information has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/unamer.txt "$datapath"/system-files/unamer.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/dpkg.txt || ! -f $datapath/system-files/dpkg.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of dpkg file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/dpkg.txt "$datapath"/system-files/dpkg.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] It hasn't been detected changes on installed packages" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] It has been detected changes on installed packages" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/dpkg.txt "$datapath"/system-files/dpkg.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/crontab.txt || ! -f $datapath/system-files/crontab.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of crontab file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/crontab.txt "$datapath"/system-files/crontab.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Crontab file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Crontab file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/crontab.txt "$datapath"/system-files/crontab.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/crontabl.txt || ! -f $datapath/system-files/crontabl.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of Cron's tables, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/crontabl.txt "$datapath"/system-files/crontabl.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Cron's tables have not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Cron's tables have been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/crontabl.txt "$datapath"/system-files/crontabl.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/grub.txt || ! -f $datapath/system-files/grub.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of GRUB, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/grub.txt "$datapath"/system-files/grub.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The GRUB has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The GRUB has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/grub.txt "$datapath"/system-files/grub.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/interfaces.txt || ! -f $datapath/system-files/interfaces.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of interfaces file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/interfaces.txt "$datapath"/system-files/interfaces.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Interfaces file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Interfaces file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/interfaces.txt "$datapath"/system-files/interfaces.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/profile.txt || ! -f $datapath/system-files/profile.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of profile file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/profile.txt "$datapath"/system-files/profile.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Profile file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Profile file has been modified" >> "$datapath"/report.txt
            diff
            "$firstpath"/system-files/profile.txt "$datapath"/system-files/profile.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/hosts.txt || ! -f $datapath/system-files/hosts.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of hosts file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/hosts.txt "$datapath"/system-files/hosts.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Hosts file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Hosts file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/hosts.txt "$datapath"/system-files/hosts.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/fstab.txt || ! -f $datapath/system-files/fstab.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of fstab file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/fstab.txt "$datapath"/system-files/fstab.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Fstab file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Fstab file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/fstab.txt "$datapath"/system-files/fstab.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/mtab.txt || ! -f $datapath/system-files/mtab.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of mtab file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/mtab.txt "$datapath"/system-files/mtab.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Mtab file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Mtab file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/mtab.txt "$datapath"/system-files/mtab.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/group.txt || ! -f $datapath/system-files/group.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of group file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/group.txt "$datapath"/system-files/group.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Group file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Group file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/group.txt "$datapath"/system-files/group.txt >> "$datapath"/report.txt
        fi

        path1=$(ls "$firstpath"/system-files/rc.d/ 2>&1)
        path2=$(ls "$datapath"/system-files/rc.d/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/rc.d/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                path3=$(ls "$firstpath"/system-files/rc.d/"$i" 2>&1)
                for x in $path3
                do
                    if [[ ! -f $firstpath/system-files/rc.d/$i/$x || ! -f $datapath/system-files/rc.d/$i/$x ]]
                    then
                        ((errorssystemsfiles++))
                        echo "[?] It couldn't analyze the information of $i/$x file, check Linux's Doctor log" >> "$datapath"/report.txt
                    elif [[ $(cmp "$firstpath"/system-files/rc.d/"$i"/"$x" "$datapath"/system-files/rc.d/"$i"/"$x") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                    then
                        ((unmodifiedsystemsfiles++))
                        echo "[*] $i/$x file has not been modified" >> "$datapath"/report.txt
                    else
                        ((modifiedsystemsfiles++))
                        echo "[!] $i/$x file has been modified" >> "$datapath"/report.txt
                        diff "$firstpath"/system-files/rc.d/"$i"/"$x" "$datapath"/system-files/rc.d/"$i"/"$x" >> "$datapath"/report.txt
                    fi
                done
            done
        fi

        path1=$(ls "$firstpath"/system-files/init.d/ 2>&1)
        path2=$(ls "$datapath"/system-files/init.d/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/init.d/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/init.d/$i || ! -f $datapath/system-files/init.d/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of init.d/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/init.d/"$i" "$datapath"/system-files/init.d/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] init.d/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] init.d/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/init.d/"$i" "$datapath"/system-files/init.d/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.d/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.d/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.d/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.d/$i || ! -f $datapath/system-files/cron.d/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.d/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.d/"$i" "$datapath"/system-files/cron.d/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.d/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.d/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.d/"$i" "$datapath"/system-files/cron.d/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.hourly/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.hourly/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.hourly/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.hourly/$i || ! -f $datapath/system-files/cron.hourly/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.hourly/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.hourly/"$i" "$datapath"/system-files/cron.hourly/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.hourly/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.hourly/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.hourly/"$i" "$datapath"/system-files/cron.hourly/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.daily/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.daily/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.daily/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.daily/$i || ! -f $datapath/system-files/cron.daily/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.daily/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.daily/"$i" "$datapath"/system-files/cron.daily/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.daily/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.daily/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.daily/"$i" "$datapath"/system-files/cron.daily/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.weekly/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.weekly/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.weekly/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.weekly/$i || ! -f $datapath/system-files/cron.weekly/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.weekly/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.weekly/"$i" "$datapath"/system-files/cron.weekly/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.weekly/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.weekly/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.weekly/"$i" "$datapath"/system-files/cron.weekly/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        path1=$(ls "$firstpath"/system-files/cron.monthly/ 2>&1)
        path2=$(ls "$datapath"/system-files/cron.monthly/ 2>&1)
        if [ "$(echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u)" != "" ]
        then
            ((errorssystemsfiles++))
            echo "[!] It has been detected different files inside of system-files/cron.monthly/" >> "$datapath"/report.txt
            echo "${path1[@]}" "${path2[@]}" | tr ' ' '\n' | sort | uniq -u >> "$datapath"/report.txt
        else
            for i in $path1
            do
                if [[ ! -f $firstpath/system-files/cron.monthly/$i || ! -f $datapath/system-files/cron.monthly/$i ]]
                then
                    ((errorssystemsfiles++))
                    echo "[?] It couldn't analyze the information of cron.monthly/$i file, check Linux's Doctor log" >> "$datapath"/report.txt
                elif [[ $(cmp "$firstpath"/system-files/cron.monthly/"$i" "$datapath"/system-files/cron.monthly/"$i") == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
                then
                    ((unmodifiedsystemsfiles++))
                    echo "[*] cron.monthly/$i file has not been modified" >> "$datapath"/report.txt
                else
                    ((modifiedsystemsfiles++))
                    echo "[!] cron.monthly/$i file has been modified" >> "$datapath"/report.txt
                    diff "$firstpath"/system-files/cron.monthly/"$i" "$datapath"/system-files/cron.monthly/"$i" >> "$datapath"/report.txt
                fi
            done
        fi

        if [[ ! -f $firstpath/system-files/cmdline.txt || ! -f $datapath/system-files/cmdline.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of cmdline file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/cmdline.txt "$datapath"/system-files/cmdline.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Cmdline file has not been modified" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Cmdline file has been modified" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/cmdline.txt "$datapath"/system-files/cmdline.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/blkid.txt || ! -f $datapath/system-files/blkid.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of system's partitions, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/blkid.txt "$datapath"/system-files/blkid.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] System's partitions have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] System's partitions have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/blkid.txt "$datapath"/system-files/blkid.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lastlog.txt || ! -f $datapath/system-files/lastlog.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of lastlog, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lastlog.txt "$datapath"/system-files/lastlog.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] It hasn't detected a new login" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] It has detected a new login" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lastlog.txt "$datapath"/system-files/lastlog.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/runlevel.txt || ! -f $datapath/system-files/runlevel.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of runlevel, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/runlevel.txt "$datapath"/system-files/runlevel.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Runlevel has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Runlevel has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/runlevel.txt "$datapath"/system-files/runlevel.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lspci.txt || ! -f $datapath/system-files/lspci.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of system's devices and buses, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lspci.txt "$datapath"/system-files/lspci.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] System's devices and buses have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] System's devices and buses have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lspci.txt "$datapath"/system-files/lspci.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/fdisk.txt || ! -f $datapath/system-files/fdisk.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of disks or disks' partitions, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/fdisk.txt "$datapath"/system-files/fdisk.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Disks or disks' partitions have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Disks or disks' partitions have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/fdisk.txt "$datapath"/system-files/fdisk.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/printenv.txt || ! -f $datapath/system-files/printenv.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of system's variables, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/printenv.txt "$datapath"/system-files/printenv.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] System's variables have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] System's variables have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/printenv.txt "$datapath"/system-files/printenv.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/selinuxconfig.txt || ! -f $datapath/system-files/selinuxconfig.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of selinux's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/selinuxconfig.txt "$datapath"/system-files/selinuxconfig.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Selinux's configuration has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Selinux's configuration has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/selinuxconfig.txt "$datapath"/system-files/selinuxconfig.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/selinuxsemanage.txt || ! -f $datapath/system-files/selinuxsemanage.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of selinux's politics configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/selinuxsemanage.txt "$datapath"/system-files/selinuxsemanage.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Selinux's politics configuration have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Selinux's politics configuration have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/selinuxsemanage.txt "$datapath"/system-files/selinuxsemanage.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/selinuxstatus.txt || ! -f $datapath/system-files/selinuxstatus.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of sestatus.conf file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/selinuxstatus.txt "$datapath"/system-files/selinuxstatus.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Sestatus.conf file has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Sestatus.conf file has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/selinuxstatus.txt "$datapath"/system-files/selinuxstatus.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/hosts_allow.txt || ! -f $datapath/system-files/hosts_allow.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of allowed hosts, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/hosts_allow.txt "$datapath"/system-files/hosts_allow.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Allowed hosts has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Allowed hosts has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/hosts_allow.txt "$datapath"/system-files/hosts_allow.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/hosts_deny.txt || ! -f $datapath/system-files/hosts_deny.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of denied hosts, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/hosts_deny.txt "$datapath"/system-files/hosts_deny.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Denied hosts has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Denied hosts has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/hosts_deny.txt "$datapath"/system-files/hosts_deny.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/rsyslog.txt || ! -f $datapath/system-files/rsyslog.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of rsyslog's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/rsyslog.txt "$datapath"/system-files/rsyslog.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Rsyslog's configuration has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Rsyslog's configuration has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/rsyslog.txt "$datapath"/system-files/rsyslog.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/devices.txt || ! -f $datapath/system-files/devices.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of /proc/devices file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/devices.txt "$datapath"/system-files/devices.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] /proc/devices file has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] /proc/devices file has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/devices.txt "$datapath"/system-files/devices.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/machine_id.txt || ! -f $datapath/system-files/machine_id.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of machine's ID, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/machine_id.txt "$datapath"/system-files/machine_id.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The machine's ID has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The machine's ID has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/machine_id.txt "$datapath"/system-files/machine_id.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/product_uuid.txt || ! -f $datapath/system-files/product_uuid.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of machine's product UUID, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/product_uuid.txt "$datapath"/system-files/product_uuid.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] The machine's product UUID has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] The machine's product UUID has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/product_uuid.txt "$datapath"/system-files/product_uuid.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/resolv.txt || ! -f $datapath/system-files/resolv.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of resolv.conf file, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/resolv.txt "$datapath"/system-files/resolv.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Resolv.conf file has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Resolv.conf file has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/resolv.txt "$datapath"/system-files/resolv.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lsblk.txt || ! -f $datapath/system-files/lsblk.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of block devices, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lsblk.txt "$datapath"/system-files/lsblk.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Block devices have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Block devices have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lsblk.txt "$datapath"/system-files/lsblk.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lspci.txt || ! -f $datapath/system-files/lspci.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of PCI devices, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lspci.txt "$datapath"/system-files/lspci.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] PCI devices have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] PCI devices have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lspci.txt "$datapath"/system-files/lspci.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lsusb.txt || ! -f $datapath/system-files/lsusb.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of USB devices, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lsusb.txt "$datapath"/system-files/lsusb.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] USB devices have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] USB devices have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lsusb.txt "$datapath"/system-files/lsusb.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lsscsi.txt || ! -f $datapath/system-files/lsscsi.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of SCSI devices, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lsscsi.txt "$datapath"/system-files/lsscsi.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] SCSI devices have not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] SCSI devices have changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lsscsi.txt "$datapath"/system-files/lsscsi.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/lscpu.txt || ! -f $datapath/system-files/lscpu.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of CPU, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/lscpu.txt "$datapath"/system-files/lscpu.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Information of CPU has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Information of CPU has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/lscpu.txt "$datapath"/system-files/lscpu.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-files/dmidecode.txt || ! -f $datapath/system-files/dmidecode.txt ]]
        then
            ((errorssystemsfiles++))
            echo "[?] It couldn't analyze the information of system's hardware, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-files/dmidecode.txt "$datapath"/system-files/dmidecode.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsfiles++))
            echo "[*] Information of system's hardware has not changed" >> "$datapath"/report.txt
        else
            ((modifiedsystemsfiles++))
            echo "[!] Information of system's hardware has changed" >> "$datapath"/report.txt
            diff "$firstpath"/system-files/dmidecode.txt "$datapath"/system-files/dmidecode.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's files comparisions done!"
        echo ""

    fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/network || ! -d $datapath/network ]]
	then
		echo "${white}[${red}!${white}]${lightblue} Network configuration can't be compared"
		echo ""
        {
            echo ""
            echo "[;] Network configuration aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions network configurations
        echo "${white}[${red}*${white}]${lightblue} Comparising network configuration..."
        {
            echo ""
            echo "[@] Network configuration comparisions:"
            echo ""
        } >> "$datapath"/report.txt

        if [[ ! -f $firstpath/network/nmcli.txt || ! -f $datapath/network/nmcli.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of network configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/nmcli.txt "$datapath"/network/nmcli.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in network configuration" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in network configuration" >> "$datapath"/report.txt
            diff "$firstpath"/network/nmcli.txt "$datapath"/network/nmcli.txt >> "$datapath"/report.txt
        fi
        
        if [[ ! -f $firstpath/network/netstat.txt || ! -f $datapath/network/netstat.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of connections, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/netstat.txt "$datapath"/network/netstat.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in connections" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in connections" >> "$datapath"/report.txt
            diff "$firstpath"/network/netstat.txt "$datapath"/network/netstat.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/network/dig.txt || ! -f $datapath/network/dig.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of DNS queries, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/dig.txt "$datapath"/network/dig.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in DNS queries" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in DNS queries" >> "$datapath"/report.txt
            diff "$firstpath"/network/dig.txt "$datapath"/network/dig.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/network/route.txt || ! -f $datapath/network/route.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of routing tables, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/route.txt "$datapath"/network/route.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in routing tables" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in routing tables" >> "$datapath"/report.txt
            diff "$firstpath"/network/route.txt "$datapath"/network/route.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/network/arp.txt || ! -f $datapath/network/arp.txt ]]
        then
            ((errorsnetworkconfiguration++))
            echo "[?] It couldn't analyze the information of ARP tables, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/network/arp.txt "$datapath"/network/arp.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiednetworkconfiguration++))
            echo "[*] It hasn't detected changes in ARP tables" >> "$datapath"/report.txt
        else
            ((modifiednetworkconfiguration++))
            echo "[!] It has detected changes in ARP tables" >> "$datapath"/report.txt
            diff "$firstpath"/network/arp.txt "$datapath"/network/arp.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Network configuration comparisions done!"
        echo ""
	fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/services || ! -d $datapath/services ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's services can't be compared"
		echo ""
        {
            echo ""
            echo "[;] System's services aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions system's services
        echo "${white}[${red}*${white}]${lightblue} Comparising system's services..."
        {
            echo ""
            echo "[@] System's services comparisions:"
            echo ""
        } >> "$datapath"/report.txt
        
        if [[ ! -f $firstpath/services/iptables.txt || ! -f $datapath/services/iptables.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of iptables's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/iptables.txt "$datapath"/services/iptables.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in iptable's configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in iptable's configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/iptables.txt "$datapath"/services/iptables.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/firewalld.txt || ! -f $datapath/services/firewalld.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of firewalld's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/firewalld.txt "$datapath"/services/firewalld.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in firewalld's configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in firewalld's configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/firewalld.txt "$datapath"/services/firewalld.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/ufw.txt || ! -f $datapath/services/ufw.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of ufw's configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/ufw.txt "$datapath"/services/ufw.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in ufw's configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in ufw's configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/ufw.txt "$datapath"/services/ufw.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/dhcp.txt || ! -f $datapath/services/dhcp.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of DHCP service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/dhcp.txt "$datapath"/services/dhcp.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in DHCP service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in DHCP service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/dhcp.txt "$datapath"/services/dhcp.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/dns.txt || ! -f $datapath/services/dns.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of DNS service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/dns.txt "$datapath"/services/dns.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in DNS service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in DNS service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/dns.txt "$datapath"/services/dns.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/vsftpd.txt || ! -f $datapath/services/vsftpd.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of vsftpd service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/vsftpd.txt "$datapath"/services/vsftpd.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in vsftpd service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in vsftpd service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/vsftpd.txt "$datapath"/services/vsftpd.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/samba.txt || ! -f $datapath/services/samba.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of samba service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/samba.txt "$datapath"/services/samba.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in samba service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in samba service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/samba.txt "$datapath"/services/samba.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/apache.txt || ! -f $datapath/services/apache.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of apache service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/apache.txt "$datapath"/services/apache.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in apache service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in apache service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/apache.txt "$datapath"/services/apache.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/mariadb.txt || ! -f $datapath/services/mariadb.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of mariadb service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/mariadb.txt "$datapath"/services/mariadb.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in mariadb service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in mariadb service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/mariadb.txt "$datapath"/services/mariadb.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/squid.txt || ! -f $datapath/services/squid.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of squid service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/squid.txt "$datapath"/services/squid.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in squid service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in squid service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/squid.txt "$datapath"/services/squid.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/ssh.txt || ! -f $datapath/services/ssh.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of SSH service configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/ssh.txt "$datapath"/services/ssh.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in SSH service configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in SSH service configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/ssh.txt "$datapath"/services/ssh.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/services/php.txt || ! -f $datapath/services/php.txt ]]
        then
            ((errorssystemsservices++))
            echo "[?] It couldn't analyze the information of PHP configuration, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/services/php.txt "$datapath"/services/php.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemsservices++))
            echo "[*] It hasn't detected changes in PHP configuration" >> "$datapath"/report.txt
        else
            ((modifiedsystemsservices++))
            echo "[!] It has detected changes in PHP configuration" >> "$datapath"/report.txt
            diff "$firstpath"/services/php.txt "$datapath"/services/php.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's services comparisions done!"
        echo ""
	fi

	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/system-logs || ! -d $datapath/system-logs ]]
	then
		echo "${white}[${red}!${white}]${lightblue} System's logs can't be compared"
		echo ""
        {
            echo ""
            echo "[;] System's logs aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions system's logs
        echo "${white}[${red}*${white}]${lightblue} Comparising system's logs..."
        {
            echo ""
            echo "[@] System's logs comparisions:"
            echo ""
        } >> "$datapath"/report.txt

        if [[ ! -f $firstpath/system-logs/auth/logfile_auth_log.txt || ! -f $datapath/system-logs/auth/logfile_auth_log.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_auth_log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/auth/logfile_auth_log.txt "$datapath"/system-logs/auth/logfile_auth_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_auth_log" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_auth_log" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/auth/logfile_auth_log.txt "$datapath"/system-logs/auth/logfile_auth_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-logs/dpkg/logfile_dpkg_log.txt || ! -f $datapath/system-logs/dpkg/logfile_dpkg_log.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_dpkg_log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/dpkg/logfile_dpkg_log.txt "$datapath"/system-logs/dpkg/logfile_dpkg_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_dpkg_log" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_dpkg:log" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/dpkg/logfile_dpkg_log.txt "$datapath"/system-logs/dpkg/logfile_dpkg_log.txt >> "$datapath"/report.txt
        fi
        
        if [[ ! -f $firstpath/system-logs/messages/logfile_messages.txt || ! -f $datapath/system-logs/messages/logfile_messages.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_messages, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/messages/logfile_messages.txt "$datapath"/system-logs/messages/logfile_messages.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_messages" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_messages" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/messages/logfile_messages.txt "$datapath"/system-logs/messages/logfile_messages.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-logs/boot/logfile_boot_log.txt || ! -f $datapath/system-logs/boot/logfile_boot_log.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_boot_log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/boot/logfile_boot_log.txt "$datapath"/system-logs/boot/logfile_boot_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_boot_log" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_boot_log" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/boot/logfile_boot_log.txt "$datapath"/system-logs/boot/logfile_boot_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-logs/kern/logfile_kern_log.txt || ! -f $datapath/system-logs/kern/logfile_kern_log.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_kern_log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/kern/logfile_kern_log.txt "$datapath"/system-logs/kern/logfile_kern_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_kern_log" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_kern_log" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/kern/logfile_kern_log.txt "$datapath"/system-logs/kern/logfile_kern_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/system-logs/lastlog/logfile_lastlog.txt || ! -f $datapath/system-logs/lastlog/logfile_lastlog.txt ]]
        then
            ((errorssystemslogs++))
            echo "[?] It couldn't analyze the information of logfile_lastlog, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/system-logs/lastlog/logfile_lastlog.txt "$datapath"/system-logs/lastlog/logfile_lastlog.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedsystemslogs++))
            echo "[*] It hasn't detected changes in logfile_lastlog" >> "$datapath"/report.txt
        else
            ((modifiedsystemslogs++))
            echo "[!] It has detected changes in logfile_lastlog" >> "$datapath"/report.txt
            diff "$firstpath"/system-logs/lastlog/logfile_lastlog.txt "$datapath"/system-logs/lastlog/logfile_lastlog.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} System's logs comparisions done!"
        echo ""
	fi


	# Check if folders exists. If they exists, compare files
	if [[ ! -d $firstpath/logs-services || ! -d $datapath/logs-services ]]
	then
		echo "${white}[${red}!${white}]${lightblue} Services' logs can't be compared"
		echo ""
        {
            echo ""
            echo "[;] Services' logs aren't going to be compared, or can't be compared"
        } >> "$datapath"/report.txt
	else
		# Comparisions services' logs
        echo "${white}[${red}*${white}]${lightblue} Comparising services' logs..."
        {
            echo ""
            echo "[@] Services' logs comparisions:"
            echo ""
        } >> "$datapath"/report.txt

        if [[ ! -f $firstpath/logs-services/firewalld.txt || ! -f $datapath/logs-services/firewalld.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of firewalld's logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/firewalld.txt "$datapath"/logs-services/firewalld.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in firewalld's logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in firewalld's logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/firewalld.txt "$datapath"/logs-services/firewalld.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/ufw/logfile_ufw.txt || ! -f $datapath/logs-services/ufw/logfile_ufw.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_ufw, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/ufw/logfile_ufw.txt "$datapath"/logs-services/ufw/logfile_ufw.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_ufw" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_ufw" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/ufw/logfile_ufw.txt "$datapath"/logs-services/ufw/logfile_ufw.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/vsftpd.txt || ! -f $datapath/logs-services/vsftpd.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of vsftpd's logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/vsftpd.txt "$datapath"/logs-services/vsftpd.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in vsftpd's logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in vsftpd's logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/vsftpd.txt "$datapath"/logs-services/vsftpd.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/samba/logfile_log.smbd.txt || ! -f $datapath/logs-services/samba/logfile_log.smbd.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_log.smbd, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/samba/logfile_log.smbd.txt "$datapath"/logs-services/samba/logfile_log.smbd.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_log.smbd" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_log.smbd" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/samba/logfile_log.smbd.txt "$datapath"/logs-services/samba/logfile_log.smbd.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/samba/logfile_log.nmbd.txt || ! -f $datapath/logs-services/samba/logfile_log.nmbd.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_log.nmbd, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/samba/logfile_log.nmbd.txt "$datapath"/logs-services/samba/logfile_log.nmbd.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_log.nmbd" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_log.nmbd" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/samba/logfile_log.nmbd.txt "$datapath"/logs-services/samba/logfile_log.nmbd.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/httpd/logfile_error_log.txt || ! -f $datapath/logs-services/httpd/logfile_error_log.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_error.log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/httpd/logfile_error_log.txt "$datapath"/logs-services/httpd/logfile_error_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_error.log" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_error.log" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/httpd/logfile_error_log.txt "$datapath"/logs-services/httpd/logfile_error_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/httpd/logfile_access_log.txt || ! -f $datapath/logs-services/httpd/logfile_access_log.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of logfile_access.log, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/httpd/logfile_access_log.txt "$datapath"/logs-services/httpd/logfile_access_log.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in logfile_access.log" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in logfile_access.log" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/httpd/logfile_access_log.txt "$datapath"/logs-services/httpd/logfile_access_log.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/mariadb.txt || ! -f $datapath/logs-services/mariadb.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of mariadb's logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/mariadb.txt "$datapath"/logs-services/mariadb.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in mariadb's logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in mariadb's logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/mariadb.txt "$datapath"/logs-services/mariadb.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/access.txt || ! -f $datapath/logs-services/access.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of squid/access' logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/access.txt "$datapath"/logs-services/access.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in squid/access' logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in squid/access' logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/access.txt "$datapath"/logs-services/access.txt >> "$datapath"/report.txt
        fi

        if [[ ! -f $firstpath/logs-services/cache.txt || ! -f $datapath/logs-services/cache.txt ]]
        then
            ((errorsserviceslogs++))
            echo "[?] It couldn't analyze the information of squid/cache's logs, check Linux's Doctor log" >> "$datapath"/report.txt
        elif [[ $(cmp "$firstpath"/logs-services/cache.txt "$datapath"/logs-services/cache.txt) == "" ]] >> /lib/linuxsdoctor/log.txt 2>&1
        then
            ((unmodifiedserviceslogs++))
            echo "[*] It hasn't detected changes in squid/cache's logs" >> "$datapath"/report.txt
        else
            ((modifiedserviceslogs++))
            echo "[!] It has detected changes in squid/cache's logs" >> "$datapath"/report.txt
            diff "$firstpath"/logs-services/cache.txt "$datapath"/logs-services/cache.txt >> "$datapath"/report.txt
        fi

        echo "${white}[${green}!${white}]${lightblue} Services' logs comparisions done!"
        echo ""
	fi

    # Write summary of comparisions if it has been detected that they were selected

    echo "${white}Summary:"
    echo ""
    
    if [[ $errorssystemsfiles != "0" ]] || [[ $modifiedsystemsfiles != "0" ]] || [[ $unmodifiedsystemsfiles != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of system's files: ${white}$errorssystemsfiles"
        echo "${lightblue}Modified in system's files: ${white}$modifiedsystemsfiles"
        echo "${lightblue}Unmodified system's files: ${white}$unmodifiedsystemsfiles"
        echo ""
    fi

    if [[ $errorsnetworkconfiguration != "0" ]] || [[ $modifiednetworkconfiguration != "0" ]] || [[ $unmodifiednetworkconfiguration != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of network configuration: ${white}$errorsnetworkconfiguration"
        echo "${lightblue}Modified network configuration: ${white}$modifiednetworkconfiguration"
        echo "${lightblue}Unmodified network configuration: ${white}$unmodifiednetworkconfiguration"
        echo ""
    fi

    if [[ $errorssystemsservices != "0" ]] || [[ $modifiedsystemsservices != "0" ]] || [[ $unmodifiedsystemsservices != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of system's services: ${white}$errorssystemsservices"
        echo "${lightblue}Modified system's services: ${white}$modifiedsystemsservices"
        echo "${lightblue}Unmodified system's services: ${white}$unmodifiedsystemsservices"
        echo ""
    fi

    if [[ $errorssystemslogs != "0" ]] || [[ $modifiedsystemslogs != "0" ]] || [[ $unmodifiedsystemslogs != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of system's logs: ${white}$errorssystemslogs"
        echo "${lightblue}Modified system's logs: ${white}$modifiedsystemslogs"
        echo "${lightblue}Unmodified system's logs: ${white}$unmodifiedsystemslogs"
        echo ""
    fi
    
    if [[ $errorsserviceslogs != "0" ]] || [[ $modifiedserviceslogs != "0" ]] || [[ $unmodifiedserviceslogs != "0" ]]
    then
        echo "${lightblue}Errors in comparisions of services' logs: ${white}$errorsserviceslogs"
        echo "${lightblue}Modified services' logs: ${white}$modifiedserviceslogs"
        echo "${lightblue}Unmodified services' logs: ${white}$unmodifiedserviceslogs"
        echo ""
    fi

    {
        echo ""
        echo "Summary:"

        if [[ $errorssystemsfiles != "0" ]] || [[ $modifiedsystemsfiles != "0" ]] || [[ $unmodifiedsystemsfiles != "0" ]]
        then
            echo "Errors in comparisions of system's files: $errorssystemsfiles"
            echo "Modified in system's files: $modifiedsystemsfiles"
            echo "Unmodified system's files: $unmodifiedsystemsfiles"
            echo ""
        fi

        if [[ $errorsnetworkconfiguration != "0" ]] || [[ $modifiednetworkconfiguration != "0" ]] || [[ $unmodifiednetworkconfiguration != "0" ]]
        then
            echo "Errors in comparisions of network configuration: $errorsnetworkconfiguration"
            echo "Modified network configuration: $modifiednetworkconfiguration"
            echo "Unmodified network configuration: $unmodifiednetworkconfiguration"
            echo ""
        fi

        if [[ $errorssystemsservices != "0" ]] || [[ $modifiedsystemsservices != "0" ]] || [[ $unmodifiedsystemsservices != "0" ]]
        then
            echo "Errors in comparisions of system's services: $errorssystemsservices"
            echo "Modified system's services: $modifiedsystemsservices"
            echo "Unmodified system's services: $unmodifiedsystemsservices"
            echo ""
        fi

        if [[ $errorssystemslogs != "0" ]] || [[ $modifiedsystemslogs != "0" ]] || [[ $unmodifiedsystemslogs != "0" ]]
        then
            echo "Errors in comparisions of system's logs: $errorssystemslogs"
            echo "Modified system's logs: $modifiedsystemslogs"
            echo "Unmodified system's logs: $unmodifiedsystemslogs"
            echo ""
        fi
        
        if [[ $errorsserviceslogs != "0" ]] || [[ $modifiedserviceslogs != "0" ]] || [[ $unmodifiedserviceslogs != "0" ]]
        then
            echo "Errors in comparisions of services' logs: $errorsserviceslogs"
            echo "Modified services' logs: $modifiedserviceslogs"
            echo "Unmodified services' logs: $unmodifiedserviceslogs"
            echo ""
        fi

    } >> "$datapath"/report.txt

    # Check if user want generate an HTML report
    if [ "$htmlreport" == "Y" ]
    then
        echo "${white}[${red}*${white}]${lightblue} Generating HTML report..."
        touch "$datapath"/report-"$date".html
        source /lib/linuxsdoctor/generatehtml.sh
        generatehtml
        if [ "$?" -eq 0 ]
        then
            echo "${white}[${green}!${white}]${lightblue} Complete!"
        else
            echo "${red}Something went wrong"
        fi
        echo "${white}"
    fi

}

function checkcomparisions (){
	if [[ ! -f $firstpath/analysis.txt || ! -f $datapath/analysis.txt ]]
	then
		while true
		do
			read -r -p "${lightblue}It couldn't detected analysis.txt in any of the specified paths. It couldn't be checked if it could be possible compare evidences in a safe way. Do you want continue?${green} [Y/N]${white} " checkanalysis
			if [[ $checkanalysiscomparision == "Y" ]] || [[ $checkanalysiscomparision == "y" ]]
			then
				while true
				do
					read -r -p "${lightblue}What is the operating system of the evidences that you want compare?${green} [Debain/Ubuntu/Kali/CentOS]${white} " checkanalysis
					case $checkanalysis in
					Debian | debian | Ubuntu | ubuntu | Kali | kali)
						comparisions_os="Debian"
					;;
					CentOS | Centos | centos)
						comparisions_os="CentOS"
					;;
					*)
						continue
					esac
					break
				done

				comparisions"$comparisions_os"

			elif [[ $checkanalysiscomparision == "N" ]] || [[ $checkanalysiscomparision == "n" ]]
			then
                echo "${reset}"
				exit
			else
				continue
			fi
			break
		done
	else
		if [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') ]]
		then
			while true
			do
				read -r -p "${lightblue}It has been detected different OS${green} ($(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') / $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }')).${lightblue} Check that you want compare the evidences specified. Do you want continue?${green} [Y/N]${white} " checkanalysis
				if [[ $checkanalysis == "Y" ]] || [[ $checkanalysis == "y" ]]
				then
					while true
					do
						read -r -p "${lightblue}What is the operating system of the evidences that you want compare?${green} [Debain/Ubuntu/Kali/CentOS]${white} " checkanalysis
						case $checkanalysis in
						Debian | debian | Ubuntu | ubuntu | Kali | kali)
							comparisions_os="Debian"
						;;
						CentOS | Centos | centos)
							comparisions_os="CentOS"
						;;
						*)
							continue
						esac
						break
					done
					break
				elif [[ $checkanalysis == "N" ]] || [[ $checkanalysis == "n" ]]
				then
                    echo "${reset}"
					exit
				else
					continue
				fi
				break
			done
		fi

		if [[ $(sed '9q;d' "$firstpath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') != $(sed '9q;d' "$datapath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') ]]
		then
			while true
			do
				read -r -p "${lightblue}It has been detected different versions of Linux's Doctor${green} ($(sed '9q;d' "$firstpath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }') / $(sed '9q;d' "$datapath"/analysis.txt | awk '{ gsub(/Tool version: /,""); print }')).${lightblue} This can provoke that it couldn't be able to do all the comparisions that is expected. Do you want continue?${green} [Y/N]${white} " checkanalysis
				if [[ $checkanalysis == "Y" ]] || [[ $checkanalysis == "y" ]]
				then
					break
				elif [[ $checkanalysis == "N" ]] || [[ $checkanalysis == "n" ]]
				then
                    echo "${reset}"
					exit
				else
					continue
				fi
				break
			done
		fi

		if [[ -z $comparisions_os ]]
        then
			if [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Debian" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Ubuntu" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "Kali" ]]
			then
				while true
				do
					read -r -p "${lightblue}We detected an unsupported OS${green} ($(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }')).${lightblue} Do you want continue?${green} [Y/N]${white} " checkanalysis
					if [[ $checkanalysis == "Y" ]] || [[ $checkanalysis == "y" ]]
					then
						break
					elif [[ $checkanalysis == "N" ]] || [[ $checkanalysis == "n" ]]
					then
                        echo "${reset}"
						exit
					else
						continue
					fi
					break
				done
			fi

			if [[ $(sed '4q;d' "$firstpath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]] && [[ $(sed '4q;d' "$datapath"/analysis.txt | awk '{ gsub(/OS: /,""); print }') != "CentOS" ]]
			then
				comparisions_os="Debian"
			else
				comparisions_os="CentOS"
			fi

			comparisions"$comparisions_os"

		fi
	fi
}
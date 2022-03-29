#!/bin/bash
#*****************************************************************************************************************
#How to use in VM Bitrix
#Configure email, minimum free space, backup path and FTP settings
#Replace all DBNAME and sitname to current
#Add to /etc/crontab
#/opt/webdir/bin/bx_backup.sh DBNAME /home/bitrix/backup/archive >/dev/null 2>&1 && /home/bitrix/THISSCRIPTNAME.sh
#*****************************************************************************************************************

#Settings
backup_path=/home/bitrix/backup/archive
DATE_TIME=$(date +"%d.%m.%Y %T")
admin_email=
FTPServer=
FTPUser=
FTPPass=
backup_disk=/dev/vda2
minspace=16000 #minimum free space on the server in MB
space_message="$DATE_TIME - Current free disk space is = $(df -h $backup_disk | tail -n1 | awk '{print $4}')"
copy_message="$DATE_TIME - Backup copy error, another backup is running, run.flag is exist  $(echo -e '\n ') $(ls -oh $backup_path)"
copytoftp() {
ftp -n <<EOF
open $FTPServer
user $FTPUser $FTPPass
put sitename_"$(date +%d%m%Y)".tar.gz
delete sitename_"$(date -d "10 day ago" +%d%m%Y)".tar.gz
EOF

} 
sendemail() {
sendmail -t <<EOF
From:backup@$HOSTNAME
To:$admin_email
Subject:Backup Error
Content-Type:text/plain; charset=utf-8
$1
EOF

}
#Check free space in MB 
if [ "$(df -BM $backup_disk | tail -n1 | awk '{print $4}' | sed -e's/.$//')" -gt $minspace ] 
then
    #If another copy process is running, wait 5 min x3 then send error message
    for ((i = 0; i < 3; i++))  
                do 
                if [ -f $backup_path/run.flag ] 
                    then
                        sleep 300
                    else			
                        break
                fi	
            done
    if [ -f $backup_path/run.flag ] 
    then
        sendemail "$copy_message"
    else
        #Create run.flag, rename backup file, copy to FTP, delete old backup files from FTP
        cd $backup_path || exit 1
        echo '' > run.flag
        #Rename backup file to human readable
        find www_backup_DBNAME*.gz -type f -exec mv "{}" sitename_"$(date +%d%m%Y)".tar.gz \;
        copytoftp
        rm -f $backup_path/*  
    fi
#If current free space < 3000 MB, emergency clear backup dir and send email
elif [ "$(df -BM $backup_disk | tail -n1 | awk '{print $4}' | sed -e's/.$//')" -lt 3000 ]
then
	sendemail "$space_message"
	rm -f $backup_path/*
else
    sendemail "$space_message"
fi

#!/bin/bash

#version 0.2

#================================================
#Settings section
#================================================
#Backup directory path
DAY_DIR=/backup/day
WEEK_DIR=/backup/week
MONTH_DIR=/backup/month
YEAR_DIR=/backup/year
TMP_DIR=/backup/tmp

#Date format
DATE="_$(date +%d%m%y)"

#Вatabase names separated by spaces
DBNAME="ext_retr ext_server gis_ext ext_history"
#================================================



#================================================
#Functions section
#================================================
makedump () {
    for DB in $DBNAME
        do
            su - postgres -c "pg_dump -j 10 -Fd -f $TMP_DIR/$DB$DATE $DB" 2>"$TMP_DIR"/error.log
            if [ $? -ne 0 ]; then
                send_email
            fi
        done;
}

checkdate_and_copy () {
    if [[ $(date +%j) == 001 ]]; then
            cp -r "$TMP_DIR"/* $YEAR_DIR
            cp -r "$TMP_DIR"/* $MONTH_DIR
            mv "$TMP_DIR"/* $DAY_DIR
    elif [[ $(date +%d) == 01 ]]; then
            cp -r "$TMP_DIR"/* $MONTH_DIR
            mv "$TMP_DIR/*" $DAY_DIR
    elif [[ $(date +%u) == 1 ]]; then
            cp -r "$TMP_DIR/"* $WEEK_DIR
            mv "$TMP_DIR"/* $DAY_DIR
    else
            mv -f "$TMP_DIR/"* $DAY_DIR
    fi
}

clear () {
    #delete all from tmp directroy
    rm -rf "$TMP_DIR"/*

    if [[ $(date +%j) == 001 ]]; then
            find "$YEAR_DIR" -type d -ctime +1460 -delete
            find "$MONTH_DIR" -type d -ctime +32 -delete
    fi

    if [[ $(date +%d) == 01 ]]; then
            find "$MONTH_DIR" -type d -ctime +364 -delete
    fi

    if [[ $(date +%u) == 1 ]]; then
            find "$DAY_DIR" -type d -ctime +6 -delete
    fi
}

send_email () {
    sendemail -f FROM_EMAIL -t TO_EMAIL \
    -u Telematic Database backup is failed \
    -m "Server: $(hostname) \nInternal IP: $(hostname -I) \nExternal IP: $(curl -s 2ip.ru) \nError log: \n$(cat "$TMP_DIR"/error.log)" \
    -s SERVER_IP  -v -o message-charset=utf-8
}

makebackup () {
    clear
    makedump
    checkdate_and_copy
}
#================================================


#================================================
#Main section
#================================================

makebackup

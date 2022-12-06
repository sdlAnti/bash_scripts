Some Bash scripts.  
## Backup
1. [backup_copy_VMB.sh](scripts/backup_copy_VMB.sh): Copy backup to FTP server from bitrix virtual appliance, with: email alert, free space check, another running copy check.  
## Nano syntax highlighting
1. [.conf](scripts/nano_syntax_higlighting/conf.nanorc): syntax highlighting for .conf files
2. [.yaml](scripts/nano_syntax_higlighting/yaml.nanorc): syntax highlighting for .yaml files
### Setup  
Download and copy .nanorc files to /usr/share/nano/ 
```
sudo wget https://raw.githubusercontent.com/sdlAnti/bash_scripts/44255215195f46e499537599b02e147b65111cd7/scripts/nano%20syntax%20higlighting/yaml.nanorc -P /usr/share/nano/ && \
sudo wget https://raw.githubusercontent.com/sdlAnti/bash_scripts/44255215195f46e499537599b02e147b65111cd7/scripts/nano%20syntax%20higlighting/conf.nanorc -P /usr/share/nano/
```
Include highlighting config for current user
```
printf "include /usr/share/nano/conf.nanorc\ninclude /usr/share/nano/yaml.nanorc\n" >> ~/.nanorc
```
If you want include all *.nanorc files from /usr/share/nano/ to current user
```
find /usr/share/nano/ -iname "*.nanorc" -exec echo include {} \; >> ~/.nanorc
```
## Certbot, Renew Let's Encrypt's certificates using systemd unit and timer
1. [certbot-update.service](scripts/certbot_systemd_update/certbot-update.service): systemd unit
2. [.yaml](scripts/certbot_systemd_update/certbot-update.timer): systemd timer, run on start and every day at 22:00:00 +- 1h
### Setup
Download, copy to /etc/systemd/system/
```
sudo wget https://github.com/sdlAnti/bash_scripts/raw/main/certbot_systemd_update/certbot-update.service -P /etc/systemd/system/ && \
sudo wget https://github.com/sdlAnti/bash_scripts/raw/main/certbot_systemd_update/certbot-update.timer -P /etc/systemd/system/ 
``` 
Enable, start timer and reload systemctl daemon
```
sudo systemctl enable certbot-update.timer && sudo systemctl start certbot-update.timer && sudo systemctl daemon-reload
```
## Bash user highlighting  
Root - red  
Anothger user - green  
### Setup  
run as local users and root
```
cat << EOF >>  ~/.bashrc
if [ "$UID" = 0 ];
then
    PS1='\e[31m${debian_chroot:+($debian_chroot)}\u@\h:\w\$\e[m '
else
    PS1='\e[32m${debian_chroot:+($debian_chroot)}\u@\h:\w\$\e[m '
fi
EOF
```
## OpenSearch + OpenSearch Dashboards
[opensearch.sh](scripts/opensearch.sh): automatic setup scrypt
### Info  
test on ubuntu 20.04

download and setup:  
1.  opensearch-2.4.0
2.  opensearch-dashboards-2.4.0
3.  openjdk-17-jdk  

if you whant install another version edit link in scrypt  
check openjdk [compatibility](https://opensearch.org/docs/latest/opensearch/install/compatibility/) for opensearch
scrypt create:
- user opensearch vs group opensearch, shell /sbin/nologin
- directories /opt/opensearch and /opt/opensearch-dashboards
- syshtemd units opensearch.service and opensearch-dashboards.service

### Setup  
just run opensearch.sh  
Crtl+C opensearch-tar-install.sh arter is finished  
reload systemctl daemon 
```
systemctl daemon-reload
```
start services
```
systemctl start opensearch
systemctl enable opensearch
systemctl start opensearch-dasboards
systemctl enable opensearch-dasboards
```
Some Bash scripts.  
## Backup
1. [backup_copy_VMB.sh](scripts/backup_copy_VMB.sh): Copy backup to FTP server from bitrix virtual appliance, with: email alert, free space check, another running copy check.  
## Nano syntax highlighting
1. [.conf](nano syntax higlighting/conf.nanorc): syntax highlighting for .conf files
2. [.yaml](nano syntax higlighting/yaml.nanorc): syntax highlighting for .yaml files
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
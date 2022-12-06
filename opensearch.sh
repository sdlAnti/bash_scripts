#!/bin/bash
apt update && \
apt upgrade -y && \
apt install openjdk-17-jdk -y && \
groupadd opensearch && \
useradd opensearch -g opensearch -M -s /sbin/nologin && \
wget https://artifacts.opensearch.org/releases/bundle/opensearch/2.4.0/opensearch-2.4.0-linux-x64.tar.gz && \
wget https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/2.4.0/opensearch-dashboards-2.4.0-linux-x64.tar.gz && \
tar xvf opensearch-2.4.0-linux-x64.tar.gz && \
tar xzvf opensearch-dashboards-2.4.0-linux-x64.tar.gz && \
mkdir /opt/opensearch && \
mkdir /opt/opensearch-dashboards && \
mkdir /var/log/opensearch && \
chown -R opensearch /var/log/opensearch && \
mv opensearch-2.4.0/* /opt/opensearch/ && \
mv opensearch-dashboards-2.4.0/* /opt/opensearch-dashboards/ && \
rm -rf opensearch* && \
chown -R opensearch:opensearch /opt/opensearch* && \
sudo -u opensearch /opt/opensearch/opensearch-tar-install.sh

cat << EOF > /lib/systemd/system/opensearch.service
[Unit]
Description=Opensearch
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
RuntimeDirectory=opensearch
PrivateTmp=true

Restart=on-failure
RestartSec=60s

WorkingDirectory=/opt/opensearch

User=opensearch
Group=opensearch

ExecStart=/opt/opensearch/bin/opensearch

StandardOutput=journal
StandardError=inherit

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /lib/systemd/system/opensearch-dasboards.service
[Unit]
Description=Opensearch-dashboards
Wants=network-online.target
After=network-online.target opensearch.service

[Service]
Type=simple
RuntimeDirectory=opensearch-dashboards
PrivateTmp=true

Restart=on-failure
RestartSec=60s

WorkingDirectory=/opt/opensearch-dashboards

User=opensearch
Group=opensearch

ExecStart=/opt/opensearch-dashboards/bin/opensearch-dashboards

StandardOutput=journal
StandardError=inherit

[Install]
WantedBy=multi-user.target
EOF


#!/bin/bash

echo "install tinyscan app"

cat <<EOF > /etc/systemd/system/tinyscan-app.service
[Unit]
Description= Tinyscan Docker Compose Application Service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/tinyscan/script
ExecStart=/tinyscan/script/start.sh up -d
ExecStop=/tinyscan/script/start.sh down

[Install]
WantedBy=multi-user.target
EOF

systemctl enable tinyscan-app

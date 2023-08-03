#!/bin/bash

if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

checkFile="/tinyscan/.install_tinyscan_flag"
if [ -f "$checkFile" ]; then
    echo "You have installed the tinyscan" 1>&2
    exit 1
fi

WORK_DIR_NAME=$(cd "$(dirname "$0")"; pwd)
cd $WORK_DIR_NAME

chmod u+x ./*.sh
chmod u+x ./tinyscan/script/*.sh
chmod u+x ./tinyscan/engine/export/bin/*
cp -rf ./tinyscan /tinyscan

echo "Install docker..."
./install_docker.sh

echo "Install service..."
./install_service.sh

echo "Docker load imagesi..."
# /tinyscan/script/quick_update.sh -l ./images
./docker_login.sh

echo "Init mongodb..."
./init_mongo.sh

echo "Init mysql..."
./init_mysql.sh


echo "Start server"
systemctl start tinyscan-app
#/tinyscan/script/start.sh up -d

touch ${checkFile}
echo "Install done"


#!/bin/bash

echo "stop firewalld and SeLinux"
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config


echo "install docker and docker-compose-plugin"
rpm -ivh --nodeps rpm/docker/*

echo "change docker images location to /tinyscan/docker-cache"
mkdir -p /etc/docker
mkdir -p /tinyscan/docker-image-cache
cat <<EOF > /etc/docker/daemon.json
{
    "data-root":"/docker-cache",
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver":"json-file",
    "log-opts": {"max-size":"50m", "max-file":"3"}
}
EOF
systemctl enable docker && systemctl start docker


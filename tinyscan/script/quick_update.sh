#!/bin/bash

mongodb="registry.cn-beijing.aliyuncs.com/tinyscan/mongodb:4.2.8"
mysql="registry.cn-beijing.aliyuncs.com/tinyscan/mysql:5.6.44"
engine="registry.cn-beijing.aliyuncs.com/tinyscan/ubuntu-base:tinyscan-engine_v4"
web="registry.cn-beijing.aliyuncs.com/tinyscan/tinyscan-backend:dev-1.5.1"


function pull()
{
    docker pull $mongodb
    docker pull $mysql
    docker pull $engine
    docker pull $web

    docker images | grep '<none>' |awk '{print $3}' | xargs docker rmi
}
function save()
{
    echo "Output Path: $1"
    docker save -o $1"/mongodb.tar" $mongodb
    docker save -o $1"/mysql.tar" $mysql
    docker save -o $1"/engine.tar" $engine
    docker save -o $1"/web.tar" $web
}

function load()
{
    echo "Input Path: $1"
    docker load -i $1"/mongodb.tar"
    docker load -i $1"/mysql.tar"
    docker load -i $1"/engine.tar"
    docker load -i $1"/web.tar"
}

while getopts ps:l:h opts
do
    case $opts in
    p)  
        echo "Start Pull Docker..."
        sleep 3
        pull
        ;;
    s)  
        echo "Start Save Docker..."
        sleep 3
        save $OPTARG
        ;;
    l)
        echo "Start Load Docker"
        sleep 3
        load $OPTARG
        ;;
    h)  
        echo "Usage: quick_update [OPTION]
-p pull    pull docker images
-s save    save docker images
-l load    load docker images"
        exit 1
        ;;
    esac
done

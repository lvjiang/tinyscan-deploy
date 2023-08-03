#!/bin/bash

WORK_DIR_NAME=/tinyscan/docker-compose-yml
cd $WORK_DIR_NAME

/usr/bin/docker compose -f mysql.yml -f mongo.yml -f web.yml -f engine.yml $@

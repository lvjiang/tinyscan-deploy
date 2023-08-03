#!/usr/bin/env bash

CONTAINER_NAME="tinyscan-mongo"
HOSTNAME="mongo-server"
PORT="27017"
ROOT_USER="root"
ROOT_PASSWORD="root"
PUBLIC_USER="tinyscan"

# generate rand password
typeset -u PUBLIC_PASSWORD
PUBLIC_PASSWORD=$(echo $(( $(date +%s%N) ^ $$ )) | md5sum | head -c 20)

get_name="db.getName();"
login_root="db.auth(\"${ROOT_USER}\",\"${ROOT_PASSWORD}\");"
delete_root="db.dropUser(\"${ROOT_USER}\");"
create_PublicUser="db.createUser({user:\"${PUBLIC_USER}\",pwd:\"${PUBLIC_PASSWORD}\",roles:[{role:\"readWrite\",db:\"tinyscan\"},{role:\"readWrite\",db:\"sext\"}]});"

docker compose -f /tinyscan/docker-compose-yml/mongo.yml up -d
until docker exec ${CONTAINER_NAME} mongo ${HOSTNAME}:${PORT}/admin --eval ${login_root}${get_name}; do
    sleep 3
    echo "connect mongodb..."
done

echo '->> 正在导入tinyscan数据'
docker exec ${CONTAINER_NAME} mongo ${HOSTNAME}:${PORT}/tinyscan -u ${ROOT_USER} -p ${ROOT_PASSWORD} --authenticationDatabase="admin" /data/rule/tinyscan.js
echo '->> 数据导入tinyscan成功'

echo '->> 正在导入sext数据'
docker exec ${CONTAINER_NAME} mongorestore --host ${HOSTNAME}:${PORT} -u ${ROOT_USER} -p ${ROOT_PASSWORD} --authenticationDatabase="admin" -d "sext" --drop "/data/rule/sext" --gzip
rm -rf /tinyscan/mongo/rule/*
echo '->> 数据导入sext成功'

echo '->> 正在进行权限配置'
echo '->> 创建public用户中...'
docker exec ${CONTAINER_NAME} mongo ${HOSTNAME}:${PORT}/admin --eval ${login_root}${create_PublicUser}

echo '->> 删除root用户中...'
docker exec ${CONTAINER_NAME} mongo ${HOSTNAME}:${PORT}/admin --eval ${login_root}${delete_root}

echo '->> 持久化用户密码信息中...'
sed -r -i "s/(MONGO_USER=).*$/\1$PUBLIC_USER/" /tinyscan/docker-compose-yml/.env
sed -r -i "s/(MONGO_PASSWORD=).*$/\1$PUBLIC_PASSWORD/" /tinyscan/docker-compose-yml/.env

sed -i "s/\${MONGO_USER}/${PUBLIC_USER}/" /tinyscan/web/conf/config.yaml
sed -i "s/\${MONGO_PASSWORD}/${PUBLIC_PASSWORD}/" /tinyscan/web/conf/config.yaml
echo '->> 权限配置成功'

# close containers
docker compose -f /tinyscan/docker-compose-yml/mongo.yml down




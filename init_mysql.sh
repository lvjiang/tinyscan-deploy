#!/usr/bin/env bash

CONTAINER_NAME="tinyscan-mysql"
HOSTNAME="mysql-server"
PORT="3306"
USER="root"
PASSWD="root"
PRIVATE_USER="tinyscan"

# generate mysql password
typeset -u PRIVATE_PASSWORD
PRIVATE_PASSWORD=$(echo $(( $(date +%s%N) ^ $$ )) | md5sum | head -c 20)


# create user sql
select_sql="select 1;"
create_user="create user ${PRIVATE_USER} identified by '${PRIVATE_PASSWORD}'";
grant_sql="grant INSERT, DELETE, UPDATE, SELECT on *.* to '${PRIVATE_USER}'@'%' identified by '${PRIVATE_PASSWORD}' with grant option;flush privileges;"
delete_root_user="delete from user where User='root';flush privileges;"

# init mysql
docker compose -f /tinyscan/docker-compose-yml/mysql.yml up -d
until docker exec ${CONTAINER_NAME} mysql -h$HOSTNAME -P$PORT -u$USER -p$PASSWD -Dmysql -e "${select_sql}"; do
    sleep 3
    echo "connect mysql..."
done

# load data via sql
echo '->> 执行初始化脚本...'
docker exec ${CONTAINER_NAME} mysql -h$HOSTNAME -P$PORT -u$USER -p$PASSWD -e "source /usr/local/mysql/var/mysql.sql"
rm -f /tinyscan/mysql/data/mysql.sql
sleep 3


# create user
echo '->> 创建数据库用户中...'
docker exec ${CONTAINER_NAME} mysql -h$HOSTNAME -P$PORT -u$USER -p$PASSWD -Dmysql -e "${create_user}"
docker exec ${CONTAINER_NAME} mysql -h$HOSTNAME -P$PORT -u$USER -p$PASSWD -Dmysql -e "${grant_sql}"
echo '->> 删除数据库root用户中...'
docker exec ${CONTAINER_NAME} mysql -h$HOSTNAME -P$PORT -u$USER -p$PASSWD -Dmysql -e "${delete_root_user}"

echo '->> 持久化用户密码信息中...'
sed -r -i "s/(MYSQL_USER=).*$/\1$PRIVATE_USER/" /tinyscan/docker-compose-yml/.env
sed -r -i "s/(MYSQL_PASSWORD=).*$/\1$PRIVATE_PASSWORD/" /tinyscan/docker-compose-yml/.env

sed -i "s/\${MYSQL_USER}/${PRIVATE_USER}/" /tinyscan/web/conf/config.yaml
sed -i "s/\${MYSQL_PASSWORD}/${PRIVATE_PASSWORD}/" /tinyscan/web/conf/config.yaml

# close containers
docker compose -f /tinyscan/docker-compose-yml/mysql.yml down

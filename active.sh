#!/bin/bash

CONTAINER_NAME="tinyscan-mongo"
source /tinyscan/docker-compose-yml/.env

get_name="db.getName();"
print_code="db.getCollection(\"auth\").find({\"type\":\"install_code\"},{\"_id\":0,\"install_code\":0});"


until docker exec ${CONTAINER_NAME} mongo -u ${MONGO_USER} -p ${MONGO_PASSWORD} --authenticationDatabase admin admin --eval "${get_name}"; do
    sleep 3
    echo "==> Connect MongoDB..."
done

docker exec ${CONTAINER_NAME} mongo -u ${MONGO_USER} -p ${MONGO_PASSWORD} --authenticationDatabase admin tinyscan --eval "${print_code}"


echo "==> Enter your AUTH CODE: "
read code
echo "==> Your AUTH CODE: ${code}"

echo "==> Activing..."
create_time=$(date "+%Y/%m/%d %H:%M:%S")
update_code="db.getCollection(\"auth\").updateOne({\"type\":\"auth_code\"},{\"\$set\":{\"code\":\"${code}\",\"create_time\":\"${create_time}\"}},{\"upsert\":1});"
docker exec ${CONTAINER_NAME} mongo -u ${MONGO_USER} -p ${MONGO_PASSWORD} --authenticationDatabase admin tinyscan --eval "${update_code}"

/tinyscan/script/start.sh up -d --force-recreate engine-server
echo "==> Active over !!!"

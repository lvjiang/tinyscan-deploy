# tinyscan-deploy

## 1. 目录说明

- resource：存放大文件安装包，存放于SVN

  ```
  resource/
  ├── engine_bin.tar.xz
  ├── engine_font.tar.xz
  ├── mongo_sext.tar.xz
  └── rpm_docker.tar.xz
  ```

  

- tinyscan：最终安装到目标机器上的文件夹

  ```
  tinyscan/
  ├── docker-compose-yml
  │   ├── engine.yml
  │   ├── mongo.yml
  │   ├── mysql.yml
  │   └── web.yml
  ├── engine
  │   ├── app
  │   │   └── tmp
  │   └── export
  │       ├── bin
  │       ├── conf
  │       │   └── config.ini
  │       ├── file
  │       ├── font
  │       ├── log
  │       └── runlog
  ├── mongo
  │   └── rule
  │       ├── sext
  │       └── tinyscan.js
  ├── mysql
  │   └── data
  │       └── mysql.sql
  ├── script
  │   ├── quick_update.sh
  │   └── start.sh
  └── web
      ├── conf
      │   ├── config.yaml
      │   ├── server.crt
      │   └── server.key
      └── logs
  
  
  ```

- script安装包需要的脚本

  



## 2. 安装包制作

**注：制作环境：ubuntu,centos等linux操作系统，用户：普通用户或root用户**

**注：如要制作离线镜像安装包，需要制作机器上安装有docker环境，用于导出镜像**



### 2.1 下载

1. 本仓库
2. SVN上的package：`/IoTCloud/doc/QinglianCloud_IoT-内部公开/tinyscan/内部通用文档/产品部署文档/部署脚本/tinyscan150/resource/`



### 2.2 指定安装的docker镜像版本

1. 修改`./tinyscan/script/quick_update.sh`文件。

   将对应的下面的行，进行修该。

   修改前：

   ```
   mongodb="registry.cn-beijing.aliyuncs.com/tinyscan/mongodb:4.2.8"
   mysql="registry.cn-beijing.aliyuncs.com/tinyscan/mysql:5.6.44"
   engine="registry.cn-beijing.aliyuncs.com/tinyscan/ubuntu-base:tinyscan-engine_v4"
   web="registry.cn-beijing.aliyuncs.com/tinyscan/tinyscan-backend:dev-1.0.9"
   ```

   修改后：

   ```
   mongodb="registry.cn-beijing.aliyuncs.com/tinyscan/mongodb:4.2.8"
   mysql="registry.cn-beijing.aliyuncs.com/tinyscan/mysql:5.6.44"
   engine="registry.cn-beijing.aliyuncs.com/tinyscan/ubuntu-base:tinyscan-engine_v4"
   web="registry.cn-beijing.aliyuncs.com/tinyscan/tinyscan-backend:dev-1.5.0"
   ```

2. 修改./tinyscan/docker-compose-yml/文件夹下对应的yml文件。

​		如 ：将`./tinyscan/docker-compose-yml/web.yml`中,

​			image行:	`image: registry.cn-beijing.aliyuncs.com/tinyscan/tinyscan-backend:dev-1.0.9`

​			修改成:     `image: registry.cn-beijing.aliyuncs.com/tinyscan/tinyscan-backend:dev-1.5.0`



**注：1中修改的行数和2中修个改的文件要一样多**



### 2.3  制作



安装包按照docker镜像的提供方式分为两大类：**离线镜像安装包和在线镜像安装包**。

**每次制作请先执行**：`make clean`  然后按步骤执行下面的命令。



**离线镜像安装包**（dist-offline.tar.xz）制作步骤:

1. `make dist` （可跳过）

2. `make active`  (可跳过，制作客户自行安装的包时，必须跳过)

3. `make images` (可跳过，将离线镜像包含到安装包中。执行时很费时间，请耐心等待。如果跳过此步骤，需要通过其他方式提供所需的离线docker镜像tar包)

    **注：执行此步骤需要，制作机器安装有docker环境，并且执行用户拥有执行docker命令的权限**

4. `make offline` （必须，如果执行了步骤3，本步骤也很费时间，请耐心等待）

   

**在线镜像安装包**(dist-online.tar.xz)制作步骤：

1. `make dist` （可跳过）
2. `make active`  (可跳过，制作客户自行安装的包时，必须跳过)
3. `make online` （必须）



## 3. 使用

​    **注：目标机环境：centos7操作系统，用户：root用户**



### 3.1 安装

    将安装包上传至目标机器非根目录，然后按照下面的步骤执行。当出现 `Install done` 时，安装完成。



**离线镜像安装:**

1. tar -xf dist-offline  （必须）
2. 将离线docker镜像tar，放置到 ./dist/images/文件夹下。（可选，制作离线镜像安装包时，如果跳过了制作离线镜像时，必须执行本步骤）
3. cd ./dist && install.sh	（必须）



**在线镜像安装** :

1. tar -xf dist-online    （必须）
2. cd ./dist && install.sh  （必须，本步骤需要联网下载docker镜像，请保持网络畅通。费时，请耐心等待）



### 3.2 验证

​	验证按照是否成功，执行 `docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"`，

看到以下4个运行中（tinyscan-engine一直处于重启中）的容器，说明安装成功。

```
NAMES             STATUS                          IMAGE
tinyscan-engine   Restarting (1) 32 seconds ago   registry.cn-beijing.aliyuncs.com/tinyscan/ubuntu-base:tinyscan-engine_v4
tinyscan-web      Up 40 minutes                   registry.cn-beijing.aliyuncs.com/tinyscan/tinyscan-backend:dev-1.0.9
tinyscan-mysql    Up 40 minutes                   registry.cn-beijing.aliyuncs.com/tinyscan/mysql:5.6.44
tinyscan-mongo    Up 40 minutes                   registry.cn-beijing.aliyuncs.com/tinyscan/mongodb:4.2.8

```



### 3.2 激活

方式一：适用本司人员激活

1. 执行`active.sh`脚本，获得“机器码”
2. ‘然后将“机器码”提供相关人员，获取“激活码”
3. 输入“授权码”，即可完成激活

```
[root@localhost dist]# ./active.sh
{ "type" : "install_code", "code" : "0CE4F94F4F0B071DD9B575D6691800F1", "create_time" : "2023/08/09 08:12:05" }
==> Enter your AUTH CODE:

```



方式二：适用客户自行激活

1. 执行`docker logs -f tinyscan-engine`  查看“机器码”

2. 将“机器码”提供给我司相关人员，获取“授权码”。

3. 修改`/tinyscan/docker-compose-yml/.env`文件：

   修改行： `AUTH_CODE=`

   修改后：`AUTH_CODE=JEOOS62E2A3DF50BGWJ0A4740200D231ZXXG7DCEC9976D9827EA5DB3DFE10D23`		
   
   **注：不要修改其他行的内容，等号两边没有空格。**
   
4. 执行 `systemctl stop tinyscan-app && sleep 3s && systemctl start tinyscan-app`

   

   





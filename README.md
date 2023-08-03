# tinyscan-deploy

## 1. 目录说明

- package：存放大文件安装包，存放于SVN
- tinyscan：最终安装到目标机器上的文件夹



## 2. 安装包制作

### 2.1 下载

1. 本仓库
2. SVN上的package：`/IoTCloud/doc/QinglianCloud_IoT-内部公开/tinyscan/内部通用文档/产品部署文档/部署脚本/tinyscan150/package/`



### 2.2 解压

​	执行 `pre-install.sh`脚本，即可完成package下所有包的解压。



### 2.3 指定镜像版本

​	修改/tinyscan/docker-compose-yml/下对应的yml文件。



### 2.4  压缩

​	将仓库目录制作成压缩包，xz,bz,gz,zip等格式（目标机器支持的格式）。



## 3. 使用

### 3.1 安装

​	将安装包上传至目标机器非根目录，然后执行 `install.sh`。

### 3.2 激活

​	执行`active.sh`脚本，获得“机器码”，然后使用工具生成“激活码”，输入“激活码”，即可完成激活。



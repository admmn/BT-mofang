#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

curPath=`pwd`
rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")

install_tmp=${rootPath}/tmp/mw_install.pl
VERSION=5.0.20
SYS_ARCH=`arch`

SYS_VERSION_ID=`cat /etc/*-release | grep VERSION_ID | awk -F = '{print $2}' | awk -F "\"" '{print $2}'`
SYS_NAME=${SYS_VERSION_ID/./}
SYS_NAME_LEN=`echo "$SYS_NAME" | wc -L`

if [ "$SYS_NAME_LEN" == "1" ];then
	SYS_NAME=${SYS_NAME}0	
fi

if [ "$SYS_ARCH" == "aarch64" ];then
	SYS_NAME="82"
else

	if [ "$SYS_NAME" -gt "80" ];then
		SYS_NAME="80"
	fi

	if [ "$SYS_NAME" -lt "70" ];then
		SYS_NAME="70"
	fi
fi

MG_DIR=$serverPath/source/mongodb
mkdir -p $MG_DIR

FILE_NAME=mongodb-linux-${SYS_ARCH}-rhel${SYS_NAME}-${VERSION}
FILE_NAME_TGZ=${FILE_NAME}.tgz

if [ ! -f $MG_DIR/${FILE_NAME_TGZ} ]; then
	wget --no-check-certificate -O $MG_DIR/${FILE_NAME_TGZ} https://fastdl.mongodb.org/linux/${FILE_NAME_TGZ}
	echo "wget --no-check-certificate -O $MG_DIR/${FILE_NAME_TGZ} https://fastdl.mongodb.org/linux/${FILE_NAME_TGZ}"
fi

if [ ! -d $MG_DIR/${FILE_NAME} ];then 
	cd $MG_DIR && tar -zxvf ${FILE_NAME_TGZ}
fi

if [ ! -d  $serverPath/mongodb/bin ];then
	mkdir -p $serverPath/mongodb
	cd $MG_DIR/${FILE_NAME} && cp -rf ./bin $serverPath/mongodb
fi
#!/bin/bash
# Author: wanghan
# Created Time : Fri 28 Apr 2017 04:04:09 PM CST
# File Name: mybootimage2miui.sh
# Description:

#定义变量
BOOTTOOL_PATH=$(cd `dirname $0`; pwd) # 获取本脚本文件所在的路径
MIUIBOOT_PATH=${BOOTTOOL_PATH}/miui
MYBOOT_PATH=${BOOTTOOL_PATH}/my
NEWBOOT_OUTPUT_PATH=.

#help
function help()
{
	echo "Usage:"
	echo "      mybootimage2miui.sh [my boot.img] [miui boot.img] [output_path]"
}

#检查是否有boot.img
function check_boot()
{
	echo "checking bootimage ..."

	if test -e ${MYBOOT_PATH}/boot.img
	then
		echo "${MYBOOT_PATH}/boot.img exist."
	else
		echo "${MYBOOT_PATH}/boot.img not exist!"
		exit -1
	fi

	if test -e ${MIUIBOOT_PATH}/boot.img 
	then
		echo "${MIUIBOOT_PATH}/boot.img exist."
	else
		echo "${MIUIBOOT_PATH}/boot.img not exist!"
		exit -1
	fi
}

#解包
function unboot_img()
{
	#解包miui boot.img
	${BOOTTOOL_PATH}/mkboot ${MIUIBOOT_PATH}/boot.img ${MIUIBOOT_PATH}/output_miui
	#解包我的 boot.img
	${BOOTTOOL_PATH}/mkboot ${MYBOOT_PATH}/boot.img ${MYBOOT_PATH}/output_my
}

#替换
function replace_kernel()
{
	rm ${MIUIBOOT_PATH}/output_miui/kernel
	cp ${MYBOOT_PATH}/output_my/kernel ${MIUIBOOT_PATH}/output_miui
}

#打包
function boot_img()
{
	${BOOTTOOL_PATH}/mkboot ${MIUIBOOT_PATH}/output_miui ${NEWBOOT_OUTPUT_PATH}/boot.img
}

#清空文件
function clean()
{
	rm -rf ${MYBOOT_PATH}
	rm -rf ${MIUIBOOT_PATH}
}

#主函数
function main()
{

	#检查是否有boot.img
	check_boot
	#解包
	unboot_img
	#替换
	replace_kernel
	#打包
	boot_img
	#清空文件
	clean

	echo "done."
}

#RUN
echo "\$# is $#"
if [ $# -lt 2 -o $# -gt 3 ]
then
	help
	exit -1
fi
mkdir -p ${MYBOOT_PATH}
mkdir -p ${MIUIBOOT_PATH}
cp $1 ${MYBOOT_PATH}
echo "MYBOOT_PATH is ${MYBOOT_PATH}"
cp $2 ${MIUIBOOT_PATH}
echo "MIUIBOOT_PATH is ${MIUIBOOT_PATH}"
if [ ! $3 ]
then
	NEWBOOT_OUTPUT_PATH=.
	echo "NEWBOOT_OUTPUT_PATH is `pwd`"
else
	NEWBOOT_OUTPUT_PATH=$3
	echo "NEWBOOT_OUTPUT_PATH is $3"
fi
main



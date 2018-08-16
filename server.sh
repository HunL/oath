#!/bin/sh
DAPP_ROOT_DIR=`dirname $0`
SCRIPTS_DIR=${DAPP_ROOT_DIR}/scripts/unix

UNAME=`uname`
PLATFORM=unknow

# Mac
if [ $UNAME = "Darwin" ] ; then
    echo "Platform: Darwin"
    PLATFORM=Darwin
# Linux
elif [ $UNAME = "Linux" ] ; then
    echo "Platform: Linux"
    PLATFORM=Linux
fi

fun_start ()
{
    ${DAPP_ROOT_DIR}/script/start.sh
}

#fun_stop ()
#{
#    ${DAPP_ROOT_DIR}/bin/$1 stop
#}

# 使用说明
fun_usage ()
{
    echo ""
    echo "用法: "
    echo "$0 动作 [选项]"
    echo "动作: "
    echo "  start       启动节点"
#    echo "  stop        停止节点"
    echo ""
    echo "选项: "
    echo "  -h, --help  显示本信息"
    echo ""
}

# parse command line parameters
while [ $# -ne 0 ] ; do
    PARAM=$1
    shift
    case ${PARAM} in
        --) break ;;
        --help|-h) fun_usage; exit 0;;
        *) ARGS="${ARGS} ${PARAM}" ;;
    esac
done

set -- ${ARGS}
ACTION=$1
shift
case ${ACTION} in
    '') fun_usage;;
    'start') fun_start $1;;
#    'stop') fun_stop $1;;
    *) echo "参数错误！"; fun_usage; exit 1;;
esac

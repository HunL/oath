#!/bin/sh
DAPP_ROOT_DIR=`dirname $0`
SCRIPTS_DIR=${DAPP_ROOT_DIR}/scripts/unix

UNAME=`uname`

geth --rpc 
     --rpcaddr 127.0.0.1 
     --port 10071 
     --rpcport 10070 
     --rpcapi "personal,db,eth,net,web3" 
     --datadir "/home/jeff/work/ethereum/oath/chain" 
     console 2>>eee.log


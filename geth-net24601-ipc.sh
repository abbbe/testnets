#!/bin/sh -x

NAME=geth-net24601-ipc

BASEDIR=`dirname $0`
DATADIR="$HOME/data/$NAME"

#GETH=/Users/abb/Documents/dvp/tools/go-ethereum/build/bin/geth
GETH=geth
IPCPATH=$DATADIR/geth.ipc
GENESIS=$BASEDIR/geth-net24601.json
GETH_ARGS="--datadir $DATADIR --verbosity 4 --nodiscover --nodiscover --netrestrict 172.18.0.0/24,192.168.0.0/24 --targetgaslimit 7500000 --rpc --rpcport 8545 --rpcaddr 0.0.0.0 --rpccorsdomain '*' --port 31313"

case $1 in
	run)
		if [ ! -d $DATADIR ] ; then
			$GETH --datadir $DATADIR init $GENESIS
			$GETH $GETH_ARGS --exec "loadScript('$BASEDIR/geth-initaccounts.js')" console
		fi

		$GETH $GETH_ARGS --mine --minerthreads 1 --unlock 0,1,2,3,4,5 --password /dev/null console
		;;

	fund)
		$GETH $GETH_ARGS --exec "loadScript('$BASEDIR/geth-fundaccounts.js')" attach $IPCPATH
		;;

	attach)
		$GETH attach $IPCPATH
		;;
esac


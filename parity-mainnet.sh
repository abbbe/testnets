#!/bin/sh -x

NAME=parity-mainnet

PORT=31313
UIPORT=18180
RPCPORT=18545
WSPORT=18546
PORTSHIFT=10000
DATADIR=$HOME/data/$NAME

case $1 in
	restart)
		$0 kill
		$0 rm
		$0 run
		;;

	run)
		mkdir -p $DATADIR
		docker run -d --net mynet --ip 172.18.0.11 --name $NAME -p 127.0.0.1:$UIPORT:$UIPORT -p 127.0.0.1:$RPCPORT:$RPCPORT -p 127.0.0.1:$WSPORT:$WSPORT \
			-p $PORT:30303/tcp -p $PORT:30303/udp \
			-v $DATADIR:/root/.local/share/io.parity.ethereum \
			parity/parity:stable-release --ui-interface all --jsonrpc-interface all --ws-interface all --ws-origins http://localhost:$UIPORT \
				--ports-shift $PORTSHIFT
		;;

	kill)
		docker kill $NAME
		;;

	start)
		docker start $NAME
		;;

	rm)
		docker rm $NAME
		;;

	#wipe)
	#	rm -rf "$DATADIR"
	#	;;

	attach)
		docker attach --sig-proxy=false --no-stdin $NAME
		;;

	sh)
		docker exec -it $NAME /bin/sh
		;;

	logs)
		docker logs --follow $NAME
		;;

	new-token)
		docker exec $NAME /parity/parity signer new-token
		;;
esac

#!/bin/sh -x

NAME=parity-net24601

PORT=34343
UIPORT=48180
RPCPORT=48545
WSPORT=48546
PORTSHIFT=40000
DATADIR=$HOME/data/$NAME

case $1 in
        restart)
                $0 kill
                $0 rm
                $0 run  
                ;;      

	run)
		mkdir -p $DATADIR
		cp parity-net24601.json $DATADIR
		docker run -d --net mynet --ip 172.18.0.17 --name $NAME -p 127.0.0.1:$UIPORT:$UIPORT -p 127.0.0.1:$RPCPORT:$RPCPORT -p 127.0.0.1:$WSPORT:$WSPORT \
			-v $DATADIR:/root/.local/share/io.parity.ethereum \
			parity/parity:stable-release --ui-interface all --jsonrpc-interface all --ws-interface all --ws-origins http://localhost:$UIPORT \
				--ports-shift $PORTSHIFT --chain=/root/.local/share/io.parity.ethereum/parity-net24601.json --tracing=on --fat-db=on --pruning=archive -ldiscovery,tpc=trace
		# -p $PORT:30303/tcp -p $PORT:30303/udp \
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

	wipe)
		rm -rf "$DATADIR"
		;;

	attach)
		docker attach --sig-proxy=false --no-stdin $NAME
		;;

	sh)
		docker exec -it $NAME /bin/bash
		;;

	logs)
		docker logs --follow $NAME
		;;

	new-token)
		docker exec $NAME /parity/parity signer new-token
		;;
esac


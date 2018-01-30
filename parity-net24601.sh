#!/bin/sh -x

NAME=parity-net24601
BASEDIR=`dirname $0`
DATADIR=$HOME/data/$NAME

PORT=34343
UIPORT=48180
RPCPORT=48545
WSPORT=48546
SSHPORT=40022
PORTSHIFT=40000

case $1 in
        restart)
                $0 kill
                $0 rm
                $0 run
                $0 logs
                ;;

        reinit)
                $0 kill
                $0 rm
                $0 wipe
                $0 init
                $0 run
                $0 logs
                ;;

	run)
		mkdir -p $DATADIR
		cp $BASEDIR/parity-net24601.json $DATADIR/
		docker run -d --privileged --net mynet --ip 172.18.0.17 --name $NAME \
			-p 127.0.0.1:$UIPORT:$UIPORT -p 127.0.0.1:$RPCPORT:$RPCPORT -p 127.0.0.1:$WSPORT:$WSPORT -p 127.0.0.1:$SSHPORT:22 \
			-v $DATADIR:/root \
			parity/parity:stable-release --ui-interface all --jsonrpc-interface all --ws-interface all --ws-origins http://localhost:$UIPORT --allow-ips private \
				--ports-shift $PORTSHIFT --chain=/root/parity-net24601.json --tracing=on --fat-db=on --pruning=archive -ldiscovery,tpc=trace
		# -p $PORT:30303/tcp -p $PORT:30303/udp \
		docker exec $NAME hwclock -s
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


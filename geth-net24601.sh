#!/bin/sh -x

NAME=geth-net24601
#PORT=30303
#RPCPORT=8545

BASEDIR=`dirname $0`
DATADIR="$HOME/data/$NAME"

DOCKER_RUN_INIT="docker run --rm  -v $DATADIR:/root --name $NAME ethereum/client-go:stable --networkid 24601"
DOCKER_RUN="docker run -d --privileged --net mynet --ip 172.18.0.18 -v $DATADIR:/root --name $NAME ethereum/client-go:stable --networkid 24601"

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

	init)
		mkdir -p $DATADIR && cp $BASEDIR/geth-genesis.json $BASEDIR/geth-initaccounts.js $DATADIR/
		$DOCKER_RUN_INIT init /root/geth-genesis.json
		$DOCKER_RUN_INIT --exec "loadScript('/root/geth-initaccounts.js')" console
                ;;
	run)
		$DOCKER_RUN --mine --minerthreads 1 --unlock 0,1,2,3,4,5 --password /dev/null \
 			--nodiscover --netrestrict 172.18.0.0/24 --rpc --rpcaddr 0.0.0.0 --rpccorsdomain "*" --verbosity 5
		# -p $PORT:30303/tcp -p $PORT:30303/udp \ -p 127.0.0.1:$RPCPORT:8545/tcp \
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
		rm -rf $DATADIR
		;;

	attach)
		docker exec -it $NAME geth attach /root/.ethereum/geth.ipc
		;;

	logs)
		docker logs --follow $NAME
		;;

	sh)
		docker exec -it $NAME /bin/sh
		;;
esac


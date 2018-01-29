#!/bin/sh -x

NAME=geth-mainnet
PORT=35353
RPCPORT=58545

DATADIR=$HOME/data/$NAME

case $1 in
        restart)
                $0 kill
                $0 rm
                $0 run  
                ;;      

	run)
		mkdir -p $DATADIR
		docker run --net mynet --ip 172.18.0.15 -d -v $DATADIR:/root/.ethereum --name $NAME \
			-p $PORT:30303/tcp -p $PORT:30303/udp -p 127.0.0.1:$RPCPORT:8545/tcp \
			ethereum/client-go:stable --port $PORT --cache 1024 --rpc --rpcaddr 0.0.0.0 --rpccorsdomain "*"
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
		docker exec -it $NAME geth attach
		;;

        logs)
                docker logs --follow $NAME
                ;;
	sh)
		docker exec -it $NAME /bin/sh -i
                ;;
esac


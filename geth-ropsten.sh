#!/bin/sh -x

NAME=geth-ropsten
PORT=33333
RPCPORT=38545

DATADIR=$HOME/data/$NAME

case $1 in
        restart)
                $0 kill
                $0 rm
                $0 run  
                ;;      

	run)
		mkdir -p $DATADIR
		docker run -d --net mynet --ip 172.18.0.13 -v $DATADIR:/root/.ethereum --name $NAME \
			-p $PORT:30303/tcp -p $PORT:30303/udp \
			-p 127.0.0.1:$RPCPORT:8545/tcp \
			ethereum/client-go:stable --testnet --cache 1024 --rpc --rpcaddr 0.0.0.0 --rpccorsdomain "*"
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
	#	rm -rf $DATADIR
	#	;;

	attach)
		docker exec -it $NAME geth attach /root/.ethereum/testnet/geth.ipc
		;;

	logs)
		docker logs --follow $NAME
		;;

	sh)
		docker exec -it $NAME /bin/sh
		;;

	unlock)
		echo "personal.unlockAccount('0xe2dbc1817a18d345d051a348cef998f3c14c2033', 'password', 999999)" |
			docker exec -i $NAME geth attach /root/.ethereum/testnet/geth.ipc
		;;
esac


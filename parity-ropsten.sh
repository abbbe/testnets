#!/bin/sh -x

NAME=parity-ropsten

PORT=32323
UIPORT=28180
RPCPORT=28545
WSPORT=28546
PORTSHIFT=20000
DATADIR=$HOME/data/$NAME

ROPSTEN_ENODE="enode://26707157d3c9e2dc252d4acc7a4fde51af9e0107da60c9d55819831cc31e2689e05fe8d32d869d286c38407583619b2c82ece10db464914c9ae704a41bf7dd5c@188.138.33.235:33333"

case $1 in
	restart)
		$0 kill
		$0 rm
		$0 run
		;;

	run)
		mkdir -p $DATADIR
		docker run -d --net mynet --ip 172.18.0.12 --name $NAME -p 127.0.0.1:$UIPORT:$UIPORT -p 127.0.0.1:$RPCPORT:$RPCPORT -p 127.0.0.1:$WSPORT:$WSPORT -p $PORT:30303/tcp -p $PORT:30303/udp \
			-v $DATADIR:/root/.local/share/io.parity.ethereum \
			parity/parity:stable-release --ui-interface all --jsonrpc-interface all --ws-interface all --ws-origins http://localhost:$UIPORT \
				--ports-shift $PORTSHIFT --chain ropsten # --bootnodes $ROPSTEN_ENODE
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

	logs)
		docker logs --follow $NAME
		;;

        sh)
                docker exec -it $NAME /bin/sh
                ;;

        new-token)
                docker exec $NAME /parity/parity signer new-token
                ;;
esac


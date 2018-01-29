#!/bin/sh -x

NAME=ipfs

export ipfs_staging=/home/abb/data/ipfs_staging
export ipfs_data=/home/abb/data/ipfs_data

case $1 in
        restart)
                $0 kill
                $0 rm
                $0 run  
                ;;      

	run)
		docker run -d --name $NAME -v $ipfs_staging:/export -v $ipfs_data:/data/ipfs -p 4001:4001 -p 127.0.0.1:8080:8080 -p 127.0.0.1:5001:5001 ipfs/go-ipfs:latest
		;;

	logs)
		docker logs -f $NAME
		;;

	kill)
		docker kill $NAME
		;;

	exec)
		shift
		docker exec $NAME $*
		;;
esac


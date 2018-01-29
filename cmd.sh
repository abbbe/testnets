#!/bin/sh -x

for cmd in geth-mainnet.sh geth-rinkeby.sh parity-mainnet.sh parity-kovan.sh ; do
	./$cmd $*
done


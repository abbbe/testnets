#!/bin/sh -x

for p in 0 1 2 3 4 5; do
	ssh -L ${p}8180:localhost:${p}8180 -L ${p}8545:localhost:${p}8545 -L ${p}8546:localhost:${p}8546 -f -N eth3
done


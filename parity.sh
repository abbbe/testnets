#!/bin/sh -x

# https://github.com/paritytech/parity

"/Applications/Parity Ethereum.app/Contents/MacOS/parity" --chain=parity-config.json --tracing=on --fat-db=on --pruning=archive -ldiscovery,tpc=trace


#!/bin/bash
set -e
ARGS=$@
SEED=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes 3)$(date +%s)
cd $DIR
/usr/local/beast/bin/beast -working -seed $SEED -statefile "$SEED"_$FILE.state -prefix "$SEED"_ $ARGS $FILE

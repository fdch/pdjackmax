#!/bin/bash

export MAINDIR="$(dirname ${BASH_SOURCE[0]})"
source ${MAINDIR}/.env/exports.sh

echo 0 > ${STATUS}

killall pd
killall Pd
killall Max
killall jackd

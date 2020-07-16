#!/bin/sh

if [[ ! $# ]]; then 
	export MAINDIR="$(dirname ${BASH_SOURCE[0]})/.."
	source ${MAINDIR}/.env/exports.sh
fi

jackd -d ${AUDIODEVICE} -r ${SAMPLERATE}  2>&1 &
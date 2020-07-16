#!/bin/sh

export MAINDIR="$(dirname ${BASH_SOURCE[0]})"
source ${MAINDIR}/.env/exports.sh

rm ${TMPDIR}/.*
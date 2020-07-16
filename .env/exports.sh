#!/bin/bash

export MAX=/Applications/Max.app
export ACCADAOO=/Applications/AccadAoo.app
export PDEXEC=${ACCADAOO}/Contents/Resources/bin/pd
export PDPATCH=${ACCADAOO}/Contents/Resources/patch/ezaoo.pd
export MAXPATCH=none
export TMPDIR=${MAINDIR}/.tmp
export BINDIR=${MAINDIR}/bin
export SETTINGS=${MAINDIR}/settings
export PDSTART=${BINDIR}/pd_start.sh
export JACKSTART=${BINDIR}/jack_start.sh
export JACKROUTE=${BINDIR}/jack_route.sh
export MAXFILE=${TMPDIR}/.maxpatch
export USERFILE=${TMPDIR}/.username
export JACKTEST=${TMPDIR}/.jackversion
export STATUS=${TMPDIR}/.status

if [[ ! -f ${USERFILE} ]]; then
	whoami > ${USERFILE}
fi

export USERNAME=`cat ${USERFILE}`

source ${SETTINGS}
source ${BINDIR}/routines.sh
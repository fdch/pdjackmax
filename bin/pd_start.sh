#!/bin/bash

if [[ ! $# ]]; then
	export MAINDIR="$(dirname ${BASH_SOURCE[0]})/.."
	source ${MAINDIR}/.env/exports.sh
fi

${PDEXEC} ${PDGUI} -jack -r ${SAMPLERATE} -channels ${PDCHANS} -send "\
; username symbol ${USERNAME} \
; group_join symbol ${GROUPNAME} \
; hostname symbol ${HOSTNAME} \
; port ${PORT} \
; compression ${COMPRESSION} \
; bufsize ${BUFSIZE} \
; packetsize ${PACKETSIZE} \
; timefilter ${TIMEFILTER} \
; send_to symbol ${SEND_TO} \
; receive_from symbol ${RECEIVE_FROM} \
; connect-set ${AUTOCONNECT} \
; start-set ${AUTOSTART} \ 
" -open "${PDPATCH}"  2>&1 &
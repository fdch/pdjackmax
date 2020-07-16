#!/bin/sh

step_one() {
	if [[ `cat ${STATUS}` == 1 ]]; then 
		step_three
	else
		clear
		echo "Hi, ${USERNAME}!"
		echo "Welcome to the PD-JACK-MAX routing setup wizard."
		echo "Please follow these instructions."
		echo "See the README for more information."
		echo
		jack_check
		echo "--- 1. CONNECT AUDIO INTERFACE USB CABLE"
		if [[ `prompt "Is your interface connected?"` == 1 ]]; then
			step_two
		else
			step_one
		fi
	fi
}

step_two () {
	echo "--- 2. CONNECTING YOUR SYSTEM AUDIO TO THE INTERFACE"
	echo
	echo "Set both INPUT and OUTPUT to your audio interface"
	echo "Opening up your Sound Preference Panel..."
	echo "...or alt+click the sound icon and select your interface."
	# read -p "Hit return to continue" p
	sleep 1
	open -b com.apple.systempreferences /System/Library/PreferencePanes/Sound.prefPane
	if [[ `prompt "Is your in/output set to your interface?"` == 1 ]]; then
		step_three
	else
		step_two
	fi
}

step_three () {
	echo "--- 3. STARTING JACK SERVER"
	if pgrep jackd; then
		echo "Jack is already running."
	else
		jackd -d ${AUDIODEVICE} -r ${SAMPLERATE} > ${TMPDIR}/.jacklog 2>&1 &
		sleep 5
	fi
	step_four
}


step_four () {
	echo "--- 4. OPENING MAX/MSP"
	if [[ ! -d ${MAX} ]]; then
		echo "You dont seem to have Max installed."
		echo "Install it and come back. Goodbye."
		exit
	fi
	open_maxpat "${MAXPATCH}"
	step_five
}


step_five() {
	echo "--- 5. Waiting 25 seconds for Max to load..."
	local count=1
	while true; do
		if [[ `jack_lsp | grep Max` ]] ; then
			echo "Success: Max is connected to Jack."; break
		else
			sleep 1
			if [[ `expr $count % 25` -eq 0 ]]; then
				if [[ `prompt "Is Max's DSP on?"` == 1 ]]; then
					break;
				else
					echo "Open Max's Audio Status and select JackRouter"
				fi
			fi
			((count++))
		fi
	done
	step_six
}


step_six () {
	echo "--- 6. OPENING PURE DATA"
	if [[ ! -d ${ACCADAOO} ]]; then
		echo "You dont seem to have AccadAoo installed."
		echo "Download it and place it on your /Applications folder"
		echo "Redirecting you to github.com/fdch/AccadAoo ..."
		sleep 1
		open https://github.com/fdch/AccadAoo/releases
		if [[ `prompt "Is AccadAoo on your /Applications folder?"` == 1 ]]
		then
			step_six
		fi
	fi
	if [[ `prompt "Is <${USERNAME}> your correct username?"` == 0 ]]; then
		change_name
		step_six
	else
		echo "Waiting 25 seconds until pd is loaded."
		# sh ${PDSTART} 1 2>&1 &
		${PDEXEC} -noprefs ${PDGUI} -jack -r ${SAMPLERATE} -channels ${PDCHANS} -send "\
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
		" -open "${PDPATCH}"  > ${TMPDIR}/.pdlog 2>&1 &
		sleep 25
		step_seven
	fi
}

step_seven() {
	echo "--- 7. ROUTING MAX AND PD"
	disconnect_all
	sh ${JACKROUTE}  > ${TMPDIR}/.jackroutelog  2>&1
	echo 1 > ${STATUS}
	if [[ `prompt "Reroute?"` == 1 ]]; then
		step_seven
	else
		step_eight
	fi
}

step_eight () {
	echo "--- 8. SETUP FINISHED"
	echo "You can exit this terminal window now..."
	echo "... and remember to double-click on the 'stop.command' to stop all."
	if [[ `prompt "Do you wish to exit?"` == 1 ]]; then
		echo "Goodbye."
		sleep 1
		exit
	else
		step_eight
	fi
}

connect () {
	echo jack_connect $1 $2
	jack_connect $1 $2
}

disconnect () {
	echo jack_disconnect $1 $2
	jack_disconnect $1 $2
}

disconnector () {
	local f=$3
	for i in `jack_lsp | grep $1`; do
		disconnect ${i} ${2}${f}
		((f++))
	done
}

disconnect_all () {
	disconnector capture pure_data:input
	disconnector pure_data:output system:playback_ 1
	disconnector capture Max:in 1
	disconnector Max:out system:playback_ 1
}

prompt () {
	while true; do
    read -p "$1 (y/n): " yn
    case $yn in
        [Yy]* ) echo 1; break;;
        [Nn]* ) echo 0; break;;
    esac
	done
}

change_name () {
	while true; do
	read -p "Type in your name:" n
		USERNAME="$n"
		echo "$n" > ${USERFILE}; break
	done
}

open_maxpat () {

	if [[ -f ${MAXFILE} ]]; then
		MAXPATCH=$(cat ${MAXFILE})
	fi

	if [[ "${MAXPATCH}" == "none" ]]; then
		while true; do
			read -p "Drag and drop a Max patch here and hit return: " p
			EXT=$(basename "${p}" | cut -f2 -d. )
			if [[ ! -f "${p}" ]] || [[ "${EXT}" != "maxpat" ]] ; then
				echo "--- <$(basename "${p}")> does not exist or is not a .maxpat"
				open_maxpat; break
			else
				echo "${p}" > ${MAXFILE}
				open_maxpat; break
			fi
		done
	else
		MAXPATCHBASE=$(basename "${MAXPATCH}")
		if [[ `prompt "Do you wish to open ${MAXPATCHBASE}?"` == 1 ]]; then
			echo "Opening ${MAXPATCHBASE}..."
			open -a ${MAX} "${MAXPATCH}"
		else 
			echo none > ${MAXFILE}
			open_maxpat
		fi
	fi
}

jack_check () {
	if [[ ! -f ${JACKTEST} ]]; then
		echo "--- Checking Jack..."
		if [[ ! -f `which jackd` ]]; then
			echo "--- JACK IS NOT INSTALLED HERE..."
			echo "Please install Jack2 on OSX."
			echo "Restart your computer after installation."
			echo "Run this script again once you have jack installed."
			echo "Redirecting you to www.jackaudio.org. Goodbye"
			sleep 3
			open "https://jackaudio.org/downloads"
			exit
		else
			jv=$(jackd --version | grep -n jackdmp | grep 1: | cut -f 2 -d ' ')
			if [[ "$jv" != "1.9.11" ]] ; then 
				echo "--- Warning: jackdmp version mismatch."
				echo "Required: 1.9.11. Found: $jv"
			fi
			echo "$jv" > ${JACKTEST}
			echo "Jack is version $jv. All is good."
		fi
	fi
}

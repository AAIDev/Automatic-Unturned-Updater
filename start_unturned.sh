#!/bin/sh

#This process starts the Unturned server.

SERVER_NAMES=(
""
""
) #Name of your TMUX sessions
SCREEN_NAMES=(
""
""
) #Names of your server
ROCKET_START_DIR="" #The directory of the start.sh program installed when Rocketmod is first installed.
count=0
while [ "x${SCREEN_NAME[count]}" != "x" ]		
do
	count=$(( $count + 1 ))
	if ! tmux ls | grep -q {SCREEN_NAME[count]}; then 
		echo "Unturned server successfully started"
		unset TMUX #We need to do this in order to be able to start the unturned server from another session later.
		tmux new -s {SCREEN_NAME[count]} -d
		tmux send-keys -t {SCREEN_NAME[count]} "$ROCKET_START_DIR {SERVER_NAMES[count]}" C-m
	else
		echo "Server already started"
	fi
done	


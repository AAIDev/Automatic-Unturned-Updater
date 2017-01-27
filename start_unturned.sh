#!/bin/sh

#This process starts the Unturned server.

SERVER_NAME="" #Name of your server
SCREEN_NAME="" #Name of your server
ROCKET_START_DIR="" #The directory of the start.sh program installed when Rocketmod is first installed.

if ! tmux ls | grep -q $SERVER_NAME; then 
	echo "Unturned server successfully started"
	unset TMUX #We need to do this in order to be able to start the unturned server from another session later.
   	tmux new -s $SERVER_NAME -d
	tmux send-keys -t $SCREEN_NAME "$ROCKET_START_DIR $SERVER_NAME" C-m
else
echo "Server already started"
fi

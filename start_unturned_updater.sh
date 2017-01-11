#!/bin/bash
#Script for starting updater process
#As before, the update script variable has to have the directory of the SH file.

UPDATESERVER_NAME=""
UPDATE_SCRIPT=""

if ! tmux ls | grep -q $UPDATESERVER_NAME; then 
	echo "Unturned update server successfully started"
   	tmux new -s $UPDATESERVER_NAME -d
	tmux send-keys -t $UPDATESERVER_NAME "$UPDATE_SCRIPT" C-m
else
echo "Server updater already started"
fi

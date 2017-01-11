#!/bin/bash
# This script installs / updates steamcmd and Unturned 3 on Linux machines
# Syntax: ./update.sh 
# Author: fr34kyn01535
# Modified by snowball7275
# Note: To make sure Steam Guard is not bugging you better create a new Steam account and disable Steam Guard

STEAM_USERNAME= #NO QUOTES HERE
STEAM_PASSWORD= #NO QUOTES HERE
STEAMCMD_HOME=""
UNTURNED_HOME=""

mkdir -p $STEAMCMD_HOME
mkdir -p $UNTURNED_HOME

cd $STEAMCMD_HOME
if [ ! -f "steamcmd.sh" ]; then
	wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
	tar -xvzf steamcmd_linux.tar.gz
	rm steamcmd_linux.tar.gz
fi

./steamcmd.sh +@sSteamCmdForcePlatformBitness 32 +login $STEAM_USERNAME $STEAM_PASSWORD +force_install_dir $UNTURNED_HOME +app_update 304930 validate +exit

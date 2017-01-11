#!/bin/bash
#An extremely poorly written update script made out of necessity.
#Requirements:
# - You run your server in a tmux session with a specific name
# - Update scripts and start scripts are provided, but you have to give the directories as to where they are.
#Note that for the unturned start and update scripts you have to provide not only the location of the SH files, but the actual files themselves in the variable.

ROCKET_API_KEY=""
UNTURNED_SCREEN_SESSION=""
UNTURNED_ROOT_DIRECTORY=""
UNTURNED_START_SCRIPT=""
UNTURNED_UPDATE_SCRIPT=""
STEAMCMD_DIR=""
STEAM_USER=  #NO QUOTES
STEAM_PASS=  #NO QUOTES
UNTURNED_ACF_LOCATION=""
update()
{
	rm -rf /root/bin/appcache
	
	cd $STEAMCMD_DIR
	./steamcmd.sh +login $STEAM_USER $STEAM_PASS +app_info_update 1 +app_info_print "304930" +app_info_print "304930" +quit | grep -EA 1000 "^\s+\"branches\"$" | grep -EA 5 "^\s+\"public\"$" | grep -m 1 -EB 10 "^\s+}$" | grep -E "^\s+\"buildid\"\s+" | tr '[:blank:]"' ' ' | tr -s ' ' | sed 's/buildid//g' | sed 's/ //g' > unturned_steam_version.txt
	cat $UNTURNED_ACF_LOCATION | grep "buildid" | sed 's/"buildid"//g' | sed 's/"//g' | tr -d '\t' > unturned_server_version.txt
	a="$(cat unturned_steam_version.txt)"
	b="$(cat unturned_server_version.txt)"
	if [ "$a" -gt "$b" ]; then
		echo "SERVER IS OUT OF DATE, SHUTTING DOWN"
		
		tmux send-keys -t $UNTURNED_SCREEN_SESSION "say \"SHUTTING DOWN IN FIVE SECONDS; UPDATING\"" C-m
		sleep 1
		tmux send-keys -t $UNTURNED_SCREEN_SESSION "say \"SHUTTING DOWN IN FOUR SECONDS; UPDATING\"" C-m
		sleep 1
		tmux send-keys -t $UNTURNED_SCREEN_SESSION "say \"SHUTTING DOWN IN THREE SECONDS; UPDATING\"" C-m
		sleep 1
		tmux send-keys -t $UNTURNED_SCREEN_SESSION "say \"SHUTTING DOWN IN TWO SECONDS; UPDATING\"" C-m
		sleep 1
		tmux send-keys -t $UNTURNED_SCREEN_SESSION "say \"SHUTTING DOWN IN ONE SECOND; UPDATING\"" C-m
		sleep 1
		tmux send-keys -t $UNTURNED_SCREEN_SESSION "shutdown" C-m
		
		echo "Getting newest rocketmod".
		
		cd $UNTURNED_ROOT_DIRECTORY
		wget http://api.rocketmod.net/download/unturned-linux/stable/$ROCKET_API_KEY/rocketmod.zip &> /dev/null
		if [ ! -f /root/unturned_server/rocketmod.zip ]; then
			echo "Directory not found, API either down or four calls have been used"
		fi
		
		mkdir rocketmod
		unzip rocketmod.zip -d rocketmod &> /dev/null
		
		echo "Copying over files"
		
		cd $UNTURNED_ROOT_DIRECTORY/rocketmod
		cp Modules $UNTURNED_ROOT_DIRECTORY --remove-destination &> /dev/null
		cp RocketLauncher.exe $UNTURNED_ROOT_DIRECTORY --remove-destination &> /dev/null
		cd ..
		rm rocketmod.zip
		rm -rf rocketmod
		cd ..
		
		echo "Updating and starting Unturned server"
		
		tmux kill-session -t $UNTURNED_SCREEN_SESSION
		sh $UNTURNED_UPDATE_SCRIPT
		sh $UNTURNED_START_SCRIPT

	else
		echo "SERVER IS UP TO DATE"
	fi
}

while true
do
	update
	sleep 300
done

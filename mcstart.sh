#!/bin/bash

# script to start mc server using simple configuration file

# project home: https://github.com/DreamsInAutumn/Minecraft-Server-Tools

# Declare Globals
	version=0.3.a
	configFile=mcstart.conf;
	arg1=$1;
	exitCode=0;

function readConf() {
 # Read variable passed as argument from config file
	eval $1=$(cat $configFile | grep $1 | cut -f2 -d=);
}


function initVars {
 # initialize variables
	readConf javaBin;
	readConf allocatedRAM;
	readConf javaArguments;
	readConf forgeVersion;
	readConf mcServerName;
	readConf restartTimer;
	readConf restartCount;
}

function displayHeader {
	echo "Starting $mcServerName Server";
	echo "RAM             : $allocatedRAM";
	echo "forge version   : $forgeVersion";
	echo -e "java arguments  : $javaArguments\n";
}

function displayFooter {
	echo "Restart Attempts Remaining : $restartCount"
	echo "Sleeping for $restartTimer seconds"
	echo "[CTRL + C] to exit before restart..."
}

function displayArgError {
	echo arguments
	echo "  -l run server in loop, it will restart $restartCount times if it crashes"
	echo "  -1 run server once until stopped"
}

function displayConfigError {
	echo "configuation file $configFile does not exist"
	echo exiting.
}

function startServer {
	$javaBin -jar -Xms$allocatedRAM -Xmx$allocatedRAM $javaArguments $forgeVersion.jar nogui
}

function _main {
	if [ -f "$configFile" ]; then
		initVars;
		case "$arg1" in
			"-l")	until [ "$restartCount" -lt "1" ]
				do
					displayHeader;
					startServer;
					readConf loopExit;
					if [ $loopExit == true ]; then
						echo "Forcefully exiting restart loop"
						exitCode=1;
						exit $exitCode;
					fi
					displayFooter;
					sleep $restartTimer;
					restartCount=$(($restartCount-1))
				done
				;;
			"-1")	displayHeader;
				startServer;
                	        ;;
	                *)      displayArgError;
        	                ;;
	        esac
	else
		displayConfigError;
	fi
}

_main;

exit $exitCode;

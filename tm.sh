#!/bin/bash

# init vars
	tmSession=
	tmConf=tm.conf

function readConf {
#	tmSession=$(cat tm.conf | grep session)
#	tmSession=$(echo $tmSession | cut -f2 -d=)
	tmSession=$(cat tm.conf | grep session | cut -f2 -d=)
}

function createSessionIfNotExist {
	tmux has-session -t $tmSession 2>/dev/null

	if [ $? != 0 ]; then
		echo "session $tmSession does not exist"
		echo creating new session: $tmSession
		tmux new-session -d -s $tmSession
	else
		echo "session $tmSession exists.."
	fi

}

function attachSession {
	tmux attach-session -t $tmSession
}

function _main {
	if [ -f "$tmConf" ]; then
		echo config file $tmConf found...
		readConf;
		createSessionIfNotExist;
		echo "entering session: $tmSession ..."
		sleep 3
		attachSession;
	else
		echo "configuation file $tmConf does not exist"
		echo exiting.
	fi
}

_main;
exit 0


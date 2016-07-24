#!/bin/bash
# from https://gist.github.com/jexp/8213614
# usage neo.sh [-h host:port] [-u user:pass] [cmd]
# end cypher statements with semicolon
# terminate read loop with ^d or return

HOST="localhost:7474"


if [ "$1" == "-h" ]; then
  shift; HOST="$1";shift;
fi
AUTH="-u neo4j:y2puv8VrUCHtAf"

if [ "$1" == "-u" ]; then
  shift; AUTH="-u $1";shift;
fi



URL="http://${HOST}/db/manage/server/console"
HEADERS=' -H accept:application/json -H content-type:application/json '

function run {
	CMD="$@"
	DATA="{\"command\":\"${CMD}\",\"engine\":\"shell\"}"
	RES=`curl -s $HEADERS $AUTH -d "$DATA" "$URL"`
# bash substitution
	RES=${RES#'[ "'}
	PROMPT_PATTERN="\", \"neo4j-sh (*)$ \" ]"
	RES=${RES%$PROMPT_PATTERN}
# continue reading, incomplete command
	if [ "$RES" == "\", \"> \" ]" ]; then 
		return 1; 
	else 
		echo -e "${RES//\\\\n/\\n}"
		return 0; 
	fi
}

P0="neo4j-sh (*)\$ "

if [ "$@" ]; then 
	run "$@";
	exit $?
fi

read -p "$P0" CMD;
while [ "$CMD" ]; do
	run "$CMD"
	if [ $? == 0 ]; then
		read -p "$P0" CMD;
	else
#continue reading, incomplete command
		read -p "> " CMD1;
		CMD="${CMD} ${CMD1}"
	fi
done

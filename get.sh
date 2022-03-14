#!/bin/bash

token=""
uri=""

if [ $# = 2 ]; then
	token=$1
	shift
elif [ $# = 1 ]; then
	if [ ! -f $HOME/.slack_token ]; then
        echo "No slack token in $HOME/.slack_token and token not passed as argument"
        exit -1
    fi
    token=$(cat $HOME/.slack_token)
else
	echo "Usage $0 [slack API token] URI"
	exit -1
fi

uri=$1

URL=$uri?token=$token

X=$(curl -s $URL)

echo $X


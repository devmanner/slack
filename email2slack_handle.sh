#!/bin/bash

token=""
email=""

if [ $# = 1 ]; then
	if [ ! -f $HOME/.slack_token ]; then
		echo "No slack token in $HOME/.slack_token and token not passed as argument"
		exit -1
	fi
	token=$(cat $HOME/.slack_token)
	email=$1
elif [ $# = 2 ]; then
	token=$1
	email=$2
else
	echo "Usage $0 [slack API token] email@domain.tld"
	echo "If slack token is ommitted it is taken from $HOME/.slack_token"
	exit -1
fi


URL=https://slack.com/api/users.list?token=$token

handle=$(curl -s $URL | jq '.members[].profile | select(.email=="'$email'")' | jq -r '.display_name')
if [ "$handle" = "" ]; then
	exit 1
fi
echo $handle

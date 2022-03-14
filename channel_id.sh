#!/bin/bash

token=""

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
    echo "Usage $0 [slack API token] channel-name"
    echo "Get the channel ID for a channel with name channel-name"
    echo "If slack token is ommitted it is taken from $HOME/.slack_token"
    exit -1
fi

channel=$1

cursor=""

while [ 1 ]; do
	channel_id_url="https://slack.com/api/conversations.list?token=$token&cursor=$cursor"

	id=$(curl -s $channel_id_url | jq -r '.channels[] | select(.name == "'$channel'") | .id') 

	if [ "$id" == "" ]; then
		cursor=$(curl -s $channel_id_url | jq -r '.response_metadata.next_cursor')
		if [ "$cursor" == ""  ]; then
			echo "Channel not found"
			exit -1
		fi
	else
		echo $id
		exit 0
	fi
done

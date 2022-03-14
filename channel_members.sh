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
	echo "List member ID:s of a channel"
    echo "If slack token is ommitted it is taken from $HOME/.slack_token"
    exit -1
fi

channel=$1
channel_id=$(./channel_id.sh $token $channel)

cursor=""
members=""
while [ 1 ]; do
	member_url="https://slack.com/api/conversations.members?token=$token&channel=$channel_id&cursor=$cursor"
	members=$members" "$(curl -s $member_url | jq -r '.members[]')
	cursor=$(curl -s $member_url | jq -r '.response_metadata.next_cursor')
	if [ "$cursor" == ""  ]; then
		echo $members | sed -e 's/ /\n/g'
		exit 0;
	fi
done


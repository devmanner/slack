#!/bin/bash

token=""
who=""
message=""

if [ $# = 2 ]; then
	if [ ! -f $HOME/.slack_token ]; then
		echo "No slack token in $HOME/.slack_token and token not passed as argument"
		exit -1
	fi
	token=$(cat $HOME/.slack_token)
	who=$1
	message=$2
elif [ $# = 3 ]; then
	token=$1
	who=$2
	message=$3
else
	echo "Usage $0 [slack API token] slack-handle message"
	echo "If slack token is ommitted it is taken from $HOME/.slack_token"
	exit -1
fi

URL=https://slack.com/api/chat.postMessage
temp_base=/tmp/slack_post_dm_
header=$(mktemp $temp_base"_header_XXXXXX.tmp")
chmod 600 $header
echo 'Authorization: Bearer '$token >> $header
echo 'Content-type: application/json; charset=utf-8' >> $header
data=$(mktemp $temp_base"_data_XXXXXX.tmp")

echo '{' >> $data
echo '"channel":"@'$who'",' >> $data
echo '"as_user":"true",' >> $data
echo '"blocks": [{"type": "section", "text": {"type": "mrkdwn", "text": "'$message'"}}]' >> $data
echo "}" >> $data

ret=$(curl -s -X POST -H @$header -d @$data $URL)
rv=$?

#rm -f $temp_base"*"

if [ $rv != 0 ]; then
	echo "Curl failure: $ret"
	exit -1
else
	api_rv=$(echo $ret | jq '.ok')
	if [ "$api_rv" = "true" ]; then
		exit 0
	else
		echo "Some error: "$ret
		exit 1
	fi
fi

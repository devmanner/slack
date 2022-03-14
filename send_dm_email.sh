#!/bin/bash

basedir=$(dirname $(readlink -f $0))

token=""
email=""

if [ $# = 3 ]; then
	token=$1
	shift
elif [ $# = 2 ]; then
	if [ ! -f $HOME/.slack_token ]; then
        echo "No slack token in $HOME/.slack_token and token not passed as argument"
        exit -1
    fi
    token=$(cat $HOME/.slack_token)
else
	echo "Usage $0 [slack API token] file_with_emails.txt message"
	echo "DM all users in a file."
    echo "If slack token is ommitted it is taken from $HOME/.slack_token"
	echo "Selector examples:"
	echo " * .profile.display_name : Display name of a user"
	echo " * .id : The ID os a user"
    exit -1
fi

email_file=$1
message=$2

for email in $(cat $email_file); do 
	id=$($basedir/email2X.sh $email .id)
	if [ "$id" == "" ]; then
		echo "Cannot find user: $email skipping"
	else
		echo "Sending message to $email ($id)"
		$basedir/slack_post_dm.sh $id "$message"
		sleep 10
	fi
done


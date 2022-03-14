#!/bin/bash

token=""
email=""
selector=""

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
	echo "Usage $0 [slack API token] email@domain.tld selector"
	echo "Read a field from someones slack profile. Search by email"
    echo "If slack token is ommitted it is taken from $HOME/.slack_token"
	echo "Selector examples:"
	echo " * .profile.display_name : Display name of a user"
	echo " * .id : The ID os a user"
    exit -1
fi

email=$1
selector=$2

URL=https://slack.com/api/users.list?token=$token

X=$(curl -s $URL | jq '.members[] | select(.profile.email=="'$email'")' | jq -r $selector)

echo $X


#!/bin/bash

layout() {
	setxkbmap -query | awk 'FNR == 3 {print $2}'
}

if [ $(layout) == "us" ];
then
	echo "Changed to de"
	setxkbmap -layout de
elif [ $(layout) == "de" ];
then 
	setxkbmap -layout latam
else
	echo "Changed to us"
	setxkbmap -layout us
fi

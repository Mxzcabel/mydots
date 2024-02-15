#! /bin/bash
# Description: A humble script to change how mpvpaper behavior plays mp4 videos
# Programmer: Mxzcabel
# Follow me on Github: https:/github.com/mxzcabel
# Date: 24/08/2023
#
#
#
dir=$HOME/Videos/Wallpapers
list=my-playlist-mpvpaper.txt
video_list=$(ls -1 $dir | awk "/mp4$/{print}" > $dir/$list)
number_onlist=$(cat -n $dir/$list | tail -1 | grep -o "[0-9][^.]")
wish_number=$1
playlist=0

function playnum() {
	name_onlist=$(cat $dir/$list | awk "NR==$wish_number")
	printf '%s\n' "Playing now: $name_onlist"
	mpvpaper -p -f -o "auto-start --loop vf-add=fps=30:round=near input-ipc-server=/tmp/mpvpaper" DVI-D-1 $dir/$name_onlist
}

function playfull() {
	printf '%s\n' "Playing full list."
	mpvpaper -p -f -o "auto-start --loop-playlist vf-add=fps=30:round=near input-ipc-server=/tmp/mpvpaper" DVI-D-1 $dir
}

function start() {
	printf '%s\n' "Directory in use: $dir"
	printf '%s\n' "Videos inside directory: $number_onlist"
	if [ -z $wish_number ] || [ $wish_number -lt 0 ] || [ $wish_number -gt $number_onlist ] ; then
		printf '%s\n' "You need to input a number valid on the list or change to playlist all!"
		exit 2
	else
		if [ -n "$(pidof mpvpaper)" ] ; then kill -9 $(pidof mpvpaper) ; fi
		if [ $wish_number -eq 0 ] ; then playlist=1 ; fi
	fi

	[ $playlist -eq 0 ] && playnum || playfull
	rm $dir/$list
}

test $wish_number -eq $wish_number 2>/dev/null && start || echo "You need to type a valid integer number!";exit 2

#!/bin/sh
#
#
# This script depends on 'fuzzel'


UPV=/tmp/upd_versions

[ "$(cat ${UPV})" = "refreshing" ] && exit 1

fzz() {
	fuzzel -d -w 80 -R --font=monospace:size=9 --background=111111EE \
		--border-color=111111FF --selection-color=111111EE --text-color=999999AA \
		--selection-text-color=999999DA --log-level=none --log-no-syslog "$1"
}

if [ -s ${UPV} ]
then
	fzz --prompt="[Updates: $(cat ${UPV} | wc -l)] " < ${UPV} > /dev/null
else
	checkupdates -n |
		fzz --prompt="[Updates: $(checkupdates -n | wc -l) (offline)] " > /dev/null
fi

###

# Of course you could use any dmenu implementation - here's an example using 'wofi'
# (please comment out lines 25 and 26 inside 'updbar.sh' first:
#
# 		#[ ! -x /usr/bin/fuzzel ] &&
# 		#	menu="[on click: *please install 'fuzzel'*]\n[right-click: refresh db]" ||)
#
# Example using 'wofi':
#
#
#UPV=/tmp/upd_versions
#
#[ "$(cat ${UPV})" = "refreshing" ] && exit 1
#
#if [ -s ${UPV} ]
#then
#	wofi -d -O alphabetical --prompt="[Updates: $(cat ${UPV} | wc -l)] " < ${UPV} > /dev/null
#else
#	checkupdates -n |
#		wofi -d -O alphabetical --prompt="[Updates: $(checkupdates -n | wc -l) (offline)] " > /dev/null	
#fi
#

# Source code: "https://bbs.archlinux.org/viewtopic.php?id=279522"

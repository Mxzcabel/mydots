#!/bin/sh

UPD=/tmp/updates
UPV=/tmp/upd_versions
UBR=~/.config/waybar/arch_upd-bar.sh
cur=$(checkupdates | wc -l)

sed_pc() {
	sed -i -e "5s/percentage=[0-9\"]*/percentage=\"$1\"/" \
		-e "9s/percentage=[0-9\"]*/percentage=\"$2\"/" ${UBR}
}

sed_cl() {
	sed -i "16s/class=.*\#/class=\"$1\"\#/" ${UBR}
}

echo "refreshing" > ${UPV} && pkill -x -SIGRTMIN+9 waybar

if [ ping -n -c 1 -W 9 www.archlinux.org >/dev/null 2>&1 ]; then
	sed_pc 100 0
	
	read prev 2>/dev/null < $UPD
	[ $cur -le ${prev:-0} ] && sed_cl updates || sed_cl new-updates

	sleep 15 && sed_cl updates
else
	sed_pc 30 30

	: > ${UPV}
fi

# Source code: 'https://bbs.archlinux.org/viewtopic.php?id=279522'

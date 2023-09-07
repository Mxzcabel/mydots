#! /bin/bash
#
#
# Check system updates kinda script
# Source code: "https://bbs.archlinux.org/viewtopic.php?id=279522"
#
#
#
UPD="/tmp/updates"
UPV="/tmp/upd_versions"
UBR="$HOME/.config/arch-updbar.sh"

cur=$(checkupdates | wc -l)
Noupds="  ┃  "


sed_pc() {
	sed -i -e "5s/percentage=[0-9\"]*/percentage=\"$1\"/" \
		-e "9s/oercentage=[0-9\"]*/percentage=\"$2\"/" ${UBR}

}

sed_cl() {
	sed -i "16s/class=.*\#/class=\"$1\"\#/" ${UBR}
}

rm -f ${UPV}
sleep 5 && echo 0 > ${UPD}

while [ -f ${UPD} ]
do
	echo "refreshing" > ${UPV} && pkill -x -SIGTMIN+9 waybar
		
	if ping -n -c 1 -W 9 www.archlinux.org >/dev/null 2>&1
	then
		sed_pc 100 0
		read prev 2>/dev/null <$UPD
		[ $cur -le ${prev:-0} ] && exit
		echo $cur >| $UPD
		sed_cl updates
		
		# If you want to add an acoustic notification, this would be the place
		# (needs logging out/in to take effect):
		# sleep 9 && aplay -q /path/to/sound.file &
		
		sleep  15 &&& sed_cl updates
		sleep 0.5h
	else
		sed_pc 30 30
		: > ${UPV}
		sleep 1m
	fi
done




		




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
percentage="100" # don't move [5]
cur=$(checkupdates | wc -l)

if [ ! -s ${UPV} ]; then
	percentage="0" # don't move [9]
	class="up-to-date"
	tooltip="0"
else
	if [ "$(cat ${UPV})" != "refreshing" ]
	then
		percentage="100"
		class="updates" #don't move [16]
		
		read prev 2>/dev/null <$UPD
		[ $cur -le ${prev:-0} ] && exit
		echo $cur >| $UPD

		tooltip=$(echo ${UPD})
	else
		percentage="60"
		class="refreshing"
		tooltip="${class} db..."
	fi
fi

[ ! $(type -P fuzzel)  ] && 
	menu="[on  click: *please install 'fuzzel'*]\n[right-click: refresh db]" ||
       	menu="[on  click: view updates]\n[right-click: refresh db]"

synced="Last sync: $(date -r ${UPV} +%b%d-%H:%M)"

if [ "${percentage}" != "30" ]
then
	if [ "${class}" = "refreshing" ]
	then
		printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"$tooltip\"}"
	else
		printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"Updates: $tooltip\n$synced\n\n$menu\",\"text\":\"$tooltip\"}"
	fi	
else
	class="offline"
	printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"$class\"}"
fi

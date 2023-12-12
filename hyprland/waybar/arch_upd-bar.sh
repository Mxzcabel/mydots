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
cur=$(checkupdates -n)
curn=$(checkupdates -n | wc -l)

printf "%s" "$curn" > "$UPD" ; [ $(cat $UPD) -eq $(cat $UPD) ] && printf "%s" "$cur" > "$UPV" || truncate -s 0 $UPV

if [ ! -s ${UPV} ]; then
	percentage="0" # don't move [9]
	class="up-to-date"
	tooltip="0"
else
	if [ "$(cat ${UPV})" != "refreshing" ]; then
		percentage="100"
		class="updates" #don't move [16]
		tooltip=$(cat $UPD)
	else
		percentage="60"
		class="refreshing"
		tooltip="${class} db..."
	fi
fi

[ ! $(type -P fuzzel)  ] && 
	menu="On  click: *please install 'fuzzel'*\nRight-click: refresh db" ||
       	menu="On  click: view updates\nRight-click: refresh db"

synced="Last sync: $(date -r ${UPV} +%d/%b-%H:%M)"

if [ "${percentage}" != "30" ]
then
	[ $tooltip == "0" ] && toolOTP="" || toolOTP=$(echo $tooltip)

	if [ "${class}" = "refreshing" ]
	then
		printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"$toolOTP\"}"
	else
		printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"Updates: $tooltip\n$synced\n\n$menu\",\"text\":\"$toolOTP\"}"
	fi	
else
	class="offline"
	printf '%s\n' "{\"class\":\"$class\",\"percentage\": $percentage,\"tooltip\":\"$class\"}"
fi

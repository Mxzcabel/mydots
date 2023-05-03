#! /bin/bash
#----------------------------------------------------------------------------
# Description: A simple script to make my joystick configuration
# Programmer: Mxzcabel
# Follow me on Github: https://github.com/mxzcabel
# Date: 03/05/2023
#----------------------------------------------------------------------------
# Make a list of all input devices
# and cut to show only device name
#----------------------------------------------------------------------------
joypad_input=$(ls /dev/input/by-id/* | cut -d'/' -f5)
#----------------------------------------------------------------------------
# Make a list of all input devices and cut to show only event name
#----------------------------------------------------------------------------
joypad_event=$(ls -l /dev/input/by-id/* | awk '{print $11}')
#----------------------------------------------------------------------------
# Find the usb event name on list
#----------------------------------------------------------------------------
joypad_event_name=$(echo usb-ZEROPLUS_Controller-event-joystick)
#----------------------------------------------------------------------------
# Take a look on current events and joypad's name on system
# to find mimic pad one
# echo "Get all array and place in a variable: " joypad_names=("${array[@]}")
# echo "Show sometihg on array: " ${joypad_names[1]}
array=([0]='Microsoft X-Box 360 pad' [1]='Xbox 360 Wireless Receiver')
joypad_names=("${array[@]}")
proc_device="/proc/bus/input/devices"
#----------------------------------------------------------------------------
# Also make the initial make-sure-variable here for search on list later
#----------------------------------------------------------------------------
joypad_exists=""
get_wireless=0
#----------------------------------------------------------------------------
# First things first, search for a actual mimic pad in progress
#----------------------------------------------------------------------------
function mimic_xpad() {
	for joypad in "${joypad_names[@]}"
	do
    	local mimic=$(cat $proc_device | awk '/'"$joypad"'/{print $1}')
	    if [ -n "$mimic" ] ; then
			joypad_exists=$(echo "$joypad")
			return 1
	    fi
	done
	return 0
}
#----------------------------------------------------------------
# Get the actual number of lines from mimic and simplify
# the overview of current mimic event
#----------------------------------------------------------------
function show_xpad() {
	nline_xpad=$(cat $proc_device | awk '/'"$joypad_exists"'/{print NR}')
    ((nline_xpad=nline_xpad + 4))
	getnline_xpad=$(cat $proc_device | head -n $nline_xpad | tail -n 1 | cut -d'=' -f2 | cut -d' ' -f1)
   	echo -n "| xpad name: " $joypad_exists
	echo " | xpad event: " "/"$getnline_xpad
}
#----------------------------------------------------------------
# Display Help and possible arguments
# Gives a hand on rough and repetitive tasks
#----------------------------------------------------------------
displayHelp() {
	echo "#####"
	echo "Script to start mimic xpad with xboxdrv"
	echo "#####"
	echo "options:"
	echo "-h, --help		display this help"
	echo "-w, --wireless		set mimic-xpad as wireless"
	echo "-e, --event-name	show joypad event name on script"
	echo "-j, --joypads		show joypad names on script"
	echo "-k, --kill-pid		kill previous mimic event"
}
arguments() {
	case "$1" in 
		-h | --help) 
			displayHelp
			exit 0
			;;
		-k | --kill-pid) 
			kill -9 $(pidof xboxdrv)
			exit 0
			;;	
		-w | --wireless)
			get_wireless=1
			;;
		-e | --event-name)
			echo $joypad_event_name
			exit 0
			;;
		-j | --joypads)
			echo ${joypad_names[*]}
			exit 0
			;;
		-*)
			if [ ! -z "$1" ] ; then
				echo "not a valid command"
				exit 1
			fi
			;;
	esac
}
arguments "$1"
#----------------------------------------------------------------------------
# Search for a current progress and if not there (-eq 1) then create here
#----------------------------------------------------------------------------
mimic_xpad
if [ $? -eq 0 ] ; then
	#----------------------------------------------------------------
	# Var for find and get the event on list
	# if not there, display error message in the end
	#----------------------------------------------------------------
	joypad_getEvent=""
	#----------------------------------------------------------------
	# Identation to research the joypad_event_name inside var
	#----------------------------------------------------------------
	for event in $joypad_input
	do
		# echo $event
		#----------------------------------------------------------------
		# Count the current time code had go through list
		#----------------------------------------------------------------
		((++count))
	 	if [ $event == "$joypad_event_name" ] ; then
			echo "found it!"
			#----------------------------------------------------------------
			# Catch the event on the list and take the two dots out.
			# The count is along whitespaces cause every item on list 
			# are "split in" by those criterias. 
			#----------------------------------------------------------------
			joypad_getEvent=$(echo $joypad_event | cut -d' ' -f $count | sed -e 's/^..//')
			echo "The event is: " $joypad_getEvent
			#---------------------------------------------------------------
			# Set on/off wireless joypad option
			#----------------------------------------------------------------
			if [ $(echo "$get_wireless") == "1" ] ; then 
				is_wireless=$(echo "--mimic-xpad-wireless")
			else 
				is_wireless=$(echo "--mimic-xpad")
			fi
			#----------------------------------------------------------------
			# Config of the xmap and calibration for mimic
			#----------------------------------------------------------------
	        $(xboxdrv --evdev /dev/input/$joypad_getEvent \
    	    --silent \
       	    --axismap -Y1=Y1,-Y2=Y2 \
        	--calibration x1=-32767:0:32767,y1=-32767:0:32767,x2=-32767:0:32767,y2=-32767:0:32767 \
	        --detach-kernel-driver \
			$is_wireless \
        	--evdev-absmap ABS_X=x1,ABS_Y=y1,ABS_Z=x2,ABS_RZ=y2,ABS_RX=lt,ABS_RY=rt,ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y \
           	--evdev-keymap BTN_EAST=a,BTN_C=b,BTN_SOUTH=x,BTN_NORTH=y,BTN_WEST=lb,BTN_Z=rb,BTN_SELECT=tl,BTN_START=tr,BTN_MODE=guide,BTN_TL2=back,BTN_TR2=start >&0 &)
			sleep 3
			mimic_xpad
			show_xpad
			break
		fi		
	done
	 
	if [ -z "$joypad_getEvent" ] ; then
		echo "No joypad is connected or some sort of error happened!" 
		exit 2
	fi
else
	echo "There's already a mimic map for xbox360 on events."
	show_xpad
	exit 2
fi

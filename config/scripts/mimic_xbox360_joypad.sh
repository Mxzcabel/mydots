#! /bin/bash
#----------------------------------------------------------------------------
# Description: A simple script to make my joystick configuration
# Programmer: Ravenbells
# Follow me on Github: https://github.com/ravenbells
# Date: 04/04/2023
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
joypad_name=$(echo Microsoft X-Box 360 pad)
proc_device="/proc/bus/input/devices"
#----------------------------------------------------------------------------
# First things first, search for a actual mimic pad in progress
mimic_xpad=$(cat $proc_device | awk '/'"$joypad_name"'/{print $1}')
#---------------------------------------------------------------------------- 
count=0
#----------------------------------------------------------------------------
# Search for a current progress and if not there (-z) then create
#----------------------------------------------------------------------------
if [ -z $mimic_xpad ] ; then
	#----------------------------------------------------------------
	# Var for find and get the event on list
	# if not there, reset the counter
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
			#----------------------------------------------------------------
			# Config of the xmap and calibration for mimic
			#----------------------------------------------------------------
			$(xboxdrv --evdev /dev/input/$joypad_getEvent \
			--silent \
			--calibration x1=-32767:0:32767,y1=32767:0:-32767,x2=-32767:0:32767,y2=32767:0:-32767 \
			--detach-kernel-driver \
			--mimic-xpad \
			--evdev-absmap ABS_X=x1,ABS_Y=y1,ABS_Z=x2,ABS_RZ=y2,ABS_RX=lt,ABS_RY=rt,ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y \
			--evdev-keymap BTN_EAST=a,BTN_C=b,BTN_SOUTH=x,BTN_NORTH=y,BTN_WEST=lb,BTN_Z=rb,BTN_SELECT=tl,BTN_START=tr,BTN_MODE=guide,BTN_TL2=back,BTN_TR2=start >&0 &)
			sleep 3
			break
		fi		
	done
	 
	if [ -z "$joypad_getEvent" ] ; then
		count=0
	fi
else
	echo "There's already a mimic map for xbox360 on events."
fi
#----------------------------------------------------------------
# Get the actual number of lines from mimic and simplify
# the overview of current mimic event
#----------------------------------------------------------------
if  [ $count != "0" ] || [ -n $mimic_xpad ] ; then
		nline_xpad=$(cat $proc_device | awk '/'"$joypad_name"'/{print NR}')
		((nline_xpad=nline_xpad + 4))
		getnline_xpad=$(cat $proc_device | head -n $nline_xpad | tail -n 1 | cut -d'=' -f2 | cut -d' ' -f1)
		echo -n "| xpad name: " $joypad_name
		echo " | xpad event: " "/"$getnline_xpad
else
		echo "No joypad is connected or some sort of error happened!"
fi 

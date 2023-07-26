#! /bin/bash
# open polybar in both monitors
flock 200
killall -q polybar
#-----------------
#xrandr alternative:
#outputs=$(xrandr --query | grep -w "connected" | cut -d" " -f1)
#----------------
outputs=$(polybar --list-monitors | cut -d":" -f1)
#---------------
for monitors in $outputs; do
	MONITOR=$monitors polybar --reload top -c ~/.config/polybar/config.ini &	
done
disown




function fish_right_prompt
    def_cmdDuration
    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -q VIRTUAL_ENV
    and set -l venv (string replace -r '.*/' '' -- "$VIRTUAL_ENV")

    set_color normal
    string join " " -- $venv $duration $vcs $d
end

# Set my time configuration
function def_cmdDuration
	set secs (math -s2 "$CMD_DURATION / 1000")
	set mins (math -s2 "$secs / 60")
	set hrs  (math -s2 "$mins / 60")
	set time (set_color purple)" 󱑂 "(date +"%I:%M|%p")
	
    	if test $CMD_DURATION -ge (math "1000 * 60")
		printf '\n%s' $time (set_color brblack)" 󰔚 $mins minutes"
        	notify-send -a Terminal -i /usr/share/icons/alacritty.png "$history[1]" "Returned $status, took $mins minutes"
	else if test $CMD_DURATION -ge (math "1000 * 3600")
		printf '\n%s' $time (set_color brblack)" 󰔚 $hrs hours"
		notify-send -a Terminal -i /usr/share/icons/alacritty "$history[1]" "Returned $status, took $hrs hours"
	else
		printf '%s' $time (set_color brblack)" 󰔚 $secs secs"
    	end
end

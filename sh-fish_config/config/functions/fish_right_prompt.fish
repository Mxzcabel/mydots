function fish_right_prompt
    set -g colortime 		purple
    set -g colorcd	 	brblack
    set -g colorfg		2A1624
    set -g colorbblue		333399
    set -g colorback		fff

    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -q VIRTUAL_ENV
    and set -l venv (string replace -r '.*/' '' -- "$VIRTUAL_ENV")
    if test $venv 
	    set_color -b $colorgrey
	    set_color $colorblank
	    printf '%s\e' "󰇙󱞟󰇙" (set_color $colorback)
	    set_color -b $colorbblue 
    	    printf '%s' \ueb70 (string join " " -- $venv $duration $vcs $d) " "
	    set_color -b $colorfg
	else
    	    prompt_settings_init $colorfg
    end

    def_cmdDuration $colortime $colorcd $colorfg
    prompt_settings_end $colorfg

    # Set OTP back to normal color
    set_color $colorback
end
    # Set my time configuration
function def_cmdDuration
	set secs (math -s2 "$CMD_DURATION / 1000")
	set mins (math -s2 "$secs / 60")
	set hrs  (math -s2 "$mins / 60")
	set time (set_color $argv[1])" 󱑂 "(date +"%I:%M|%p")
	set_color $argv[3] 

	if test $CMD_DURATION -ge (math "1000 * 3600")
		printf '\n%s' $time (set_color $argv[2])" 󰔚 $hrs|hrs"
		notify-send -a Terminal -i /usr/share/icons/alacritty "$history[1]" "Returned $status, took $hrs hours"
	else if test $CMD_DURATION -ge (math "1000 * 60")
		printf '\n%s' $time (set_color $argv[2])" 󰔚 $mins|mins"
        	notify-send -a Terminal -i /usr/share/icons/alacritty.png "$history[1]" "Returned $status, took $mins minutes"
	else
		printf '%s' $time (set_color $argv[2])" 󰔚 $secs|secs"
    	end
end

function fish_prompt
    # set -l prompt_symbol '$'
    set -l user_char "󰭟  "
	set secs (math "$CMD_DURATION / 1000")
	set mins (math "$secs / 60")
	set time (set_color purple)" 󱑂"\t(date +"%I:%M %p")
	set flags (set_color red)" 󰃄|󰃄"
	echo -s \n" "\
	(set_color yellow)"|"\
	(set_color green)" 󱞊"\t(prompt_pwd)\
	(set_color cyan)" 󰊢"(fish_git_prompt)
	if test $CMD_DURATION
    	if test $CMD_DURATION -ge (math "1000 * 60")
			echo -s $flags $time (set_color cd764d)" \; 󰔚 $mins minutes"
        	notify-send "$history[1]" "Returned $status, took $mins minutes"
		else
			echo -s $flags $time (set_color cd764d)" \; 󰔚 $secs secs"
    	end
	end
	echo -s (set_color white)" "$user_char
end


## Font
# https://codeyarns.com/tech/2013-06-29-how-to-get-notification-on-long-duration-command-completion-in-fish.html

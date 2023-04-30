function fish_prompt
    # set -l prompt_symbol '$'
    set -l user_char "󰭟  "
	set secs (math -s2 "$CMD_DURATION / 1000")
	set mins (math -s2 "$secs / 60")
	set flags (set_color red)" 󰃄|󰃄"
	set time (set_color purple) " 󱑂"\t(date +"%I:%M %p")
	if echo "$hostname" -eq "rapidseedbox.com" > /dev/null
	    echo -s (set_color 0091ff)" |"\t rapid(set_color green)seedbox(set_color 0091ff).com
	else
	    echo -s (set_color f77a6a)" |"\t $hostname
	end
	echo -s (set_color yellow)" |"\
	(set_color green)" 󱞊"\t (prompt_pwd)\
	(set_color cyan)" 󰊢"(fish_git_prompt)
	if test $CMD_DURATION
	    if test $CMD_DURATION -ge (math "1000 * 60")
	    	echo -s $flags $time " " (set_color cd764d)" \; 󰔚 $mins minutes"
 	    else
		echo -s $flags $time " " (set_color cd764d)" \; 󰔚 $secs secs"
	    end
	end
	echo -s (set_color white)" "$user_char
end


## Font
# https://codeyarns.com/tech/2013-06-29-how-to-get-notification-on-long-duration-command-completion-in-fish.html

function fish_prompt
    # set -l prompt_symbol '$'
    set -l user_char "󰭟  "
	set secs (math "$CMD_DURATION / 1000")
	echo -s \n" "\
	(set_color yellow)"|"\
	(set_color green)\t(prompt_pwd)\
	(set_color cyan)" |"(fish_git_prompt)\
	\n" "\
	(set_color red)"󰃄|󰃄"\
	(set_color purple)\t(date +"%I:%M %p")\
	(set_color grey)" | $secs secs"
	if test $CMD_DURATION
    	if test $CMD_DURATION -gt (math "1000 * 60")
        notify-send "$history[1]" "Returned $status, took $(math "$secs / 60 ") minutes"
    	end
	end
	echo -s (set_color white)" "$user_char
end


## Font
# https://codeyarns.com/tech/2013-06-29-how-to-get-notification-on-long-duration-command-completion-in-fish.html

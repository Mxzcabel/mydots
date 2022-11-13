function fish_prompt
    # set -l prompt_symbol '$'
    set -l user_char ' ﬌'\t
    	if fish_is_root_user
		set prompt_symbol ''
    	end	
    echo -s \n(set_color yellow) c----C----c----C---c---C---c---C--c--C-c-C----C----c----C----c----C \
    \n(set_color green)"|"$USER" "" "$hostname \
    "|"(set_color purple)(prompt_pwd)(set_color purple) \
    "|"(set_color red)$(date +"%A - %I:%M %p")"|" \
    \n(set_color yellow) c----C----c----C---c---C---c---C--c--C-c-C----C----c----C----c----C
    echo -s (set_color purple) \n $prompt_symbol \
    \n(set_color blue) \n $user_char
end

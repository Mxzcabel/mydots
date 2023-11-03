function fish_prompt
	# Set prompt variables # 
	set -g prompt_symbol normal #color for fish prompt
	set -g fish_prompt_pwd_dir_length 1 # lenght of pwd's path
	## A set of colors to use ##
	set -g colorblank white
	set -g colornegra black
	set -g colorverde green
	set -g coloramr   yellow
	set -g colorgrey  222222
	set -g colorvin   36171f
	## A set of git prompt defaults ##
	set -g __fish_git_prompt_show_informative_status 1
	set -g __fish_git_prompt_showuntrackedfiles 1
        set -g __fish_git_prompt_showcolorhints 0
    	set -g __fish_git_prompt_use_informative_chars 1	
	set -g __fish_git_prompt_showupstream informative
	set -g __fish_git_prompt_describe_style contains
    	set -g __fish_git_prompt_char_dirtystate " "
    	set -g __fish_git_prompt_char_untrackedfiles " "
    	set -g __fish_git_prompt_char_cleanstate "  "
	set -g __fish_git_prompt_char_stashstate " ᛩ"
	set -g __fish_git_prompt_char_invalidstate "#,✖"
    	##-- The git prompt's default format is ' (%s)'. --##
	##-- We don't want the leading space. --##
	#
	# Define PWD's output #
	set_color $prompt_symbol $colorgrey
	prompt_settings_init
	set_color $prompt_symbol -b $colorgrey
	printf '%s'\
	(set_color $colorverde)"󱞊 "(prompt_pwd | sed 's/~/ᛠ/')
    	set_color $prompt_symbol -b normal
	set_color $prompt_symbol $colorgrey
	prompt_settings_end
	#
	# Define Git's output #
	if test (fish_git_prompt)
		set_color $prompt_symbol $colorvin
		prompt_settings_init
		set_color $prompt_symbol -b $colorvin
		printf '%s'\
		(set_color $coloramr)\ue5fb(fish_git_prompt)
		set_color $prompt_symbol -b normal
		set_color $prompt_symbol $colorvin
		prompt_settings_end
	end
	#
	# Set user_char #   	
	prompt_configs
end
#
# Function user_char #
#
##-- Function here defines char and a cool blackground among powerlines glyphs --##
function prompt_configs
	set_color $prompt_symbol $colornegra
	prompt_settings_init
    	set_color $prompt_symbol -b $colornegra
	prompt_settings_char
        set_color $prompt_symbol $colorblank
	set_color $prompt_symbol -b normal
    	set_color $prompt_symbol $colornegra
        prompt_settings_end
end
#
# User_char settings #
##-- The inital char for bg left tweak --##
function prompt_settings_init	
   printf '\n%s' \ue0ba
end
#
##-- The actual char used --##
function prompt_settings_char	
    printf '%s' "󱓩 󱀝"\uf101 \uf101
end
#
##-- The final char for bg right edge --##
function prompt_settings_end
    printf '%s' \ue0b0
end
#
# Font #
# https://codeyarns.com/tech/2013-06-29-how-to-get-notification-on-long-duration-command-completion-in-fish.html

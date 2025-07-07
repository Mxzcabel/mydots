function fish_prompt
	# Set prompt variables # 
	set -g prompt_text normal #color for fish prompt
	set -g fish_prompt_pwd_dir_length 1 # lenght of pwd's path
	## A set of colors to use ##
	set -g colorblank 	  white
	set -g colornegra 	  black
	set -g colorverde 	  green
	set -g coloramr   	  yellow
	set -g colorgrey  	  222222
	set -g colorlisgrey 	3f3f3f
	set -g colorvin   	  36171f
	set -g colorlisvin  	80374a
	## A set of git prompt defaults ##
  set -g __fish_git_prompt_show_informative_status 1
  set -g __fish_git_prompt_showuntrackedfiles 1
  set -g __fish_git_prompt_showcolorhints 0
  set -g __fish_git_prompt_use_informative_chars 1	
	set -g __fish_git_prompt_showupstream informative
	set -g __fish_git_prompt_describe_style contains
  set -g __fish_git_prompt_char_dirtystate " 󱇧 "
  set -g __fish_git_prompt_char_untrackedfiles " 󰝒 "
	set -g __fish_git_prompt_char_stagedstate " 󱀺 "
  set -g __fish_git_prompt_char_cleanstate " 󰈖"
	set -g __fish_git_prompt_char_stashstate " 󰈠 "
	set -g __fish_git_prompt_char_invalidstate " 󰮘 "
    	##-- The git prompt's default format is ' (%s)'. --##
	##-- We don't want the leading space. --##
	#
	# Define PWD's output #
	#
	## Breaker's char ##
	prompt_settings_char normal "breaker" "none"
	##
	prompt_settings_init $colorgrey
	prompt_settings_char $colorverde "prompt_pwd"
	prompt_settings_end $colorgrey
	#
	# Define Git's output #
	if test (fish_git_prompt)		
		## Breaker's char ##
		prompt_settings_char $colorlisgrey "breaker"
		##
		prompt_settings_init $colorvin
		prompt_settings_char $coloramr "prompt_git"
		prompt_settings_end $colorvin
		##
		## Breaker's char ##
		prompt_settings_char $colorlisvin "breaker"
		##
	else
		## Breaker's char ##
		prompt_settings_char normal "breaker" "none"
		##
	end	
	#
	# Function user_char #
	prompt_settings_init $colornegra
	prompt_settings_char $colorblank "prompt_symbols"
        prompt_settings_end $colornegra
end
#
# Prompt settings #
##-- Functions here defines char and a cool background among powerlines glyphs --##
#
##-- The inital char for bg left tweak --##
function prompt_settings_init	 
   color_setting_text $argv[1]
   printf '%s' \ue0ba
   color_setting_bg $argv[1]
end
#
##-- The actual char used --##
function prompt_settings_char
    ### Set color --###
    color_setting_text $argv[1]
    ###
    ###-- Set which prompt to use and how --###
    switch $argv[2]
	    case "prompt_symbols"
    		printf '%s' "🗁 🞜 "\uf101 ' '

	    case "prompt_pwd"
		printf '%s' "󱞊 "(prompt_pwd | sed 's/~/ᛠ/')

	    case "prompt_git"
             	printf '%s' \ue5fb(fish_git_prompt)

	    case "breaker"
		  if test $argv[3] -a $argv[3] = "none"
			  printf '\n%s'
		  else
			  printf '\n%s\n' \ueb6e\ueb6e\ueb6e\ueb6e\ueb6e\ueb6e\ueb6e\ueb6e\ueb6e\ueb6e\ueb6e\ueb6e\ueb6e
		  end
    end
end
#
##-- The final char for bg right edge --##
function prompt_settings_end
    color_setting_bg normal
    color_setting_text $argv[1]   
    printf '%s' \ue0b0
end
#
##-- Set the prompt colors for text and background --##
function color_setting_text
   set_color $prompt_text $argv[1]
end

function color_setting_bg
   set_color $prompt_text -b $argv[1]
end

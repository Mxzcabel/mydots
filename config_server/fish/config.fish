## Set values
# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | batcat -l man -p'"

## Export variable need for qt-theme
# if type "qtile" >> /dev/null 2>&1
#   set -x QT_QPA_PLATFORMTHEME "qt5ct"
# end

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin || test -d ~/.cargo/bin
    if not contains -- ~/.local/bin $PATH
        set -xp PATH ~/.local/bin
	set -xp PATH ~/.local/bin/node_modules-global
	set -xp PATH ~/.local/bin/python_bins
    end
    if not contains -- ~/.cargo/bin
	set -xp PATH ~/.cargo/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end


## Starship prompt
# if status --is-interactive
#   source ("/usr/bin/starship" init fish --print-full-init | psub)
# end


## Advanced command-not-found hook
## source /usr/share/doc/find-the-command/ftc.fish


## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

## Useful aliases
# Replace ls with exa
# alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -aG --git --color=always --group-directories-first --icons'   # all files and dirs
alias lla='exa -la --header --git --color=always --group-directories-first --icons' # all and long format
alias llab='exa -la --header --git --color=always --group-directories-first --icons | batcat' # all, long format, bat stdin
alias ll='exa -l --header --git --color=always --group-directories-first --icons'   # long format
alias lt='exa -aT --header --git  --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a --header --git | grep -e '^\.'"                                    # show only dotfiles
alias ip="ip -color"

# Replace some more things with better alternatives
# alias cat='bat --style header --style snip --style changes --style header'
# [ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# Common use
alias grubup="sudo update-grub"
alias upapt="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
alias inpkg="sudo apt install "
alias rmpkg="sudo apt remove "
alias tarnow='tar -acf '
alias untar='tar -xvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias nano='nano -l'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                          # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"     # Sort installed packages according to size in MB
alias bat="batcat" # Make bat as batcat instead of bacula-console-qt

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"


## Run fastfetch if session is interactive
if status --is-interactive && type -q neofetch
   neofetch
end


# Personal Functions

	# System Management

	alias whoiscompositor="inxi -Gxx | grep compositor"

	# File Manager
	
	alias sudo="sudo "
	# alias ll="ls -l"
	# alias la="ls -a"
	# alias lla="ls -a -l"
	# alias lltr="ls -ltr"
	alias llata="ls -alt -A"
	alias llatra="ls -altr -A"
	alias llarta="ls -altr -A"
	alias extglob="shopt -s extglob"
	alias xpg_echo="shopt -s xpg_echo"
	alias find_latest_modified_by_date="find . -maxdepth 1 -newrmt"
        
	# Calibre - (sudo -v &&)

	alias update_calibre="wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin"

	# Git

	alias gitlog="git log --oneline"
	alias gitcommit="git commit -m"

	# Nodejs Projects
	
	alias local_node_dep_bins="ls ~/Documents/a-Projects/node_dependencies/node_modules/.bin/* | xargs ln -sf -t ~/.local/bin/node_modules-global/"


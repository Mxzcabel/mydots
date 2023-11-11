## Set values
# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x LESSUTFCHARDEF "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p"
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat --paging=always -l man -p'"
#set -x MANPAGER "vim -M +MANPAGER -"

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
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
	set -p PATH ~/.local/bin/node_modules-BotDiscord
	set -p PATH ~/.local/bin/node_modules-global
	set -p PATH ~/.local/bin/python_bins
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
alias l="exa -G --color=always --group-directories-first --icons" # list files and dirs except hidden ones
alias la='exa -aG --git --color=always --group-directories-first --icons'   # all files and dirs
alias lla="exa -la --header --git --color=always --group-directories-first --icons" # all and long format 
alias llab="exa -la --header --git --color=always --group-directories-first --icons | bat" # all, long format, bat stdin
alias ll='exa -l --header --git --color=always --group-directories-first --icons'   # long format
alias lt='exa -aT --header --git  --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a --header --git | grep -e '^\.'"                                    # show only dotfiles
alias ip="ip -color"

# Replace some more things with better alternatives
# alias cat='bat --style header --style snip --style changes --style header'
# [ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# Common use
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -xvf '
alias wget='wget -c '
alias rmpkg="sudo pacman -Rdd"
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias nano='nano -l'
alias rm='rm -I '
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
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages

# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Help people new to Arch
# alias apt='man pacman'
# alias apt-get='man pacman'
# alias please='sudo'
# alias tb='nc termbin.com 9999'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"


## Run fastfetch if session is interactive
#if status --is-interactive && type -q neofetch
#   neofetch
#end


# Personal Functions

	# Systemctl Management

	alias logout="systemctl restart lemurs"
	alias shutd="shutdown -h now"
	alias hibernate="systemctl hibernate"
	alias sleep="systemctl suspend"

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
	alias batp="bat --plain --style grid,header"
	alias pacman="sudo pacman"
	alias pacrmdeps="pacman -Qqdt | sudo pacman -R -"
	alias extglob="shopt -s extglob"
	alias xpg_echo="shopt -s xpg_echo"
	alias find_latest_modified_by_date="find . -maxdepth 1 -newrmt"
        
	# Bar, Widgets, System Monitor, etc
		# alias polybar="~/.config/polybar/launch.sh"
	
	# Calibre - (sudo -v &&)
	alias calibre_install="wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin"

	# Git

	alias gitlog="git log --oneline"
	alias gitcommit="git commit -m"

	# Games

	alias lol_bypass_cheat="sudo sysctl -w abi.vsyscall32=0"

	# Nodejs Projects
	
	alias local_node_bins="ls ~/Documents/a-Projects/botDiscord/node_modules/.bin/* | xargs ln -sf -t ~/.local/bin/node_modules-BotDiscord/"
	alias local_node_dep_bins="ls ~/Documents/a-Projects/node_dependencies/node_modules/.bin/* | xargs ln -sf -t ~/.local/bin/node_modules-global/"


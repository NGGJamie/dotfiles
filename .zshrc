# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-navigation-tools zsh-interactive-cd)


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

export EDITOR="vim"
export BROWSER="firefox"


function viewpkg {
	if [ -z $1 ]; then
		echo "Please supply the name of a package to view"
		return
	fi
	URL=$(echo "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=$1")
	echo "Downloading PKGBUILD for $1"
	curl -s -q "$URL" >/tmp/pkgbuild
	vim /tmp/pkgbuild
	rm /tmp/pkgbuild
}

function ifup {
	if [ -z "$1" ];
	then
		echo "No device specified";
		return
	fi
	sudo ip link set "$1" up;
}

function ifdown {
	if [ -z "$1" ];
	then
		echo "No device specified";
		return
	fi
	sudo ip link set "$1" down;
}

# Always export display var
export DISPLAY=":0"

# Reset pulseaudio
alias reset-pa="pulseaudio -k; pulseaudio --start"

# Press a key specified X times.
alias press="xdotool key --repeat"

# Convenient youtube-dl music downloading
alias yt-mp3="youtube-dl --add-metadata -x --audio-quality 256k --audio-format mp3 "

# Easy wine prefixes
alias wp32='wineserver -k; export WINEPREFIX="$(pwd)"; export WINEDEBUG=-all; export WINEARCH=win32; wineboot;'
alias wp64='wineserver -k; export WINEPREFIX="$(pwd)"; export WINEDEBUG=-all; export WINEARCH=win64; wineboot;'

# Retain env in sudo
#alias sudo="sudo -E"

alias obmenu="obmenu3"
alias resetmon="rm /tmp/rez.lock;$HOME/setHz.sh"

alias dust="du -d 1 -h | sort -h | tail -n 15 2>/dev/null"

alias vim="nvim"
alias win-reboot="sudo grub-reboot 2;sudo systemctl -i reboot"
alias vibrc="vim $HOME/.bashrc; . $HOME/.bashrc"
alias thun="thunar ."
alias jpv="mpv --alang=jpn --sid=no"
alias apv="mpv --alang=jpn --slang=en"
alias venv="python3 -m venv env; . env/bin/activate"
alias pip="python3 -m pip"
alias cdtmp="cd $(mktemp -d)"
function cdtmp {
  TMP="$(mktemp -d)"
  cd "$TMP"
}
alias yay="MAKEFLAGS=\"j6\" yay"
alias py="python3"


eval "$(thefuck --alias)"

autoload -U colors && colors
source $ZSH/oh-my-zsh.sh
#PS1="%B%{$fg[red]%}%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}:%~%{$fg[red]%}%{$reset_color%}$%b "
PS1='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fortune | lolcat
echo
echo "Today's weather:"
if [[ ! -f /tmp/wttr ]]; then
	$HOME/weather.sh
fi

cat /tmp/wttr

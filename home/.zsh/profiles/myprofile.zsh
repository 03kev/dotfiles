# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

#PS1="%n@%m: %1~ %# " Default
m="$(scutil --get LocalHostName)"
#PS1="%n@${m:7}: %1~ %# " My custom

# Name with ... if the directory is too long
setopt PROMPT_SUBST
chpwd() { 
  if [[ $PWD == $HOME ]]; then
    dir_name="~"
  else
    dir_name=$(basename $PWD)
    if (( ${#dir_name} > 15 )); then
    	dir_name="${dir_name[1,15]}..."
		#dir_name="${dir_name[1,15]}$(tput setaf 0)...$(tput sgr0)"
    fi
  fi
}
PROMPT='%n@${m:7}: ${dir_name} %# '
chpwd # Call chpwd to set dir_name when the terminal is first opened

# Path to your oh-my-zsh installation.

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

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
alias python=python3
alias pip=pip3

alias telegram="open ~/library/Group\ Containers/6N38VWS5BX.ru.keepcoder.Telegram"
alias resetlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
alias reload="source ~/.zshrc"
alias cl="/usr/bin/osascript -e 'tell application \"System Events\" to tell process \"Terminal\" to keystroke \"k\" using command down'"

alias gitlog="git log --oneline --graph --decorate --all"

alias computername="print \"
sudo scutil --get ComputerName
sudo scutil --get LocalHostName
sudo scutil --get HostName
sudo scutil --set ComputerName <newname>
sudo scutil --set LocalHostName <newname>
sudo scutil --set HostName <newname>

dscacheutil -flushcache
\""

rand() {
	numbers=($@)
	rNumber=0
	if [[ ${#${numbers}} == 2 ]]; then
		for int in $numbers[@]; do
			if ! [[ $int =~ ^-?[0-9]+$ ]]; then
				print rand: $int is not an integer >&2
				return 1
			fi
		done
		if [[ $numbers[1] == $numbers[2] ]]; then
			print rand: integers MIN and MAX cannot be equal >&2
			return 1
		fi
		max=0
		min=0
		if (( numbers[1] > numbers[2] )); then
			max=$numbers[1]
			min=$numbers[2]
		else
			max=$numbers[2]
			min=$numbers[1]
		fi
	elif [[ ${#${numbers}} == 1 ]]; then
		if ! [[ $@ =~ ^-?[0-9]+$ ]]; then
			print rand: $@ is not an integer >&2
			return 1
		fi
		if [[ $@ == 0 ]]; then
			print rand: integers MIN and MAX cannot be equal >&2
			return 1
		fi
		max=$@
		min=1
	else
		print rand: only 2 integers MIN and MAX admitted >&2
		return 1
	fi
	rNumber=$[ $RANDOM % (($max+1-$min)) + $min ]
	string="The number beetween $min and $max is:"
	barre=""
	centeredNumber=""
	for i in {1..${#string}}; do
		barre+="-"
	done
	for i in {1..$((${#string}/2-2))}; do
		centeredNumber+=" "
	done
	print "\n"$barre"\n"$string"\n"$centeredNumber $rNumber"\n"$barre"\n"
}

ip() {
	if [[ $@ == "" ]]; then
		print "\n"----------------
		print IP Local
		command ipconfig getifaddr en0
		print \\----------------
		print IP Public
		command curl ifconfig.me
		print "\n"----------------"\n"

	elif [[ $@ == "local" ]]; then
		command ipconfig getifaddr en0

	elif [[ $@ == "public" ]]; then
		command curl ifconfig.me
		print 

	else
		print ip: invalid option $@ >&2
		return 1
	fi
}

version() {
	percorso="/Applications/$@.app"
	output_message=$(command mdls -name kMDItemVersion $percorso)
	if [ $? -ne 0 ]; then
		echo "$output_message" >&2 #error message
		return 1
	else
		echo "$output_message"
	fi
}

op() {
	input=$@
	open "$input"
}

new() {
  input=$@
  touch ~/Desktop/$input
}

c() {
	if [ $# -eq 0 ]; then
		gcc $@
		#echo -e "\033[1m\033[31merror:\033[0m \033[1mno input files\033[0m"
		return 1
	fi

	first_part=$1
	shift

	# Reverse the string, cut by the first dot, then reverse back
	first_part_name=$(echo $first_part | rev | cut -d. -f2- | rev)
	first_part_extension=$(echo $first_part | rev | cut -d. -f1 | rev)

	gcc $first_part -o $first_part_name
	if [ $? -ne 0 ]; then
		#echo -e "\033[1m\033[31mCompilation failed\033[0m"
		return 1
	else
		./$first_part_name "$@"
		rm ./$first_part_name
	fi
}

bundleid() {
	input="$@"
	osascript -e "id of app \"$input\""
}

#unset -f [function] -nel terminale per eliminare la funzione (toglierla solo qui non basta)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


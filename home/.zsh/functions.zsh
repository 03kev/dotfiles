alias tmuxplugins="cd ~/.tmux/plugins/tpm/scripts && ./install_plugins.sh"
alias reloadtmux="tmux source ~/.tmux.conf"
alias weather="curl wttr.in"

alias python=python3
alias pip=pip3

alias telegram="open ~/library/Group\ Containers/6N38VWS5BX.ru.keepcoder.Telegram"
alias resetlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
alias cl="/usr/bin/osascript -e 'tell application \"System Events\" to tell process \"Terminal\" to keystroke \"k\" using command down'"

alias gitlog="git log --oneline --graph --decorate --all"

alias fzfnvim="fzf --bind 'enter:become(nvim {})'"
alias fzfop="open \"\$(find . -type f | fzf)\""

alias fitch="/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/bin/java -cp Fitch.jar openproof.fitch.Fitch"

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
  if [[ $input == */ ]]; then
    mkdir -p ~/Desktop/$input
  else
    touch ~/Desktop/$input
  fi
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


#TMUX
alias tnw="tmux new-window"
function tn() (
    if [ -n "$1" ]
      then
         tmux switch -t $1
      else
         echo "no session name"
     fi
)

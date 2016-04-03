
#require colors.sh

if is_interactive; then
	# Set main prompt
	PS1="$BLUE[$WHITE\u$GREEN@$WHITE\h $LIGHTRED\w$BLUE]$GREEN\$ $COLORCLEAR"

	# Set window title if supported
	case $TERM in
		xterm* | rxvt*)
			PS1="\[\033]0;\u@\h:\w\007\]$PS1"
			;;
		*)
			;;
	esac
fi

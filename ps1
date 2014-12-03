#require colors.sh
PS1="$BLUE[$WHITE\u$GREEN@$WHITE\h $LIGHTRED\w$BLUE]$GREEN\$ $COLORCLEAR"
case $TERM in
    xterm* | rxvt*)
        PS1="\[\033]0;\u@\h:\w\007\]$PS1"
        ;;
    *)
        ;;
esac

# set terminal environment variable
if [ -e /usr/bin/kitty ] || [ -e "${HOME}/.local/bin/kitty" ]; then
    export TERMINAL="kitty"
elif [ -e /usr/bin/alacritty ]; then
    export TERMINAL="alacritty"
elif [ -e /usr/local/bin/st ] || [ -e /usr/bin/st ]; then
    export TERMINAL=st
elif [ -e /usr/bin/tilix ]; then
    export TERMINAL=tilix
elif [ -e /usr/bin/gnome-terminal ]; then
    export TERMINAL=gnome-terminal
elif [ -e /usr/bin/konsole ]; then
    export TERMINAL=konsole
elif [ -e /usr/bin/urxvt256cc ]; then
    export TERMINAL=urxvt256cc
elif [ -e /usr/bin/urxvtc ]; then
    export TERMINAL=urxvtc
else
    export TERMINAL=xterm
fi

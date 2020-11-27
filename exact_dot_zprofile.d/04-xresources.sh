# merge in .Xresources, GDM and co. don't like includes
[ -n "${DISPLAY}" ] && [ -f "$HOME/.Xresources" ] &&
	xrdb -merge -I"$HOME" "$HOME/.Xresources"

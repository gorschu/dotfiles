# merge in .Xresources, GDM and co. don't like includes
[ -n "${DISPLAY}" ] && [[ -z WAYLAND_DISPLAY ]] && [ -f "$HOME/.Xresources" ] &&
  xrdb -merge -I"$HOME" "$HOME/.Xresources"

# vim: ft=sh

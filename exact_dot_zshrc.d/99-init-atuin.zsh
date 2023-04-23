# source in atuin
if (($+commands[atuin])); then
  bindkey -r "^r" # remove ctrl-r keybinding, atuin covers it
  eval "$(atuin init zsh)"
fi


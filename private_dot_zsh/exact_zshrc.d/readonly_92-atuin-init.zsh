# Atuin initializes history, the configured PTY proxy, and the Threads picker.
if (($+commands[atuin])); then
  eval "$(atuin init zsh --bind-ai-resume)"
fi

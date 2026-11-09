# Atuin initializes history, the configured PTY proxy, and the Threads picker.
if (($+commands[atuin])); then
  # Herdr can't detect agents behind a nested PTY: https://github.com/herdrdev/herdr/issues/803
  [[ ${HERDR_ENV-} == 1 ]] && export ATUIN_PTY_PROXY__ENABLED=false
  eval "$(atuin init zsh --bind-ai-resume)"
fi

# only run when on an interactive terminal
if [[ $- != *i* ]]; then
  return
fi

# https://code.visualstudio.com/docs/terminal/shell-integration
# VS Code shell integration for enhanced terminal features
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

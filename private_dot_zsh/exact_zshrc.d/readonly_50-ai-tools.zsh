# AI tool state on data partition
# Also set in ~/.config/environment.d/30-ai-tools.conf for GUI apps; this
# covers TTY/SSH sessions that never see the systemd user environment.
[[ -d "${HOME}/data/general/ai/claude" ]]  && export CLAUDE_CONFIG_DIR="${HOME}/.config/claude"
[[ -d "${HOME}/data/general/ai/codex" ]]   && export CODEX_HOME="${HOME}/.config/codex"
[[ -d "${HOME}/data/general/ai/copilot" ]] && export COPILOT_HOME="${HOME}/.config/copilot"

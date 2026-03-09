# AI tool state on data partition
# Seems like Claude and Gemini like my $HOME
[[ -d "${HOME}/data/general/ai/codex" ]]   && export CODEX_HOME="${HOME}/.config/codex"
[[ -d "${HOME}/data/general/ai/copilot" ]] && export COPILOT_HOME="${HOME}/.config/copilot"

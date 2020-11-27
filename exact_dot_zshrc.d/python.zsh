# handled by oh-my-zsh plugin

# initialize pyenv virtualenv plugin
#if (( $+commands[pyenv] )) ; then
#    eval "$(pyenv virtualenv-init -)"
#fi

[[ -d $HOME/.poetry ]] && export PATH="${PATH}":$HOME/.poetry/bin

# turn off automatic Prompt mangling by virtualenv, we do it ourselves
export VIRTUAL_ENV_DISABLE_PROMPT=true


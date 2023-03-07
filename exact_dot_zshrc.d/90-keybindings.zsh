# some update broke my delete-char in vi-mode (or intentional?
# this could be temporary
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^k' kill-line

# Ctrl-V + Key-Combination to figure out bindings
# alt cursor left/right
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
# ctrl cursor left/right
bindkey "^[[1;5C" kill-word
bindkey "^[[1;5D" backward-kill-word

# source: https://github.com/sharat87/zsh-vim-mode/blob/master/zsh-vim-mode.plugin.zsh

# Home key variants
bindkey '\e[1~' vi-beginning-of-line
bindkey '\eOH' vi-beginning-of-line

# End key variants
bindkey '\e[4~' vi-end-of-line
bindkey '\eOF' vi-end-of-line

bindkey -M viins '^o' vi-backward-kill-word

bindkey -M vicmd 'yy' vi-yank-whole-line
bindkey -M vicmd 'Y' vi-yank-eol

bindkey -M vicmd 'y.' vi-yank-whole-line
bindkey -M vicmd 'c.' vi-change-whole-line
bindkey -M vicmd 'd.' kill-whole-line

bindkey -M vicmd 'u' undo
bindkey -M vicmd 'U' redo

bindkey -M vicmd 'H' run-help
bindkey -M viins '\eh' run-help

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
# arrow key up/down
bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down

#bindkey '^P' up-history
#bindkey '^N' down-history

bindkey -M vicmd '\-' vi-repeat-find
bindkey -M vicmd '_' vi-rev-repeat-find

bindkey -M viins '\e.' insert-last-word
bindkey -M vicmd '\e.' insert-last-word

bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
#bindkey '^a' beginning-of-line
#bindkey '^e' end-of-line

bindkey -M viins 'jk' vi-cmd-mode

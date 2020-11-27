# aliases
if (( $+commands[urxvt256cc] )) ; then
    alias urxvt=urxvt256cc
else;
    alias urxvt=urxvtc
fi

# define bash as shell for mc, it does not like zsh for its subshell support
alias mc='SHELL=/bin/bash mc -S $HOME/.vendor/gruvbox-contrib/midnightcommander/gruvbox256.ini'
alias dmesg='dmesg --human'
alias ND=find_newest_directory_universal
alias NF=find_newest_file_universal
alias lac="latex_compile -o"
alias -g a2c='aria2c -x4 -j4 -c -i -'
alias ssh-add='ssh-add -t 3600 -c'
alias ecn='ec -n'

alias ip="ip --color=auto"

alias -g nd='*(/om[1])' # newest directory
alias -g nf='*(.om[1])' # newest file

# fixes to autocorrection
alias cp='nocorrect cp -i --reflink=auto'
alias mv='nocorrect mv -i '
alias rm='nocorrect rm -i '
alias mkdir='nocorrect mkdir '

alias uda='udiskie-umount -a'

if (( $+commands[nvim] )); then
    alias vim=nvim
fi
if (( $+commands[gpg2] )); then
    alias gpg=gpg2
fi

# git push all
alias gpa='git remote | xargs -L1 -I R git push -v R master'

# devour windows
alias zathura="devour zathura"
alias mpv="devour mpv"

alias mbsync="mbsync -c ${XDG_CONFIG_HOME}/mail/mbsyncrc"
alias weechat="weechat -d ${XDG_CONFIG_HOME}/weechat"

# we never want globbing for git commands (and yadm for that matter)
alias git="noglob git"

# zsh options
# autoload zmv
autoload -U zmv
# enable extended globbing
setopt extendedglob
# prevent accidental overwrite of files when redirecting
setopt noclobber
# print exit value if exit value != 0
setopt printexitvalue
# wait 10 seconds before nuking everything...
setopt rmstarwait
# Appends every command to the history file once it is executed
setopt inc_append_history
# Reloads the history whenever you use it
setopt share_history
# dont printout exit codes (zsh: exit 1), sucks for pure prompt
unsetopt PRINT_EXIT_VALUE
# quote globs in remote commads
__remote_commands=(scp sftp rsync curl wget lftp)
zstyle -e :urlglobber url-other-schema \
    '[[ $__remote_commands[(i)$words[1]] -le ${#__remote_commands} ]] && reply=("*") || reply=(http https ftp)'

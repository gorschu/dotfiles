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
# history handling
# Reloads the history whenever you use it
setopt share_history
# ignore lines starting with space
setopt hist_ignore_space
# fully ignore duplicate lines
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_save_no_dups
# quote globs in remote commads
__remote_commands=(scp sftp rsync rsync-move rsync-copy curl wget lftp)
zstyle -e :urlglobber url-other-schema \
    '[[ $__remote_commands[(i)$words[1]] -le ${#__remote_commands} ]] && reply=("*") || reply=(http https ftp)'
    #
# dont printout exit codes (zsh: exit 1), sucks for pure prompt
unsetopt print_exit_value

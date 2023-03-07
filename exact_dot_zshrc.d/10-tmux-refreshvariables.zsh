# refresh stale shells in a tmux session
# idea source: https://babushk.in/posts/renew-environment-tmux.html
if [ -n "$TMUX" ]; then
    # when in a tmux-session, define refresh function...
    function refresh {
        sshauth=$(tmux show-environment | grep "^SSH_AUTH_SOCK")
        if [ $sshauth ]; then
            export $sshauth
        fi
        display=$(tmux show-environment | grep "^DISPLAY")
        if [ $display ]; then
            export $display
        fi
    }
    # and add it to the preexec hook so the SSH_AUTH and DISPLAY variables will
    # be refreshed for RUNNING shells inside tmux.
    # The preexec hook is ran each time a command is read by the shell and
    # is about to be executed.
    # tmux's update-environment is great, but only works for NEW shells.
    add-zsh-hook preexec refresh
    # -d would remove the hook
    # add-zsh-hook -d preexec refresh
fi

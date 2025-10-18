#!/bin/sh
if command -v "bat" >/dev/null; then
    export PAGER="bat"
else
    export PAGER='less'
fi

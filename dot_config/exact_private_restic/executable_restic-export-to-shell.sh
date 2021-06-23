#!/bin/zsh

set -o allexport
source ./restic-backup.conf && zsh
set +o allexport

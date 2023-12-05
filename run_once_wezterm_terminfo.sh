#!/bin/bash

tempfile=$(mktemp) &&
  curl -s -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo &&
  tic -x -o ~/.terminfo "$tempfile" &&
  rm -f "$tempfile"

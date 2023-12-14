#!/bin/bash

sudo dnf -y groupinstall 'Development Tools'
sudo dnf -y install procps-ng curl file git

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install chezmoi

#!/users/bin/env bash

# Make sure we're using the latest Homebrew
brew update

# Upgrade any alread-installed formulae
brew upgrade

# System Utils & setup
brew install stow
brew install grep
brew install openssh

# Terminal tools
brew install tmux
brew install superfile
brew install nvim
brew install eza
brew install zoxide
brew install zstd
brew install lazydocker
brew install lazygit
brew install btop
brew install tree
brew install as-tree

# Development
brew install git
brew install git-lfs
git lfs install

brew install node
brew install nvm

# Utilities
brew install ffmpeg

# Applications
brew install --cask aerospace
brew install --cask raycast
brew install --cask ghostty
brew install --cask firefox
brew install --cask docker
brew install --cask vlc
brew install --cask obsidian
brew install --cask visual-studio-code

# Remove outdated versions from the cellar
brew cleanup

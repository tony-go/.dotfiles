# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
(
  echo
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
) >>/Users/tonygo/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# core deps
brew install cmake v8 llvm coreutils nvm clang-format htop libuv pipx watchman tree testdisk

# nvim
brew install neovim lazygit tree-sitter
mkdir -p ~/.config/nvim
git clone git@github.com:tony-go/nvim.git ~/.config/nvim/
brew install --cask font-jetbrains-mono-nerd-font
brew install ripgrep

# Terminal
brew install --cask warp

# Aerospace
brew install --cask nikitabobko/tap/aerospace
mkdir -p ~/.config/aerospace
ln -sf "$(pwd)/aerospace.toml" ~/.config/aerospace/aerospace.toml

# Suspicious Package
brew install --cask suspicious-package

# Dyld share cache extractor
brew install keith/formulae/dyld-shared-cache-extractor

# Remove outdated versions from the cellar.
brew cleanup

# ios jailbreak
sudo /bin/sh -c "$(curl -fsSL https://static.palera.in/scripts/install.sh)"

# zshrc
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
cp .zshrc ~/.zshrc

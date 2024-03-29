# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/tonygo/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# core deps
brew install cmake v8 llvm coreutils nvm

# nvim
brew install neovim ripgrep lazygit
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
git clone git@github.com:tony-go/astro_config.git ~/.config/nvim/lua/user

# Remove outdated versions from the cellar.
brew cleanup

# zshrc
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
cp .zshrc ~/.zshrc

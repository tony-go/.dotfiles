# Path to your oh-my-zsh installation.
export ZSH="/Users/tonygo/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias zshconfig="nvim~/.zshrc"
alias ohmyzsh="nvim~/.oh-my-zsh"
alias gitc="git checkout"
alias gitp="git pull"
alias gits="git status"
alias gitri="git rebase -i"
alias gitcm="git commit -m"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export GIT_EDITOR=nvim

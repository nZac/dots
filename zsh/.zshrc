autoload colors && colors


# use .localrc for SUPER SECRET CRAP that you don't
# want in your public, versioned repo.
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

################################################################################
# VARIABLES
################################################################################
EDITOR=vim
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

################################################################################
# ALIAS
################################################################################
alias e='vim'
alias ga='git-add'
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git diff'
alias gdc='git diff --cached'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gcb='git copy-branch-name'
alias gb='git branch'
alias gs='git status -sb'
alias gmt='git mergetool'


################################################################################
# AUTO COMPLETE
################################################################################
autoload -Uz compinit
compinit

setopt magicequalsubst # Allows completion of --flag=<path> params
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={a-z}'
#
# # pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


################################################################################
# SETTINGS
################################################################################
setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

################################################################################
# PROMPT
################################################################################
export PROMPT="$ "
export RPROMPT="$(date +"%T")"

################################################################################
# PATH
################################################################################
export PATH=$HOME/.dotfiles/bin:$PATH

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
export EDITOR=vim
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
export CLICOLOR=true

################################################################################
# PATH
################################################################################
export PATH=$HOME/.pyenv/bin:$HOME/.dotfiles/bin:./node_modules/.bin:$PATH

################################################################################
# ALIAS
################################################################################
alias e='$EDITOR'

alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

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

alias ls="gls -F --color"
alias l="gls -lAh --color"
alias ll="gls -l --color"
alias la='gls -A --color'

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
# KEY BINDINGS
################################################################################

bindkey -M vicmd '/' history-incremental-pattern-search-backward
bindkey -M vicmd '?' history-incremental-pattern-search-forward

bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward

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
setopt histignorespace

################################################################################
# PROMPT
################################################################################
if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]; then
      return 0;
  else
      echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%}"
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}"
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "%{$fg_bold[green]%}[$(git_prompt_info)]%{$reset_color%}"
    else
      echo "%{$fg_bold[red]%}[$(git_prompt_info)]%{$reset_color%}"
    fi
  fi
}

venv_status() {
    if [ -z "$PYENV_ACTIVATE_SHELL" ]; then
        return 0;
    fi

    echo "($PYENV_VERSION)";
}

function prompt() {
    echo "(%?) %~ $(git_dirty) $(need_push) $(venv_status)"
}

export PROMPT=$'$(prompt)\n$ '
# export RPROMPT=$'$(rprompt) '

source /usr/local/etc/grc.zsh


################################################################################
# PYTHON
################################################################################
export PYTHON_CONFIGURE_OPTS="--enable-framework"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

################################################################################
# GO
################################################################################
export GOPATH="$HOME/go"

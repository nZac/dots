set -o vi
bindkey -v

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd extendedglob notify
unsetopt beep

################################################################################
# COMPLETIONS
################################################################################
zstyle :compinstall filename '/home/nzac/.zshrc'
autoload -Uz compinit
compinit

export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '
export EDITOR=vim
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY=$(tty)
export PROJECTS_DIR=$HOME/j

alias dots='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias e=$EDITOR

if [ -f $HOME/.cargo/env ]; then
  source "$HOME/.cargo/env"
fi

################################################################################
# PROMPT
################################################################################
autoload -U colors && colors
export CLICOLOR=true
export LSCOLORS=gxfxcxdxbxegedabagacad

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
      echo "%{$fg[magenta]%}⇪%{$reset_color%}"
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
      echo "%{$fg[green]%}[$(git_prompt_info)]%{$reset_color%}"
    else
      echo "%{$fg[red]%}[$(git_prompt_info)]%{$reset_color%}"
    fi
  fi
}

user_host_info() {
    # Print out the hostname if this prompt is over ssh
    if (( ${+SSH_CLIENT} )); then
        echo "%{$fg_bold[red]%}%m%{$reset_color%}:"
    fi
}

venv_status() {
    if [ -z "$PYENV_ACTIVATE_SHELL" ]; then
        return 0;
    fi

    echo "($PYENV_VERSION)";
}

function exit_code(){
    local ec="$?"

    if [[ "$ec" -ne 0 ]]; then
        echo "%{$fg[red]%}$ec%{$reset_color%}"
    else
        echo "%{$fg[green]%}$ec%{$reset_color%}"
    fi

}

function prompt() {
    ec="$(exit_code)"
    echo "$(user_host_info)%~ ($ec)"
}

function rprompt() {
    echo "$(venv_status) $(need_push) $(git_dirty)"
}

pyclean () {
    find . -regex '^.*\(__pycache__\|\.py[co]\)$' -delete
}

export PROMPT="$(prompt)
%{$fg[yellow]%}λ%{$reset_color%} "
export RPROMPT="$(rprompt)"


################################################################################
# PYTHON SETUP
################################################################################
export PYENV_ROOT="$HOME/j/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
source $(pyenv root)/completions/pyenv.zsh



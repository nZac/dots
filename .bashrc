set -o vi

export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '
export EDITOR=vim
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY=$(tty)
export PROJECTS_DIR=$HOME/j

alias dots='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias e=$EDITOR

if [ -f $HOME/.cargo/env ]; then
  source "$HOME/.cargo/env"
fi

if command -v pyenv &> /dev/null
then
    export PYENV_ROOT="$HOME/j/pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
    source $(pyenv root)/completions/pyenv.bash
fi


################################################################################
# PROMPT
################################################################################

user_host_info() {
    # Print out the hostname if this prompt is over ssh
    if [ -v ${SSH_CLIENT+} ]; then
        echo "[${HOSTNAME}]"
    fi
}
export PS1=$'$(user_host_info) λ '
export PS2=$''

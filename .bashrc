set -o vi

if [ -f /etc/profile.d/bash_completion.sh ]; then
    source "/etc/profile.d/bash_completion.sh"
fi

export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '
export EDITOR=vim
export GPG_TTY=$(tty)
export PROJECTS_DIR=$HOME/j


# If not using 1Password for SSH authentication, uncomment this
# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

alias dots='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias e=$EDITOR


# Support user based docker
if [ -S "/run/user/$(id -u)/docker.sock" ]; then
    export DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock" 
fi

if [ -f $HOME/.cargo/env ]; then
  source "$HOME/.cargo/env"
fi

if [ -f /etc/profile.d/nix.sh ]; then
    source /etc/profile.d/nix.sh
fi

if [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

if command -v pyenv &> /dev/null
then
    export PYENV_ROOT="$HOME/j/pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
    source $(pyenv root)/completions/pyenv.bash
fi

if [ -f /usr/local/go/bin/go ]; then
    export PATH=/usr/local/go/bin:$PATH
fi

if command -v go &> /dev/null
then
    export GOPATH="$HOME/j/go"
    export PATH="$GOPATH/bin:$PATH"
fi

if command -v direnv &> /dev/null
then
    eval "$(direnv hook bash)"
fi

if [ -f $HOME/.nvm/nvm.sh ]; 
then
    export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

export PATH=$HOME/bin:$PATH


################################################################################
# PROMPT
################################################################################

user_host_info() {
    # Print out the hostname if this prompt is over ssh
    if [ -v ${SSH_CLIENT+} ]; then
        echo "${HOSTNAME}"
    fi
}

git_root() {
    local gitpath="$(git rev-parse --show-toplevel > /dev/null 2>&1)"
    echo "$(basename "$gitpath")"
}

if [ "$(uname)" == "Darwin" ]; then
    PATH=/opt/homebrew/bin:$PATH
    rm -f $HOME/.gnupg/gpg-agent.conf
    ln -s $HOME/.gnupg/gpg-agent.conf.mac $HOME/.gnupg/gpg-agent.conf
else
    rm -f $HOME/.gnupg/gpg-agent.conf
    ln -s $HOME/.gnupg/gpg-agent.conf.linux $HOME/.gnupg/gpg-agent.conf
fi

export PS1=$'[$(user_host_info):$(git_root)] λ '
export PS2=$''

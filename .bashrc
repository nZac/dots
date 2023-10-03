set -o vi

echo "setting up shell..."

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin

if [ "$(uname)" == "Darwin" ]; then
    export HOMEBREW_PREFIX=$(brew --prefix)
    
    export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
    export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"
fi



if command -v nvim &> /dev/null; then
    export EDITOR=nvim
    alias vim="nvim"
else
    export EDITOR=vim
fi
alias e=$EDITOR

[ -f /etc/profile.d/bash_completion.sh ] && . "/etc/profile.d/bash_completion.sh"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"


export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '
export GPG_TTY=$(tty)
export PROJECTS_DIR=$HOME/j


# If not using 1Password for SSH authentication, uncomment this
export SSH_AUTH_SOCK="/Users/nzac/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

alias dots='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


# Support user based docker
if [ -S "/run/user/$(id -u)/docker.sock" ]; then
    export DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock"
fi

if [ -f $HOME/.cargo/env ]; then
  source "$HOME/.cargo/env"
fi

if [ -f "$HOME/.config/op/plugins.sh" ]; then
    echo "Setting up One Password"
    source "$HOME/.config/op/plugins.sh"
fi

if [ -f /etc/profile.d/nix.sh ]; then
    source /etc/profile.d/nix.sh
fi

if [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi



if command -v pyenv &> /dev/null
then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    [ -s "$(pyenv root)/completions/pyenv.bash" ] && \. "$(pyenv root)/completions/pyenv.bash"
    [ -s "$HOMEBREW_PREFIX/opt/pyenv/completions/pyenv.bash" ] && \. "$HOMEBREW_PREFIX/opt/pyenv/completions/pyenv.bash"

    # Check if libpq through hhomebrew is installed and add it to the path for psycopg builds
    if [ -f "$HOMEBREW_PREFIX/opt/libpq/bin/pg_config" ];
    then
        export PATH=$PATH:"$HOMEBREW_PREFIX/opt/libpq/bin"
    fi
fi

if [ -f /usr/local/go/bin/go ]; then
    export PATH=$PATH:/usr/local/go/bin
fi

if command -v go &> /dev/null
then
    export GOPATH="$HOME/j/go"
    export PATH="$GOPATH/bin:$PATH"
fi


if [ "$(uname)" == "Darwin" ];
then
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi


if [ -f $HOME/.nvm/nvm.sh ];
then
    export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

export PATH=$PATH:$HOME/bin:$HOME/.local/bin

if command -v direnv &> /dev/null
then
    eval "$(direnv hook bash)"
fi

################################################################################
# PROMPT
################################################################################

user_host_info() {
    # Print out the hostname if this prompt is over ssh
    if [ -n "${SSH_CLIENT}" ]; then
        echo "${HOSTNAME}"
    fi
}

git_root() {
    local gitpath="$(git rev-parse --show-toplevel 2> /dev/null)"
    echo "$(basename "$gitpath")"
}

if [ "$(uname)" == "Darwin" ]; then
    rm -f $HOME/.gnupg/gpg-agent.conf
    ln -s $HOME/.gnupg/gpg-agent.conf.mac $HOME/.gnupg/gpg-agent.conf
else
    rm -f $HOME/.gnupg/gpg-agent.conf
    ln -s $HOME/.gnupg/gpg-agent.conf.linux $HOME/.gnupg/gpg-agent.conf
fi

export PS1=$'[$(user_host_info):$(git_root)] λ '
export PS2=$''


#----
listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

alias ll="ls -lah"

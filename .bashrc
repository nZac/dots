#!/usr/bin/env bash

set -o vi

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export HOMEBREW_NO_ENV_HINTS=1

if [ "$(uname)" == "Darwin" ]; then
    HOMEBREW_PREFIX="$(/opt/homebrew/bin/brew --prefix)";
    export HOMEBREW_PREFIX="${HOMEBREW_PREFIX}"
    export PATH="/opt/homebrew/bin:${PATH+:$PATH}";
    
    export LDFLAGS="-L$HOMEBREW_PREFIX/opt/openssl@3/lib"
    export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl@3/include"

    # If not using 1Password for SSH authentication, uncomment this
    export SSH_AUTH_SOCK="/Users/nzac/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi

if [ "$(uname)" == "Linux" ]; then
    
    # https://www.shellcheck.net/wiki/SC2155
    HOMEBREW_PREFIX="$(/home/linuxbrew/.linuxbrew/bin/brew --prefix)";
    export HOMEBREW_PREFIX="${HOMEBREW_PREFIX}"

    # Use homebrew compiler instead of system compiler
    export CC="${HOMEBREW_PREFIX}/gcc-13"
    export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar";
    export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew";
    export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin${PATH+:$PATH}";
    export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}";
fi

if command -v nvim &> /dev/null; then
    export EDITOR=nvim
    alias vim="nvim"
else
    export EDITOR=vim
fi

editor(){
    printf '\033]2;%s\033\\' 'vim'
    $EDITOR
    printf '\033]2;%s\033\\' 'bash'
}

alias e="$EDITOR"
alias terraform="op run --no-masking -- terraform"



[ -f /etc/profile.d/bash_completion.sh ] && source "/etc/profile.d/bash_completion.sh"
[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ] && source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
[ -r "${HOMEBREW_PREFIX}/etc/bash_completion.d/00_bash_completion_compat.bash" ] && source "${HOMEBREW_PREFIX}/etc/bash_completion.d/00_bash_completion_compat.bash"

GPG_TTY="$(tty)"
export GPG_TTY="${GPG_TTY}"
export FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" '
export PROJECTS_DIR=$HOME/j

alias dots='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# DOCKER aliases
alias cleanupcontainers='docker rm -v -f $(docker ps -qa)'


# Support user based docker
if [ -S "/run/user/$(id -u)/docker.sock" ]; then
    DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock"
    export DOCKER_HOST="${DOCKER_HOST}"
fi

if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

if [ -f "$HOME/.config/op/plugins.sh" ]; then
    echo "Setting up One Password"
    source "$HOME/.config/op/plugins.sh"
fi

if command -v pyenv &> /dev/null
then
    PYENV_ROOT="$(pyenv root)"
    export PYENV_ROOT="${PYENV_ROOT}"
    export PATH="${PYENV_ROOT}/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    [ -s "${PYENV_ROOT}/completions/pyenv.bash" ] && \. "${PYENV_ROOT}/completions/pyenv.bash"
    [ -s "${HOMEBREW_PREFIX}/opt/pyenv/completions/pyenv.bash" ] && \. "${HOMEBREW_PREFIX}/opt/pyenv/completions/pyenv.bash"

fi
    
# Check if libpq through hhomebrew is installed and add it to the path for psycopg builds
if [ -f "$HOMEBREW_PREFIX/opt/libpq/bin/pg_config" ];
then
    export PATH=$PATH:"$HOMEBREW_PREFIX/opt/libpq/bin"
fi

if [ -f /usr/local/go/bin/go ]; then
    export PATH=$PATH:/usr/local/go/bin
fi

if command -v go &> /dev/null
then
    export GOPATH="$HOME/j/go"
    export PATH="$GOPATH/bin:$PATH"
fi

if command -v mise &> /dev/null
then
    eval "$(mise activate bash)"
    alias mr="mise run"
fi


[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"


if [ -f "$HOME/.nvm/nvm.sh" ];
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


_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config ~/.ssh/config.d/*.conf | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh

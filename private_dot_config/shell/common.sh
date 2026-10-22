# Shared by bash and zsh; sourced from ~/.bashrc and ~/.zshrc.

case ":$PATH:" in
*":$HOME/.local/bin:"*) ;;
*) export PATH="$HOME/.local/bin:$PATH" ;;
esac

alias e="nvim"
alias vim="nvim"
export EDITOR="nvim"
set -o vi

# Keep a stable agent socket path so long-lived Zellij sessions survive SSH reconnects.
if [ -n "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != ~/.ssh/ssh_auth_sock ]; then
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

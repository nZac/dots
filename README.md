# Nick Dotfiles for Linux

These are my personal dotfiles for linux servers. Following this pattern by [Atlassian](https://www.atlassian.com/git/tutorials/dotfiles)


```
git clone --bare git@github.com:nZac/dots.git $HOME/.cfg
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
```


## Setting up SSH / GPG forwarding


### Local


```
Host *
	IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

Host {{host}}
    User {{user}}
    HostName {{host.local}}
    ForwardAgent yes
    RemoteForward /run/user/1000/gnupg/S.gpg-agent.extra /Users/{{ user }}/.gnupg/S.gpg-agent.extra
    RemoteForward /run/user/1000/gnupg/S.gpg-agent /Users/{{ user }}/.gnupg/S.gpg-agent
    # If using 1Password, uncomment this
    # RemoteForward /run/user/1000/gnupg/S.gpg-agent.ssh /Users/{{ user }}/.gnupg/S.gpg-agent.ssh


Match host "vm-u2004" exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
```

### Remote
```
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME

cat "StreamLocalBindUnlink yes" >> /etc/ssh/sshd_config
```

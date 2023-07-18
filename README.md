# Nick Dotfiles for Linux

These are my personal dotfiles for linux servers. Following this pattern by [Atlassian](https://www.atlassian.com/git/tutorials/dotfiles)


```
git clone --bare git@github.com:nZac/dots.git $HOME/.cfg
git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
```

[Setting up SSH / GPG forwarding, see this gist](https://gist.github.com/nZac/848a8b2412659074a5ea9f4db6f937fa). 


## For MacOS

Mac doesn't source ~/.bashrc automtically and the /etc/bashrc calls uses a erminal app specific
(based on `$TERM_PROGRAM`). You might need to `sudo tee "source $HOME/.bashrc" > /etc/bashrc_$TERM_PROGRAM"` 
to make it all work.

# dotfiles

Managed with [chezmoi](https://chezmoi.io); tools installed with [mise](https://mise.jdx.dev). Works on Linux and macOS.

## New machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply nZac/dots
```

This installs chezmoi, writes the dotfiles, installs mise if missing, and runs
`mise install` for the tools in `~/.config/mise/config.toml`.

## Day to day

| Task | Command |
| --- | --- |
| Edit a managed file | `chezmoi edit ~/.bashrc` (or edit in place, then `chezmoi re-add`) |
| Preview changes | `chezmoi diff` |
| Save | `chezmoi cd`, then commit and push |
| Pull on another machine | `chezmoi update` |
| Add a global tool | add it to `~/.config/mise/config.toml`; `chezmoi re-add` re-runs `mise install` on every machine at next apply |

## Layout

- `~/.config/shell/common.sh` is shared by bash and zsh. `.zshrc` is only installed on macOS.
- `run_once_before_00-install-mise.sh` installs mise.
- `run_onchange_after_10-mise-install.sh.tmpl` re-runs `mise install` when the mise config changes.
- `~/.config/zellij/plugins/vim-zellij-navigator.wasm` is
  [vim-zellij-navigator](https://github.com/hiasr/vim-zellij-navigator) 0.3.0 with
  [PR #35](https://github.com/hiasr/vim-zellij-navigator/pull/35) applied (fixes double moves after a
  client detaches). WASM is platform independent; `run_onchange_after_20-…` pre-grants its permissions.
  Drop it for the upstream release URL once a fixed release ships.

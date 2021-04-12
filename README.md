# dotfiles

## External tools used in the environment

- `fish`
- `bash`
- `fgr`
- `starship`
- `bat`
- `exa`
- `fd` (`fd-find`)
- `procs`
- `fzf`
- `nvm`
- `nix`
- `yarn`
- `gitg`
- `postman`

## WSL2 Setup

- `wsl --set-default-version 2`
- `wsl --list --verbose` (See which WSL Version a distribution is using)
- `wsl --set-version Ubuntu-20.04 2` (Set an installed distribution to a specific WSL version)
- `sudo apt-get install fish fzf`
- `chsh` (Interactive, choose fish: `/usr/bin/fish`)
- [rustup](https://rustup.rs/)
- For compiling rust apps
  - `sudo apt-get install gcc libssl-dev make` (Possibly also required: `openssl`, `pkg-config`)

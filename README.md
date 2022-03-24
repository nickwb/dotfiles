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
- `gh` (Github CLI)[https://cli.github.com/]

## WSL2 Setup
- Run these [WSL2 Install Steps](https://docs.microsoft.com/en-us/windows/wsl/install) and perhaps [some of these too](https://docs.microsoft.com/en-us/windows/wsl/install-manual)
- `wsl --set-default-version 2`
- `wsl --list --verbose` (See which WSL Version a distribution is using)
- `wsl --set-version Ubuntu-20.04 2` (Set an installed distribution to a specific WSL version)
- `sudo apt-get install fish fzf`
- `chsh` (Interactive, choose fish: `/usr/bin/fish`)
- [rustup](https://rustup.rs/)
- For compiling rust apps
  - `sudo apt-get install gcc libssl-dev make` (Possibly also required: `openssl`, `pkg-config`)

## APT Sources
- Github CLI (Signed; follow the install instructions [here](https://github.com/cli/cli/blob/trunk/docs/install_linux.md))
- https://apt.releases.hashicorp.com (terraform)
- https://packages.microsoft.com/repos/azure-cli/ (Azure CLI)

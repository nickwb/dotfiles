## WSL2 Setup

- Run these [WSL2 Install Steps](https://docs.microsoft.com/en-us/windows/wsl/install) and perhaps [some of these too](https://docs.microsoft.com/en-us/windows/wsl/install-manual)
- `wsl --set-default-version 2`
- `wsl --list --verbose` (See which WSL Version a distribution is using)
- `wsl --set-version Ubuntu-20.04 2` (Set an installed distribution to a specific WSL version)
- `sudo apt-get update && sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg`
- `sudo apt-get install fish fzf`
- [rustup](https://rustup.rs/)
- For compiling rust apps
  - `sudo apt-get install gcc libssl-dev make` (Possibly also required: `openssl`, `pkg-config`)

## Git Setup
- Create an SSH key: `ssh-keygen -t ecdsa -b 521`
- Configure and authorise the SSH key in github

## Fish Setup
- Install fish first: `sudo apt-get install fish`
- Clone `dotfiles` in to `~/code/dotfiles`
- Then create new file: `~/.config/fish/config.fish`

```fish
# config.fish
source $HOME/code/dotfiles/linux/fish/machine.lenovo.wsl2.fish
source $HOME/code/dotfiles/linux/fish/config.fish
```
Finally, switch shell: `chsh` (Interactive, choose fish: `/usr/bin/fish`)

## Additional APT Sources

- Github CLI (Signed; follow the install instructions [here](https://github.com/cli/cli/blob/trunk/docs/install_linux.md))
- https://apt.releases.hashicorp.com (terraform)
- https://packages.microsoft.com/repos/azure-cli/ (Azure CLI)

## Dotnet Setup

```
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-6.0
```

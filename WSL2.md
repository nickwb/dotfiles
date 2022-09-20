## WSL2 Setup

### Basic Setup
- Run these [WSL2 Install Steps](https://docs.microsoft.com/en-us/windows/wsl/install) and perhaps [some of these too](https://docs.microsoft.com/en-us/windows/wsl/install-manual)
- `wsl --set-default-version 2`
- `wsl --list --verbose` (See which WSL Version a distribution is using)
- `wsl --set-version Ubuntu-20.04 2` (Set an installed distribution to a specific WSL version)

### Add additional package sources

Some packages need additional apt sources.

- Github CLI - Follow the install instructions [here](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
- Terraform - Follow the Linux/Ubuntu/Debian instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Azure CLI - Follow the install instructions [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#option-2-step-by-step-installation-instructions)

### Installing additional packages
- `sudo apt-get update && sudo apt-get install fish fzf ca-certificates curl apt-transport-https lsb-release gnupg gcc libssl-dev make openssl pkg-config`
- Install `rustup` as per: [rustup](https://rustup.rs/)

### `.wslconfig`

There's a config file that sits in your windows File System: `C:\Users\YourUser\.wslconfig`

```
[wsl2]
memory=16GB
swap=8GB
processors=6
```

## Git Setup
- Create an SSH key: `ssh-keygen -t ecdsa -b 521`
- Configure and authorise the SSH key in github

## Fish Setup

### 1. Install fish
`sudo apt-get install fish`

### 2. Clone dotfiles so that we can reference the fish config
Clone `nicwb/dotfiles` in to `~/code/dotfiles`

### 3. Create fish config
Create a new file: `~/.config/fish/config.fish` with the following contents:

```fish
source $HOME/code/dotfiles/linux/fish/machine.lenovo.wsl2.fish
source $HOME/code/dotfiles/linux/fish/config.fish
```

### 4. Change login shell
Run: `chsh` (Interactive, choose fish: `/usr/bin/fish`)

### 5. Install Fisher
- See instructions [here](https://github.com/jorgebucaran/fisher)

### 6. Install nvm.fish
- `fisher install jorgebucaran/nvm.fish`

## Dotnet Setup

### Install the SDK
```
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-6.0
```

### Unifying NuGet.config
Create a symlink from `~/.nuget/NuGet/NuGet.Config` to `/mnt/c/Users/UserName/AppData/Roaming/NuGet/NuGet.Config`

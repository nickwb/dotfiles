set -xg dotfiles_root (realpath (dirname (status --current-filename))/../)
set -xg PATH "$dotfiles_root/bin" "$HOME/.cargo/bin" $PATH

starship init fish | source

source $dotfiles_root/fish/git.fish
source $dotfiles_root/fish/aliases.fish
source $dotfiles_root/fish/nix.fish

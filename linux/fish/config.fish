set -x dotfiles_root (realpath (dirname (status --current-filename))/../)

starship init fish | source

source $dotfiles_root/fish/git.fish
source $dotfiles_root/fish/aliases.fish
source $dotfiles_root/fish/nix.fish


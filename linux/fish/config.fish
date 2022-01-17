set -xg dotfiles_root (realpath (dirname (status --current-filename))/../)
set -xg PATH "$dotfiles_root/bin" "$HOME/.cargo/bin" $PATH

if test 1 -eq $NICK_USE_WSL;
  set -xg PATH "$dotfiles_root/bin-wsl" $PATH
end

starship init fish | source

source $dotfiles_root/fish/git.fish
source $dotfiles_root/fish/aliases.fish
source $dotfiles_root/fish/nix.fish

set -xg dotfiles_root (realpath (dirname (status --current-filename))/../)

function add_bin_dir_to_path
    set maybe_path $argv[1]
    if test -d $maybe_path
        set -xg PATH $maybe_path $PATH
    end
end

add_bin_dir_to_path "$dotfiles_root/bin"
add_bin_dir_to_path "$HOME/.cargo/bin"
add_bin_dir_to_path "$HOME/bin"
add_bin_dir_to_path "$HOME/.dotnet/tools"

if test 1 -eq $NICK_USE_WSL
    add_bin_dir_to_path "$dotfiles_root/bin-wsl"
end

starship init fish | source

source $dotfiles_root/fish/git.fish
source $dotfiles_root/fish/aliases.fish
source $dotfiles_root/fish/nix.fish

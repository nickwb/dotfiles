set fish_cfg_root (dirname (status --current-filename))

starship init fish | source

source $fish_cfg_root/git.fish
source $fish_cfg_root/aliases.fish
source $fish_cfg_root/nix.fish


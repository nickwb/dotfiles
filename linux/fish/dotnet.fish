add_bin_dir_to_path "$HOME/.dotnet/tools"

if test -d /usr/share/dotnet
    set -xg DOTNET_ROOT /usr/share/dotnet
end

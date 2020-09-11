# Nix
if [ -e /Users/nick.young/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/nick.young/.nix-profile/etc/profile.d/nix.sh; fi

# cargo install
export PATH="$HOME/.cargo/bin:$PATH"

# starship prompt
eval "$(/Users/nick.young/.cargo/bin/starship init bash)"

# z
. /usr/local/etc/profile.d/z.sh

# br 
source /Users/nick.young/Library/Preferences/org.dystroy.broot/launcher/bash/br

# bash history
export HISTSIZE=10000

# terraform prefix
export TF_VAR_name_prefix="nick"
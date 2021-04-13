#! /usr/local/bin/fish
if test -n "$HOME"
    and test 1 -eq $NICK_USE_NIX;
    
    # Set up the per-user profile.
    # This part should be kept in sync with nixpkgs:nixos/modules/programs/shell.nix
    set -xg NIX_LINK "$HOME/.nix-profile"

    # Append ~/.nix-defexpr/channels to $NIX_PATH so that <nixpkgs>
    # paths work when the user has fetched the Nixpkgs channel.
    set -xg NIX_PATH $HOME/.nix-defexpr/channels $NIX_PATH

    # Set up environment.
    # This part should be kept in sync with nixpkgs:nixos/modules/programs/environment.nix
    set -xg NIX_PROFILES "/nix/var/nix/profiles/default $HOME/.nix-profile"

    # Set $SSL_CERT_FILE so that Nixpkgs applications like curl work.
    if test  -e /etc/ssl/certs/ca-bundle.crt;  # Fedora, NixOS
        set -xg SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt;
    else if test -e /etc/ssl/certs/ca-certificates.crt;  # Ubuntu, Debian
        set -xg SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
    else if test -e "$NIX_LINK/etc/ca-bundle.crt"   # fall back to Nix profile
        set -xg SSL_CERT_FILE "$NIX_LINK/etc/ca-bundle.crt"
    end

    # Set $NIX_SSL_CERT_FILE so that Nixpkgs applications like curl work.
    if test -e /etc/ssl/certs/ca-certificates.crt; # NixOS, Ubuntu, Debian, Gentoo, Arch
        set -xg NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
    else if test -e /etc/ssl/ca-bundle.pem; # openSUSE Tumbleweed
        set -xg NIX_SSL_CERT_FILE /etc/ssl/ca-bundle.pem
    else if test -e /etc/ssl/certs/ca-bundle.crt; # Old NixOS
        set -xg NIX_SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt
    else if test -e /etc/pki/tls/certs/ca-bundle.crt; # Fedora, CentOS
        set -xg NIX_SSL_CERT_FILE /etc/pki/tls/certs/ca-bundle.crt
    else if test -e "$NIX_LINK/etc/ssl/certs/ca-bundle.crt"; # fall back to cacert in Nix profile
        set -xg NIX_SSL_CERT_FILE "$NIX_LINK/etc/ssl/certs/ca-bundle.crt"
    else if test -e "$NIX_LINK/etc/ca-bundle.crt"; # old cacert in Nix profile
        set -xg NIX_SSL_CERT_FILE "$NIX_LINK/etc/ca-bundle.crt"
    end

    if test -n "$MANPATH";
        set -xg MANPATH "$NIX_LINK/share/man" $MANPATH;
    end

    set -xg PATH $NIX_LINK/bin $PATH;
    set --erase NIX_LINK;
end

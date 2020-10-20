#!/bin/sh

CONFIG_PATH="$(realpath $(dirname "$0"))/.gitconfig";
LINK_PATH="$HOME/.gitconfig";

if [ -f "$LINK_PATH" ]; then
    echo "Removing: $LINK_PATH";
    rm $LINK_PATH;
fi

echo "Linking: $CONFIG_PATH";
ln -s $CONFIG_PATH $LINK_PATH;
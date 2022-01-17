#!/usr/bin/bash

TARGET_DIR=$1;
if [[ -z "$TARGET_DIR" ]]; then
	TARGET_DIR=".";
fi;

explorer.exe $(wslpath -aw $TARGET_DIR)
#!/bin/sh

fzf --preview 'git -C {} ll && echo "" && echo "" && git -C {} status' --preview-window down:15:wrap $*
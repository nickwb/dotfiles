#!/bin/sh

git worktree list --porcelain | sed -n 's/^worktree //p'

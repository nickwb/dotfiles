This agent runs within WSL on windows.

Some code repositories are checked out under in Windows/NTFS at `/mnt/c/Users/NickYoung/code`. These are typically .NET projects.
Other code repositories are checked out in Linux/ext4 at `/home/nickwb/code`. These are typically single page web apps, nodejs, or terraform projects.

There is a symlink from `/mnt/c/Users/NickYoung/code/linuxfs` to `/home/nickwb/code`. If you use `fd` or `rg` with `--follow`, then you can search through all code on the system if you start from `/mnt/c/Users/NickYoung/code`. The `list-all-repos.sh` script, available on `$PATH`, will reliably list all git repositories checked out on this system. Do not assume that all repositories are direct children of the two root directories - some are organised into further subdirectories.

## Useful tools which are installed

- `rg` - ripgrep
- `fd` (Aliased as `fd` from the `fish` shell, available as `fdfind` everywhere).
- `jq` - For manipulating JSON
- `gh` - The Github CLI

## Git

Don't add Co-authored-by trailers to commits.

## Running Node and npm on this machine

There is no `node` or `npm` on the default `PATH`, and invoking either from a
plain `bash` shell will fail. This machine manages Node versions with the `nvm` plugin for the **fish** shell.
It installs node versions under `~/.local/share/nvm/`.

Because `nvm use` only affects the current shell session, every command that
needs Node has to activate it in the same invocation, for example:

```
fish -c 'nvm use; node --version'
fish -c 'nvm use; npm install'
```

`nvm use` with no argument reads the nearest `.nvmrc`, so running it from a
project directory that pins a version selects the right one automatically. A
`fish -c 'nvm use'` on its own accomplishes nothing for a subsequent separate
command, since the activation is lost when that shell exits.

## WSL System Clock

WSL's system clock can jump several seconds. Don't use it to measure elapsed time — use a monotonic timer instead.
`CLOCK_REALTIME` is never safe for measuring elapsed time anywhere — NTP steps, manual changes, and leap-second handling can all move it, including backwards.
`CLOCK_MONOTONIC` doesn't advance while the host is suspended, so a measurement spanning a sleep will under-report. It never goes backwards, though, so it's still the right choice.

## Analysis and design documents belong in the repo as markdown

When the user asks for a written deliverable — a background/analysis document, a design write-up, an
options comparison, an investigation report — produce it as a **markdown file inside the working
repository**, not as a published Artifact web page.

The reason is his review workflow: he reviews these documents with `crit`, the team's inline-comment
review tool, which operates on files in the repository (and syncs to GitHub PR review comments).

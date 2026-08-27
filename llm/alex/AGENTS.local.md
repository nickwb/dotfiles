This agent runs within WSL on windows.

Some code repositories are checked out under in Windows/NTFS at `/mnt/c/Users/NickYoung/code`. These are typically .NET projects.
Other code repositories are checked out in Linux/ext4 at `/home/nickwb/code`. These are typically single page web apps, nodejs, or terraform projects.

There is a symlink from `/mnt/c/Users/NickYoung/code/linuxfs` to `/home/nickwb/code`. If you use `fd` or `rg` with `--follow`, then you can search through all code on the system if you start from `/mnt/c/Users/NickYoung/code`.

## Useful tools which are installed

- `rg` - ripgrep
- `fd` (Aliased as `fd` from the `fish` shell, available as `fdfind` everywhere).
- `jq` - For manipulating JSON
- `gh` - The Github CLI

## Git

Don't add Co-authored-by trailers to commits.

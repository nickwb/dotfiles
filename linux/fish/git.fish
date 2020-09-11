alias g='git'

set -xg NICK_CODE_ROOT ~/code

function r
    if test -z "$argv";
        cd (list-all-repos.sh | fzf-git-repos.sh --select-1 --exact)
    else
        cd (list-all-repos.sh | fzf-git-repos.sh --select-1 --exact --query "$argv")
    end
end
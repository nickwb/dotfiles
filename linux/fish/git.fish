alias g='git'

function r
    if test -z "$argv";
        cd (list-all-repos.sh | fzf-git-repos.sh --select-1 --exact)
    else
        cd (list-all-repos.sh | fzf-git-repos.sh --select-1 --exact --query "$argv")
    end
end
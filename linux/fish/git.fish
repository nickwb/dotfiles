alias g='git'
alias rr='cd $NICK_CODE_ROOT'

function r
    set -l selected (list-all-repos.sh | fzf-git-repos.sh --select-1 --exact --query "$argv")
    if test -z "$selected"
        echo "No repository selected" >&2
        return 1
    end
    cd $selected
end

function wt
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "wt: not inside a git repository" >&2
        return 1
    end

    set -l selected (list-worktrees.sh | fzf-git-repos.sh --select-1 --exact --query "$argv")
    if test -z "$selected"
        echo "No worktree selected" >&2
        return 1
    end
    cd $selected
end

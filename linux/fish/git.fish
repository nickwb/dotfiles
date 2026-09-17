alias g='git'
alias rr='cd $NICK_CODE_ROOT'

# fzf-git-repos.sh forwards its arguments with an unquoted $*, so an empty
# --query would be dropped and fzf would complain. Only pass one when we have it.
function _fzf_query_args
    if test -z "$argv"
        return
    end
    echo --query
    echo "$argv"
end

function r
    set -l selected (list-all-repos.sh | fzf-git-repos.sh --select-1 --exact (_fzf_query_args $argv))
    test -n "$selected"; and cd $selected
end

function wt
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "wt: not inside a git repository" >&2
        return 1
    end

    set -l selected (list-worktrees.sh | fzf-git-repos.sh --select-1 --exact (_fzf_query_args $argv))
    test -n "$selected"; and cd $selected
end


[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion || {
    # if not found in /usr/local/etc, try the brew --prefix location
    [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ] && \
        . $(brew --prefix)/etc/bash_completion.d/git-completion.bash
}

alias g="git"

function _all_repos() {
	fgr ~/Code
}

function _child_repos() {
	fgr .
}

function _git_fzf() {
	fzf --preview 'git -C {} ll && echo "" && echo "" && git -C {} status' --preview-window down:15:wrap $*
}

function r() {
	if [ -z "$*" ]
	then
		cd `_all_repos | _git_fzf --select-1 --exact`
	else
		cd `_all_repos | _git_fzf --select-1 --exact --query "$*"`
	fi
}

# Recursively find all repositories under the current directory, and run a command
function each_child_repo() {
	ORIGIN=`pwd`;
	REPOS=`_child_repos`;
	COMMAND=$1;
	
	for d in $REPOS; do
		cd $d;
		eval $COMMAND;
		cd $ORIGIN;
	done
}

# Recursively show the status of all repositories under the current directory
function gitall() {
	each_child_repo 'pwd; git branch; git status -s';	
}

# Recursively list out all repositories under the current directory which are "dirty".
# (unstaged changes, not on master, etc.)
function gitdirty() {
	each_child_repo '_git_is_dirty';	
}

function _git_is_dirty() {
	BRANCH=`git symbolic-ref --short -q HEAD`;
	REPONAME=`pwd`;
	
	if [[ -n $(git status -s) ]]; then
		echo "$REPONAME has uncomitted changes on branch: $BRANCH.";
		git status -s;
	else
		if [ "$BRANCH" != "master" ]; then
			echo "$REPONAME is on branch: $BRANCH."
		fi;
	fi;
}

# Recursively update all repositories under the current directory
# but only if the repository is clean and on master.
function gitupall() {
	each_child_repo '_git_update';
}

function _git_update() {
	pwd;
	git fetch --prune origin;
	BRANCH=`git symbolic-ref --short -q HEAD`;
	if [ "$BRANCH" == "master" ]; then
		git merge origin/master --ff-only;
	else
		echo "Won't update. Branch is $BRANCH";
	fi;
}

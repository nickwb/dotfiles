
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

# Push a branch to origin and set upstream tracking.
# Will abort if you're on master. You should be publishing a feature branch.
# Warns you if there are uncommitted changes - but does not abort.
function gitpublish() {
	BRANCH=`git symbolic-ref --short -q HEAD`;
	if [ "$BRANCH" == "master" ]; then
		echo "You're on master. You shouldn't publish this.";
		return 1;
	fi;
	if [[ -n $(git status -s) ]]; then
		echo "WARNING: You have uncommitted changes or a dirty working tree.";
		echo "WARNING: I'm not telling you what to do, but maybe you forgot to commit?"
	fi;
	echo "Publishing an upstream branch for $BRANCH.";
	git push -u origin $BRANCH;
}

# "Unwind a branch".
# Once a branch has been merged to master, run this to make the local repository clean again.
# First checks that the current branch is not ahead of master. Will abort if it isn't.
# Prunes remote branches (so, delete your upstream branches once they are merged and finalised.)
# Switches to master, and deletes the local branch that you were on previously.
# Fast-forwards master to origin/master. 
function gitunwind() {
	if [[ -n $(git status -s) ]]; then
		echo "You have uncommitted changes or a dirty working tree. Aborting.";
		git status -s;
		return 1;
	fi;
	
	BRANCH=`git symbolic-ref --short -q HEAD`;
	if [ "$BRANCH" != "master" ]; then
		echo "Pulling remote changes...";
		git fetch --prune origin;
		HEADREV=`git rev-parse HEAD`;
		BASEREV=`git merge-base HEAD origin/master`;

		if [ "$HEADREV" == "$BASEREV" ]; then
			echo "Great; $BRANCH is on master. Unwinding...";
			CONTINUE=1;
		else
			echo "$BRANCH is ahead of master.";
			CONTINUE=0;
		fi;

		if [ "$1" == "-f" ]; then
			echo "Continuing anyway, as -f was specified.";
			CONTINUE=1;
		fi;

		if [ $CONTINUE -eq 1 ]; then
			git checkout master;
			git merge origin/master --ff-only;
			git branch -D $BRANCH;
			echo ""
			echo "Unwind complete. Deleted: $BRANCH."
			echo "Here's what you missed:"
			echo ""
			git log --oneline $HEADREV~1..master
		else
			echo "Aborting. You can force with gitunwind -f."
		fi;
	else
		echo "You're on master. Nothing to unwind!";
        echo "Will update instead.";
        git pull --prune;
	fi;
}
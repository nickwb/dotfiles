# not currently used

function prompt_callback {
    if [[ $PATH == *"/nix/store"* ]]; then
        echo -n " [nix]"
    fi
}


if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  #GIT_PROMPT_ONLY_IN_REPO=1
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi
alias text="open -a TextEdit"

alias fuu="killall -9 rider"
alias soundup='sudo pkill coreaudiod'

function past() {
    local run_cmd=`history -w /dev/stdout | fzf`
    echo $run_cmd
    read -p "Run? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        eval $run_cmd;
    fi
}

alias nsh=nix-shell

alias fcd='cd $(fd -t d | fzf)'
alias cat='bat --theme=OneHalfDark';
alias ls='exa';

alias top='top -o cpu';

# nvm
function nvmup() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

function maybeyarn() {
    if [ -f "package.json" ]; then
        yarn $*
    fi
}
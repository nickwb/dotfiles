alias cat='bat --theme=OneHalfDark'
alias ls='exa'
alias fuu='killall -9 rider'
alias fcd='cd (fd -t d | fzf)'
alias top='procs --watch --sortd cpu'
alias y='maybe-yarn'

# The name of fd is different depending on your package source...
if which fdfind > /dev/null
    alias fd='fdfind'
end

# Map open to explorer on WSL2
if which explorer.exe > /dev/null
    alias open='wsl-open.sh'
end

# Don't use docker desktop kubectl
if test -d "$HOME/.azure/bin"
    # az aks install-cli --install-location ~/.azure/bin/kubectl --kubelogin-install-location ~/.azure/bin/kubelogin
    alias kubectl="$HOME/.azure/bin/kubectl"
    alias kubelogin="$HOME/.azure/bin/kubelogin"
end

function kubecd
    kubectl config use-context (kubectl config get-contexts --output name | fzf --select-1 --exact --query "$argv")
end
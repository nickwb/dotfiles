alias cat='bat --theme=OneHalfDark'
alias ls='exa'
alias fuu='killall -9 rider'
alias fcd='cd (fd -t d | fzf)'
alias top='procs --watch --sortd cpu'
alias y='maybe-yarn'

if which fdfind
    alias fd='fdfind'
end
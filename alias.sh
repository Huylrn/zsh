#ALIAS
alias gf='my_git -f'
alias ginit='my_git -i'
alias gp='git pull'
alias gs='git push'
alias gst='git status'
alias ga='git add .'
alias gd='git diff'
alias gsh='git show'
alias gl='git log'
alias gd='git diff --name-only --relative --diff-filter=d | xargs bat --diff'

if [ $TERM_PROGRAM != "Apple_Terminal" ]; then
  alias ls='colorls --sd'
  alias l='ls -lA --sd'
  alias ll='ls --tree --sd'
  alias la='ls -A --sd'
  alias l1='ls -1 --sd'
fi
# function

alias s='search'
alias S='search -t input=en'
alias rm='rm-Advance'

alias vm='open -a iTerm'
alias v='nvim'

alias st='btm'
alias status='btm'
alias status='btm'
alias z='cd ..'
alias zz='cd ../..'
alias Z='exit'

alias pwc='pwd | clipcopy'

# bat configure
alias "fzf-p"='fzf --preview "bat --color=always --style=numbers --line-range=:1000 {}"'
alias "f"='fzf --preview "bat --color=always --style=numbers --line-range=:1000 {}"'
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

alias c='code'
alias ec='echo'

alias win11='cd ~/Parallels/thuoc && ./Launch_Parallels.command'

alias orm='command rm'
alias ols='command ls'
alias zshrc='nvim ~/.zshrc && source ~/.zshrc'
alias Drive_Huuy='/Users/$(whoami)/Library/CloudStorage/GoogleDrive-huuynguyendd@gmail.com/My\ Drive'
alias OneDrive='/Users/$(whoami)/Library/CloudStorage/OneDrive-Personal'
alias zalo='open https://chat.zalo.me/'
alias mess='open https://www.messenger.com/t/100038626849845'

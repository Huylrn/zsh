function my_git() {
    local branch_present label
    case "$1" in
    -i | --init)
        [ $(command ls -A | grep -w ".git") ] && echo "my_git: .git: Directory exists" && return 1
        touch -c .gitignore && echo ".DS_store" >>.gitignore && echo ".vscode" >>.gitignore
        git init && git status
        ;;
    -f | --fast)
        [ ! $(command ls -A | grep -w ".git") ] && echo "my_git: .git: Don't exists" && return 1
        branch_present=$(echo $(git branch) | grep "*" | awk '{print $2}')
        git diff --name-only --relative --diff-filter=d | xargs bat --diff
        vared -p "Label:" label
        [ $label = "q" ] && return
        git commit -am "$label"
        git push origin $branch_present
        ;;
    esac
}

function git-(){
    if [ $1 = i ]; then 
        touch -c .gitignore
        echo ".DS_store" >> .gitignore
        echo ".vscode" >> .gitignore
        git init
        git status
        return 0
    fi

    if [ $1 = f ]; then
        git diff
        read "?Label:" i

        if [ $i = q ]; then
            return 0
        fi
        git commit -am "$i"
        git push
        return 0
    fi

    if  [ -z $1 ]; then
        echo "No options"
        return 0
    fi

    exit 0
}

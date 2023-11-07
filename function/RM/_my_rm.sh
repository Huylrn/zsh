_my_rm(){
    if [ $(command ls -ld $1 | awk '{print $3}') = $(whoami) ]; then  
        [ -d $1 ] && rsync -avh --out-format="%n::size -> %l bytes %" $1 $HOME/.trash/dir || rsync -avh --out-format="%n::size -> %l bytes %" $1 $HOME/.trash/file
        echo "command rm ${options_rm[@]} $1"
    else
        printf "-> $(pwd)/\033[0;31m$1($(command ls -ld $1 | awk '{print $3}'))\033[0m\033[3;32m is not yours, to skip[y/n]:\033[0m"
        read -q tf
        echo 
        if [[ $tf = "y" ]] || [[ $tf = "Y" ]]; then
            [ -d $1 ] && rsync -avh --out-format="%n::size -> %l bytes %" $1 $HOME/.trash/dir || rsync -avh --out-format="%n::size -> %l bytes %" $1 $HOME/.trash/file
            echo "command rm ${options_rm[@]} $1"
        else
            return 0
        fi
    fi 

}

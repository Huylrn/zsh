_check_r_option_fn_rm(){
    for item in "${options_rm[@]}"; do
        echo "$item" | fold -w1 | while read -r char; do
            if [[ $char = r ]]; then
                return 0 
            fi
        done
    done
    return 1
}
_no_r_option_fn_rm(){
    _check_r_option_fn_rm 
    if [ $? -eq 1 ]; then
        [ -d $1 ] && {
            echo "\033[3;31mrm: $1: is a directory\033[0m"
            printf "\033[1;32mDo you want to add -r option to continue deleting[y/n]:\033[0m"
            read -q tf
            echo 
            if [ $tf = "y" -o $tf = "Y" ]; then
                options_rm+="-r"
                return 0
            else
                return 1
            fi
        } || return 0
    else
        return 0
    fi

}

_my_rm(){
    if [ ! -d $1 -a ! -f $1 ]; then
        echo "$(pwd)/$1: No such file or directory."
        return 1
    fi
    
    if [ $(command ls -ld $1 | awk '{print $3}') = $(whoami) ]; then
        _no_r_option_fn_rm $1
        if [ $? -eq 1 ]; then
            return 1
        fi
        {[ -d $1 ] && rsync -avh --out-format="%n::size -> %l bytes" $1 $HOME/.trash/dir || rsync -avh --out-format="%n::size -> %l bytes %" $1 $HOME/.trash/file} && command rm ${options_rm[@]} $1 && echo "\033[0;35m[Message] \033[2;30m($1)\033[0m ->\033[0m \033[3;32mFinshed.\033[0m"
    else
        printf "-> $(pwd)/\033[0;31m$1($(command ls -ld $1 | awk '{print $3}'))\033[0m\033[3;32m is not yours, to skip[y/n]:\033[0m"
        read -q tf
        echo 
        if [[ $tf = "y" ]] || [[ $tf = "Y" ]]; then
            _no_r_option_fn_rm $1
            if [ $? -eq 1 ]; then
                return 1
            fi
            {[ -d $1 ] && rsync -avh --out-format="%n::size -> %l bytes" $1 $HOME/.trash/dir || rsync -avh --out-format="%n::size -> %l bytes %" $1 $HOME/.trash/file} && command rm -f ${options_rm[@]} $1 && echo "\033[0;35m[Message] \033[2;30m($1)\033[0m ->\033[0m \033[3;32mFinshed.\033[0m"
        else
            return 0
        fi
    fi 

}

_check_option_fn_rm(){
    for item in "${options_rm[@]}"; do
        echo "$item" | fold -w1 | while read -r char; do
            if [[ $char = $1 ]]; then
                return 0 
            fi
        done
    done
    return 1
}

_add_r_option_fn_rm(){
    _check_option_fn_rm r
    if [ $? -eq 1 ]; then
        [ -d $1 ] && {
            
            # TURN OFF MESSAGE

            # echo "\033[3;31mrm: $1: is a directory\033[0m"
            # printf "\033[1;32mDo you want to add -r option to continue deleting[y/n]:\033[0m"
            # read -q tf
            # echo 
            # if [ $tf = "y" -o $tf = "Y" ]; then
            #     options_rm+="-r"
            #     return 0
            # else
            #     return 1
            # fi
            options_rm+="-r"
            return 0
        } || return 0
    else
        return 0
    fi

}

_option_undo_fn_rm(){
  # option -u --undo
    if [ ${#options_rm[@]} -eq 1 ]; then
        if [ $options_rm[@] = "--undo" -o $options_rm[@] = "-u" ]; then
            [ ${#dir_or_file[@]} -ne 0 ] && echo "\033[0;31m[Message]\033[0m -> $dir_or_file[@] :No such file or directory in trash."
            for input in $dir_or_file_none[@]; do
                if [ -d $HOME/.trash/dir/$input ]; then
                    local path_cache_trash="$(command tail -n 1 $HOME/.trash/dir/$input/.my_cache)"
                    mv -v $HOME/.trash/dir/$input $path_cache_trash && command rm $path_cache_trash/.my_cache
                
                elif [ -f $HOME/.trash/file/$input ]; then
                    local path_cache_trash="$(command tail -n 1 $HOME/.trash/file/$input)"
                    local _temp_=$(($(wc $HOME/.trash/file/$input | awk '{print $1}')-4))
                    command sed -n '1,'$_temp_'p' $HOME/.trash/file/$input >> $path_cache_trash
                    command rm $HOME/.trash/file/$input
                
                else
                    echo "\033[0;31m[Message]\033[0m -> $test :No such file or directory in trash."
                fi  
            done && return 0
        else
            echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
    else 
        echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
}

_content_my_cache(){
    if [ -f $1 ]; then
        command echo >> $1
        command echo "Time to delete: $(date)" >> $1
        command echo "path:" >> $1
        command echo $(realpath $1) >> $1
    else
        command echo >> $1./.my_cache
        command echo "Time to delete: $(date)" >> $1/.my_cache
        command echo "path:" >> $1/.my_cache
        command echo $(realpath $1) >> $1/.my_cache

    fi
}

_my_main_rm(){
    if [ ! -d $1 -a ! -f $1 ]; then
        echo "$(pwd)/$1 :No such file or directory."
        return 1
    elif _check_option_fn_rm u; then
        [ $? -eq 0 ] && echo "  [option: ${options_rm[@]}] :bad substitution."; return 1
    else 
        [ -d $1 ] && type="Dir" || type="File"
    fi
    
    if [ $(command ls -ld $1 | awk '{print $3}') = $(whoami) ]; then
        _add_r_option_fn_rm $1
        if [ $? -eq 1 ]; then
            return 1
        fi
        
        _content_my_cache $1
        echo "\033[5;2;3;30mDeleting...\033[0m"
        {[ -d $1 ] && rsync -avh --out-format="%n :: size -> %l bytes" $1 $HOME/.trash/dir || rsync -avh --out-format="%n :: size -> %l bytes" $1 $HOME/.trash/file} && command rm ${options_rm[@]} $1 && echo "\033[0;35m[Message] \033[3;31m$1 is [$type]\033[0m ->\033[0m \033[3;32mSuccessfully deleted.\033[0m"
        echo
    else
        printf "-> $(pwd)/\033[0;31m$1($(command ls -ld $1 | awk '{print $3}'))\033[0m\033[3;32m is not yours, to skip[y/n]:\033[0m"
        read -q tf
        echo 
        if [[ $tf = "y" ]] || [[ $tf = "Y" ]]; then
            _add_r_option_fn_rm $1
            if [ $? -eq 1 ]; then
                return 1
            fi
            if [ -f $1 ]; then
                _content_my_cache $1
            else
                _content_my_cache $1/.my_cache
            fi
            {[ -d $1 ] && rsync -avh --out-format="%n :: size -> %l bytes" $1 $HOME/.trash/dir || rsync -avh --out-format="%n::size -> %l bytes" $1 $HOME/.trash/file} && command rm -f ${options_rm[@]} $1 && echo "\033[0;35m[Message] \033[3;31m/$1($(command ls -ld $1 | awk '{print $3}')) is [$type]\033[0m ->\033[0m \033[3;32mSuccessfully deleted.\033[0m"
            echo
        else
            return 1
        fi
    fi 

}

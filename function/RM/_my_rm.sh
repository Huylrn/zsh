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

_add_option_fn_rm(){
    _check_option_fn_rm $2
    if [ $? -eq 1 ]; then
        [ -d $1 -o -f $1 ] && {
            if [ $_message_require_toggle_fn_RM = TRUE ]; then
                # echo "\033[3;31mrm: $1: is a directory\033[0m"
                printf "\033[1;32mDo you want to add -$2 option to continue deleting[y/n]:\033[0m"
                read -q tf
                echo 
                if [ $tf = "y" -o $tf = "Y" ]; then
                    options_rm+="-$2"
                    return 0
                else
                    return 1
                fi
            else # TURN OFF REQUIRE MESSAGE 
                options_rm+="-$2"
                return 0
            fi
        } || return 0
    else
        return 0
    fi
    # _check_option_fn_rm r
    # if [ $? -eq 1 ]; then
    #     [ -d $1 ] && {
    #         if [ $_message_require_toggle_fn_RM = TRUE ]; then
    #             echo "\033[3;31mrm: $1: is a directory\033[0m"
    #             printf "\033[1;32mDo you want to add -r option to continue deleting[y/n]:\033[0m"
    #             read -q tf
    #             echo 
    #             if [ $tf = "y" -o $tf = "Y" ]; then
    #                 options_rm+="-r"
    #                 return 0
    #             else
    #                 return 1
    #             fi
    #         else # TURN OFF REQUIRE MESSAGE 
    #             options_rm+="-r"
    #             return 0
    #         fi
    #     } || return 0
    # else
    #     return 0
    # fi

}

_option_undo_fn_rm(){
  # option -u --undo
    if [ ${#options_rm[@]} -eq 1 ]; then
        if [ $options_rm[@] = "--undo" -o $options_rm[@] = "-u" ]; then
            if [ ${#dir_or_file[@]} -ne 0 ]; then # MESSAGE
                for i in $dir_or_file[@]; do
                    echo "\033[0;31m[Message]\033[0m -> $i :No such file or directory in trash."
                done
            fi
            for input in $dir_or_file_none[@]; do
                if [ -d $HOME/.trash/dir/$input ]; then
                    local path_cache_trash="$(command tail -n 1 $HOME/.trash/dir/$input/.my_cache)"
                    mv -v $HOME/.trash/dir/$input $path_cache_trash
                    [ $? -eq 0 ] && command rm $path_cache_trash/.my_cache || echo "rm: [error] :$input"
                
                elif [ -f $HOME/.trash/file/$input ]; then
                    local path_cache_trash="$(command tail -n 1 $HOME/.trash/file/$input)"
                    local _temp_=$(($(wc $HOME/.trash/file/$input | awk '{print $1}')-4))
                    command sed -n '1,'$_temp_'p' $HOME/.trash/file/$input >> $path_cache_trash && echo "$HOME/.trash/file/$input -> $path_cache_trash"
                    [ $? -eq 0 ] && command rm $HOME/.trash/file/$input || echo "rm: [error] :$input"
                
                else
                    echo "\033[0;31m[Message]\033[0m -> $input :No such file or directory in trash." # MESSAGE
                fi  
            done && return 0
        else
            echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
    else 
        echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
}

_content_my_cache(){
    if [ -f $1 ]; then
        echo >> $1
        echo "Time to delete: $(date)" >> $1
        echo "path:" >> $1
        echo $(realpath $1) >> $1
    else 
        echo >> $1/.my_cache
        echo "Time to delete: $(date)" >> $1/.my_cache
        echo "path:" >> $1/.my_cache
        echo $(realpath $1) >> $1/.my_cache

    fi
}

_delete_fn_rm(){
    _content_my_cache $1
    echo "\033[5;2;3;30mDeleting...\033[0m"
    if [ -d $1 ]; then 
        [ -d $HOME/.trash/dir/$1 ] && mv $HOME/.trash/dir/$1 $HOME/.trash/dir/"$1-replace-in-$(date +%F)"
        rsync -avh --out-format="%n :: size -> %l bytes" $1 $HOME/.trash/dir && command rm ${options_rm[@]} $1
        [ $? -eq 0 ] && echo "\033[0;35m[Message] \033[4;3;31m$1\033[0m is \033[3;1;36m($_type_)\033[0m ->\033[0m \033[3;32mSuccessfully deleted.\033[0m" || { 
            command rm -rf $1
            rsync -a $HOME/.trash/dir/$1 ../$1
            command rm -rf $HOME/.Trash/dir/$1
            return 1
        }
    else    
        [ -f $HOME/.trash/file/$1 ] && mv $HOME/.trash/file/$1 $HOME/.trash/file/"$1-replace-in-$(date +%F)"
        rsync -avh --out-format="%n :: size -> %l bytes" $1 $HOME/.trash/file && command rm ${options_rm[@]} $1
        [ $? -eq 0 ] && echo "\033[0;35m[Message] \033[4;3;31m$1\033[0m is \033[3;1;32m($_type_)\033[0m ->\033[0m \033[3;32mSuccessfully deleted.\033[0m" || {
            command rm -rf $1
            rsync -a $HOME/.trash/file/$1 
            command rm -rf $HOME/.Trash/file/$1
            return 1
        }
    fi
    echo
}

_my_main_rm(){
    if [ ! -d $1 -a ! -f $1 ]; then
        echo "$(pwd)/$1 :No such file or directory."
        return 1
    elif _check_option_fn_rm u; then
        [ $? -eq 0 ] && echo "  [option: ${options_rm[@]}] :bad substitution."; return 1
    else 
        [ -d $1 ] && local _type_="Dir" || local _type_="File"
    fi
    
    if [ $(command ls -ld $1 | awk '{print $3}') = $(whoami) ]; then
        _add_option_fn_rm $1 r
        if [ $? -eq 1 ]; then
            return 1
        fi
        _delete_fn_rm $1
    else
        printf "-> $(pwd)/\033[0;31m$1($(command ls -ld $1 | awk '{print $3}'))\033[0m\033[3;32m is not yours, to skip[y/n]:\033[0m"
        read -q tf
        echo 
        if [[ $tf = "y" ]] || [[ $tf = "Y" ]]; then
            _add_option_fn_rm $1 r
            if [ $? -eq 1 ]; then
                return 1
            fi
            sudo chmod g+w $1
            [ $? -eq 0 ] && _delete_fn_rm $1 || return 1
        else
            return 1
        fi
    fi 

}

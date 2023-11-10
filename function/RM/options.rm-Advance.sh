_option_undo_fn_rm(){
  # option -u --undo
    if [ ${#options_rm[@]} -eq 1 ]; then
        if [ $options_rm[@] = "--undo" -o $options_rm[@] = "-u" ]; then
            if [ ${#dir_or_file[@]} -ne 0 ]; then # MESSAGE
                for i in $dir_or_file[@]; do
                    echo "\033[0;31m[Message]\033[0m -> $i :No such file or directory in trash. ??????????"
                done
            fi
            for input in "$dir_or_file_none[@]"; do
                if [ -d $_trash_dir/$input ]; then
                    local path_cache_trash="$(command tail -n 1 $_trash_dir/$input/.my_cache)"
                    mv -v $_trash_dir/$input $path_cache_trash
                    [ $? -eq 0 ] && command rm $path_cache_trash/.my_cache || echo "rm: [error] :$input"
                
                elif [ -f $_trash_file/$input ]; then
                    local path_cache_trash="$(command tail -n 1 $_trash_file/$input)"
                    local _temp_=$(($(wc $_trash_file/$input | awk '{print $1}')-4))
                    command sed -n '1,'$_temp_'p' $_trash_file/$input >> $path_cache_trash && echo "$_trash_file/$input -> $path_cache_trash"
                    [ $? -eq 0 ] && command rm $_trash_file/$input || echo "rm: [error] :$input"
                
                else
                    echo "\033[0;31m[Message]\033[0m -> $input :No such file or directory in Trash. yryryryry" # MESSAGE

                fi  
            done && return 0
        else
            echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
    else 
        echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
}

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
            if [ "$_message_require_toggle_fn_RM" = "TRUE" ]; then
                printf "\033[1;32mDo you want to add -$2 option to continue deleting \033[4;3;31m$2\033[0m \033[3;1;36m($_type_)\033[0m \033[1;32m[y/n]:\033[0m"
                read -q tf
                echo 
                if [ $tf = "y" -o $tf = "Y" ]; then
                    options_rm+="-$2"
                    return 0
                else
                    return 1
                fi
            else # TURN OFF REQUIRE CONFIRM 
                options_rm+="-$2"
                echo "-$2"
                return 0
            fi
        } || return 0
    else
        return 0
    fi
}
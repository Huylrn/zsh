_message_undo_rm_Advance(){
    if [ $_message_require_recover_fn_rm = "TRUE" ]; then
        # if [ $_type_undo = "dir" ]; then
            [ $2 != "$(pwd)/" ] && {
                echo -n "The $3 will be recover at old path " && _default_home_rm_Advance "(" $2 ")." && echo
                echo -n "If you want recover here" && _default_home_rm_Advance " (" "$(pwd)/" ") [y/n]:" 
                read -q tf
                echo 
            } || local tf="n"
            [ ${#4} -ne 0 ] && echo "The name is the same while being recover should be renamed -> $1$4"
            _default_home_rm_Advance "-> " $2$1$4 "($3)"
            echo
            return 0
    else
         _default_home_rm_Advance "-> " $2$1$4 "($3)"
        local tf="n"
        return 0
    fi
}

_recover_undo_rm_Advance(){
    if [[ $3 = "dir" ]]; then
        local _mode=$(tail -n 2 $_trash_dir/$1/.my_cache | sed -n 1p)
        rsync -a --exclude=.my_cache $_trash_dir/$1 $2/$1$4 && chmod $_mode $2/$1$4
        [ $? -eq 0 ] && {
            command rm -r $_trash_dir/$1 
            [ $? -eq 0 ] && {
                _message_output_rm_Advance recover
                echo " -> \033[0m \033[3;32mSuccessfully recover.\033[0m"
            } || {
                echo "$_error_rm_ when recover $1 ($3)"
                return 1
            }
        } || {
            command rm -rf $2/$1$4
            echo "$_error_rm_ when recover $1 ($3)"
            return 1
        }
    
    elif [[ $3 = "file" ]]; then
        local _mode=$(tail -n 2 $_trash_file/$1 | sed -n 1p)
        command sed -n '1,'$_temp_'p' $_trash_file/$1 >> $2/$1$4 && chmod $_mode $2/$1$4
        [ $? -eq 0 ] && {
            command rm $_trash_file/$1 
            [ $? -eq 0 ] && {
                _message_output_rm_Advance recover
                echo " -> \033[0m \033[3;32mSuccessfully recover.\033[0m"
            } || {
                echo "$_error_rm_ when recover $1 ($3)"
                return 1
            }
        } || {
            command rm -rf $2/$1$4
            echo "$_error_rm_ when recover $1 ($3)"
            return 1
        }
    fi 
}

_filter_undo_rm_Advance(){ # filter file or dir
    local _name_="$(echo "$1" | sed 's/ /\\ /g')"
    local f_undo="${$(grep -Fn "$_name_" ~/.Trash/.undo_cache | awk '{print $1}')%:*}"
    [ ! -z $f_undo ] && sed -i.old ''$f_undo'd' ~/.Trash/.undo_cache





    _message_require_recover_fn_rm=TRUE
    if [ -d $_trash_dir/$1 ]; then
        local _type_dirT="dir"
        local _path_dirT="$(command tail -n 1 $_trash_dir/$1/.my_cache)"
        _message_undo_rm_Advance $1 $_path_dirT/ $_type_dirT $2 &&
        [[ $tf = "y" ]] && _recover_undo_rm_Advance $1 $(pwd) $_type_dirT $2 || _recover_undo_rm_Advance $1 $_path_dirT $_type_dirT $2
    elif [ -f $_trash_file/$1 ]; then
        local _type_fileT="file" 
        local _path_fileT="${$(command tail -n 1 $_trash_file/$1)%/*}"
        local _temp_=$(($(wc $_trash_file/$1 | awk '{print $1}')-4))
        _message_undo_rm_Advance $1 $_path_fileT/ $_type_fileT $2 && 
        [[ $tf = "y" ]] && _recover_undo_rm_Advance $1 $(pwd) $_type_fileT $2 || _recover_undo_rm_Advance $1 $_path_fileT $_type_fileT $2
    else
        _message_output_rm_Advance error
        echo " -> $1 :No such file or directory in trash."
        return 1 
    fi
}

_option_undo_fn_rm(){ # option -u --undo
    if [ ${#options_rm[@]} -eq 1 ]; then
        if [ $options_rm[@] = "--undo" -o $options_rm[@] = "-u" ]; then
            
            if [ ${#dir_or_file[@]} -ne 0 ]; then
                for name in ${dir_or_file[@]}; do            
                    if [ -d $_trash_dir/$name -o -f $_trash_file/$name ]; then
                        _filter_undo_rm_Advance $name ".recover"
                    else
                        _message_output_rm_Advance error
                        echo " -> $name :No such file or directory in trash."; 
                    fi
                done
            fi
            
            if [ ${#dir_or_file_none[@]} -ne 0 ]; then
                for input in $dir_or_file_none[@]; do
                    _filter_undo_rm_Advance $input
                done && return 0
            elif [ ${#dir_or_file[@]} -eq 0 ]; then
                echo "$_error_rm_ only option ??"
            fi
        else
            echo "$_error_rm_ [option: ${options_rm[@]}] :bad substitution." && return 1; fi
    else 
        echo "$_error_rm_ [option: ${options_rm[@]}] :bad substitution." && return 1; fi
}
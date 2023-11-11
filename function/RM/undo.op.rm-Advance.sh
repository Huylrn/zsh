_message_undo_rm_Advance(){
    if [ $_message_require_recover_fn_rm = "TRUE" ]; then
        # if [ $_type_undo = "dir" ]; then
            echo "The folder will be recover at old path ($2)."
            echo "  here :$(pwd)/"
            echo -n "If you want recover here[y/n]:"
            read -q tf
            echo
            return 0
    else
        local tf="y"
        return 0
    fi
}

_delete_undo_rm_Advance(){
    if [[ $3 = "dir" ]]; then
        echo $4
        mv -f $_trash_dir/$1 $2/$1$4 && command rm $2/$1$4/.my_cache 
        [ $? -eq 0 ] && echo "Recover ok" || echo "$_error_rm_ when recover $1 (dir)"
    elif [[ $3 = "file" ]]; then
        command sed -n '1,'$_temp_'p' $_trash_file/$1 >> $2/$1$4 && command rm $_trash_file/$1 
        [ $? -eq 0 ] && echo "recover ok" || echo "$_error_rm_ when recover $1 (file)"
        # echo "$_trash_file/$1 -> $2/$1$4"
    fi 
}

_filter_undo_rm_Advance(){
    # filter file or dir
    _message_require_recover_fn_rm=TRUE
    if [ -d $_trash_dir/$1 ]; then
        local _type_dirT="dir"
        local _path_dirT="$(command tail -n 1 $_trash_dir/$1/.my_cache)"
        _message_undo_rm_Advance $1 $_path_dirT/ $2 &&
        [ $tf = "y" ] && _delete_undo_rm_Advance $1 $(pwd) $_type_dirT || _delete_undo_rm_Advance $1 $_path_dirT $_type_dirT $2
    elif [ -f $_trash_file/$1 ]; then
        local _type_fileT="file" 
        local _path_fileT="${$(command tail -n 1 $_trash_file/$1)%/*}"
        local _temp_=$(($(wc $_trash_file/$1 | awk '{print $1}')-4))
        _message_undo_rm_Advance $1 $_path_fileT/ $2 && 
        [ $tf = "y" ] && _delete_undo_rm_Advance $1 $(pwd) $_type_fileT || _delete_undo_rm_Advance $1 $_path_fileT $_type_fileT $2
    else
        echo "\033[0;31m[Message]\033[0m -> $1 :No such file or directory in trash. ?????nnn?????"
        return 1 
    fi
}

_same_name_rm_Advance(){
    for name in $dir_or_file[@]; do
        if [ -d $_trash_dir/$name -o -f $_trash_file/$name ]; then
            if [ -d $_trash_dir/$name ]; then
                local _path_dirT="$(command tail -n 1 $_trash_dir/$name/.my_cache)"
                local _type_dirT="dir" 
            elif [ -f $_trash_file/$name ]; then
                local _path_fileT="${$(command tail -n 1 $_trash_file/$name)%/*}"
                local _type_fileT="file"
                local _temp_=$(($(wc $_trash_file/$1 | awk '{print $1}')-4))
            fi
            
            [ -d $name ] && local _type_here="dir" || local _type_here="file"
            
            echo "test: \$_type_dirT $_type_dirT "
            echo "test: \$_type_fileT $_type_fileT "
            echo "test: \$_path_dirT $_path_dirT"
            echo "test: \$_path_fileT $_path_fileT"
            echo "test: \$(realpath $name) ${$(realpath $name)%/*}" 
            
            if [[ $_type_dirT = "dir" ]] && [[ $_path_dirT = ${$(realpath $name)%/*} ]]; then
                _message_undo_rm_Advance $name $_path_dirT/$name
                [ $tf = "y" ] && _delete_undo_rm_Advance $1 $(pwd) $_type_dirT || _delete_undo_rm_Advance $1 $_path_dirT $_type_dirT
                
                echo "duong dan nhu nhau $_path_dirT ($_type_dirT)"
                mv -v $_trash_dir/$(basename $name) $(pwd)/"$(basename $name).trash"
            elif [[ $_type_fileT = "file" ]] && [[ $_path_fileT = ${$(realpath $name)%/*} ]]; then

                _message_undo_rm_Advance $name $_path_fileT/$name
                [ $tf = "y" ] && _delete_undo_rm_Advance $1 $(pwd) $_type_fileT || _delete_undo_rm_Advance $1 $_path_fileT $_type_fileT
                
                echo "duong dan nhu nhau $_path_fileT ($_type_fileT)"
                mv -v $_trash_file/$(basename $name) $(pwd)/"$(basename $name).trash"
            fi

            echo "Do you have two file:"
            echo "$name ($_type_here) here || $name ($_type_trash) in trash."
            echo -n "Do you want rename and recover here[y/n]:" 
            read -q tf
            echo
            [ $tf = "y" -o $tf = "Y" ] && {
                # dir_or_file_none+=$(basename $name)
                [ "$_type_trash" = "Dir" ] && {
                    mv -v $_trash_dir/$(basename $name) $(pwd)/"$(basename $name).trash"
                } || mv -v $_trash_file/$(basename $name) $(pwd)/"$(basename $name).trash"
            }
        else
                echo "\033[0;31m[Message]\033[0m -> $name :No such file or directory in trash. ??????????"
        fi
    done
}
_option_undo_fn_rm(){
  # option -u --undo

    if [ ${#options_rm[@]} -eq 1 ]; then
        if [ $options_rm[@] = "--undo" -o $options_rm[@] = "-u" ]; then

            # echo "${#dir_or_file_none[@]}"
            # echo "${#dir_or_file[@]}"
            # [ ${#dir_or_file[@]} -ne 0 ] 
            if [ ${#dir_or_file[@]} -ne 0 ]; then
                for name in ${dir_or_file[@]}; do            
                    if [ -d $_trash_dir/$name -o -f $_trash_file/$name ]; then
                        # _same_name_rm_Advance 
                        _filter_undo_rm_Advance $name ".recover"
                    else
                        echo "\033[0;31m[Message]\033[0m -> $name :No such file or directory in trash. ??????jjj ????"
                        return 1
                    fi
                done
            fi
            
            for input in $dir_or_file_none[@]; do
                _filter_undo_rm_Advance $input
            done && return 0
        
        else
            echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
    else 
        echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
}
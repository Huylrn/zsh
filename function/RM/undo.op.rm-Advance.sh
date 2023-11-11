_message_undo_rm_Advance(){
    if [ $_message_require_recover_fn_rm = "TRUE" ]; then
        # if [ $_type_undo = "dir" ]; then
            echo "The folder will be recover at old path ($2)."
            echo "  here :$(pwd)/$1"
            echo -n "If you want recover here[y/n]:"
            read -q tf
            echo
            return 0
    else
        local tf="y"
        return 0
    fi
}

_path_undo_rm_Advance(){
    if [ -d $_trash_dir/$1 ]; then
        mv -v $_trash_dir/$1 $2/$1
        [ $? -eq 0 ] && command rm $2/$1/.my_cache || echo "$_error_rm_ when deleting $1 (dir)"
    elif [ -f $_trash_file/$1 ]; then
        command sed -n '1,'$_temp_'p' $_trash_file/$1 >> $2/$1 && echo "$_trash_file/$1 -> $2/$1"
        [ $? -eq 0 ] && command rm $_trash_file/$1 || echo "$_error_rm_ when deleting $1 (file)"
    else
        echo "\033[0;31m[Message]\033[0m -> $1 :No such file or directory in Trash. yryryryry" # MESSAGE
    fi  
}

_undo_rm_Advance(){
    # filter file or dir
    _message_require_recover_fn_rm=TRUE
    if [ -d $_trash_dir/$1 ]; then
        local _type_undo="dir"
        local path_fr_cache_dir="$(command tail -n 1 $_trash_dir/$1/.my_cache)"
        _message_undo_rm_Advance $1 $path_fr_cache_dir$1 &&
        [ $tf = "y" ] && _path_undo_rm_Advance $1 $(pwd) || _path_undo_rm_Advance $1 $path_fr_cache_dir
    else
        local _type_undo="file" 
        local path_fr_cache_file="${$(command tail -n 1 $_trash_file/$1)%/*}"
        local _temp_=$(($(wc $_trash_file/$1 | awk '{print $1}')-4))
        _message_undo_rm_Advance $1 $path_fr_cache_file/$1 
        [ $tf = "y" ] && _path_undo_rm_Advance $1 $(pwd) || _path_undo_rm_Advance $1 $path_fr_cache_file
    fi
}

_option_undo_fn_rm(){
  # option -u --undo

    if [ ${#options_rm[@]} -eq 1 ]; then
        if [ $options_rm[@] = "--undo" -o $options_rm[@] = "-u" ]; then

            if [ ${#dir_or_file[@]} -ne 0 ]; then # MESSAGE
                for i in $dir_or_file[@]; do
                    [ -d $_trash_dir/$(basename $i) -o -f $_trash_file/$(basename $i) ] && {
                        [ -d $_trash_dir/$(basename $i) ] && local _type_trash="Dir" || local _type_trash="File"
                        [ -d $i ] && local _type_here="Dir" || local _type_here="File"
                        echo "Do you have two file:"
                        echo "$i ($_type_here) here." 
                        echo "$(basename $i) ($_type_trash) in trash."
                        echo -n "Do you want recover here[y/n]:" 
                        read -q tf
                        echo
                        [ $tf = "y" -o $tf = "Y" ] && {
                            # dir_or_file_none+=$(basename $i)
                            [ "$_type_trash" = "Dir" ] && {
                                mv -v $_trash_dir/$(basename $i) $(pwd)/"$(basename $i).trash"
                            } || mv -v $_trash_file/$(basename $i) $(pwd)/"$(basename $i).trash"
                        } || continue
                    } || echo "\033[0;31m[Message]\033[0m -> $i :No such file or directory in trash. ??????????"
                done
            fi
            
            for input in $dir_or_file_none[@]; do
                _undo_rm_Advance $input
            done && return 0
        else
            echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
    else 
        echo " [option: ${options_rm[@]}] :bad substitution." && return 1; fi
}
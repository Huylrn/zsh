source $HOME/.config/zsh/function/RM/options.rm-Advance.sh
_content_my_cache(){
    if [ -f $1 ]; then
        chmod u+w $1
        echo >> $1
        echo "Time to deleted: $(date)" >> $1
        echo "path:" >> $1
        echo $(realpath $1) >> $1
    else
        chmod u+w $1 
        echo >> $1/.my_cache
        echo "Time to deleted: $(date)" >> $1/.my_cache
        echo "path:" >> $1/.my_cache
        echo $(realpath $1) >> $1/.my_cache

    fi
}

_delete_fn_rm(){
    _content_my_cache $1
    echo "\033[5;2;3;30mDeleting...\033[0m"
    if [ -d $1 ]; then 
        [ -d $_trash_dir/$(basename $1) ] && {

            # same name in trash and $1_here
            local _replace_name=".replace_at_$(date +%H-%M-%S_%d%m%y)"
            echo "$(command tail -n 1 $_trash_dir/$(basename $1)/.my_cache)$_replace_name" >> $_trash_dir/$1/.my_cache # add new path
            mv $_trash_dir/$(basename $1) $_trash_dir/"$1$_replace_name" # rename 
        }

        # deleting...
        rsync -avh --out-format="%n :: size -> %l bytes" $1 $_trash_dir && command rm ${options_rm[@]} $1
        [ $? -eq 0 ] && echo "\033[0;35m[Message] \033[4;3;31m$1\033[0m is \033[3;1;36m($_type_)\033[0m ->\033[0m \033[3;32mSuccessfully deleted.\033[0m" || { 
            
            # delete fault
            # local path_deleted_error="$(realpath $1)"
            command rm -rf $1
            chmod u+w $_trash_dir/"$(basename $1)" 
            command rm -f $_trash_dir/"$(basename $1)"/.my_cache
            rsync -a $_trash_dir/"$(basename $1)" "$1-deleted-error" && command rm -rf $_trash_dir/"$(basename $1)"
            return 1
        }
    else    
        [ -f $_trash_file/$(basename $1) ] && {

            # same name in trash and $1_here
            local _new_name_trash="replace_at_$(date +%H-%M-%S_%d%m%y)"
            local _old_name_trash="$(command tail -n 1 $_trash_file/$(basename $1))"
            local _Eline_file_in_trash=$(wc $_trash_file/$(basename $1) | awk '{print $1}')
            
            mv $_trash_file/$(basename $1) $_trash_file/"$1.$_new_name_trash" && # rename  
            sed -i.temp -e ''$_Eline_file_in_trash'd' $_trash_file/"$(basename $1).$_new_name_trash" && # remove old path
            echo "$_old_name_trash.$_new_name_trash" >> $_trash_file/$(basename $1).$_new_name_trash && # add new path
            command rm $_trash_file/"$1.$_new_name_trash.temp" # delete redundant file
        }

        # deleting...
        rsync -avh --out-format="%n :: size -> %l bytes" $1 $_trash_file && command rm ${options_rm[@]} $1
        [ $? -eq 0 ] && echo "\033[0;35m[Message] \033[4;3;31m$1\033[0m is \033[3;1;32m($_type_)\033[0m ->\033[0m \033[3;32mSuccessfully deleted.\033[0m" || {

            # delete fault
            # local path_deleted_error="$(realpath $1)"
            command rm -f $1 &&
            rsync -a $_trash_file/"$(basename $1)" "$1-deleted-error" && command rm -f $_trash_file/"$(basename $1)"
            return 1
        }
    fi
    echo
}

_rm_Advance_main(){
    if [ ! -d $1 -a ! -f $1 ]; then
        echo "rm-Advance: $(pwd)/$1 :No such file or directory."
        return 1
    elif _check_option_fn_rm u; then
        [ $? -eq 0 ] && echo "  [option: ${options_rm[@]}] :bad substitution."; return 1
    else 
        [ -d $1 ] && local _type_="Dir" || local _type_="File"
    fi
    
    if [ $(command ls -ld $1 | awk '{print $3}') = $(whoami) ]; then
        [ -d $1 ] && {
            _add_option_fn_rm $1 r
            if [ $? -eq 1 ]; then
                return 1
            fi
        }
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

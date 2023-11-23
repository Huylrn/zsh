_content_my_cache(){
    local _mode=$(stat -f %A $1) # save 
    [ $(command ls -ld $1 | awk '{print $3}') = $(whoami) ] && chmod 777 $1 || sudo chmod 777 $1
    if [ -f $1 ]; then
        echo >> $1
        echo "Time to deleted: $(date)" >> $1
        echo $_mode >> $1
        echo $(realpath $1) >> $1
    else
        echo >> $1/.my_cache
        echo "Time to deleted: $(date)" >> $1/.my_cache
        echo $_mode >> $1/.my_cache
        echo ${$(realpath $1 | awk '{print $1}')%/*} >> $1/.my_cache
    fi
}

_delete_rm_Advance(){
    _content_my_cache $1
    local _dir=$(find $1 -type d | wc -l | awk '{print $1}')
    local _file=$(find $1 -type f | wc -l | awk '{print $1}')
    echo "\033[5;2;3;30mDeleting...\033[0m"
    if [ -d $1 ]; then # delete -> directory 
     # same name in trash and $1_here
        [ -d $_trash_dir/"$(basename $1)" ] && {
            local _replace_name=".replace_at_$(date +%H-%M-%S_%d%m%y)"
            mv $_trash_dir/"$(basename $1)" $_trash_dir/"$(basename $1)$_replace_name" # rename 
        }       
        
     # deleting...
        rsync -avh --out-format="%n -> %l bytes" $1 $_trash_dir > $RM_ADVANCE/Content/tmp.txt && { 
            trap 'echo "\n\033[0;31mERROR\033[0m"' SIGINT # Get out with output 130 when used Ctrl+c.
            command rm ${options_rm[@]} $1
            local _check_error=$?
        
        }
        
     # Has it been deleted or not
        [ $_check_error -eq 0 ] && { 
         # option v
            _show_output_rm_Advance $_dir $(($_file-1))

         # deleted
            _message_output_rm_Advance deleted
            echo " \033[4;3;31m$1\033[0m is \033[3;1;36m($_type_)\033[0m ->\033[0m \033[3;32mSuccessfully deleted.\033[0m"
        
        } || {
            
            # not
            echo "Exit $_check_error"
            rsync -a --exclude=.my_cache $_trash_dir/"$(basename $1)" ${$(realpath $(basename $1))%/*}/. && command rm -rf $_trash_dir/"$(basename $1)" # return deleted dir
            [ $_check_error = 130 ] && {
                _add_option_rm_Advance $1 f "Manual"
                if [ $? -eq 1 ]; then 
                    return 1 
                else
                    _delete_rm_Advance $1
                    return 0
                fi
            } # exit 130
            echo "Add -f option to delete." # exit 1
            return 1
        }
    else # delete -> file
     # same name in trash and $1_here
        [ -f $_trash_file/"$(basename $1)" ] && {

            local _new_name_T="replace_at_$(date +%H-%M-%S_%d%m%y)"
            local _old_name_T=$(command tail -n 1 $_trash_file/"$(basename $1)")
            local _Eline_file_T=$(wc $_trash_file/"$(basename $1)" | awk '{print $1}')
            
            mv $_trash_file/"$(basename $1)" $_trash_file/"$(basename $1)".$_new_name_T && # rename  
            sed -i.temp -e ''$_Eline_file_T'd' $_trash_file/"$(basename $1)".$_new_name_T && # remove old path
            echo "$_old_name_T.$_new_name_T" >> $_trash_file/"$(basename $1)".$_new_name_T && # add new path
            command rm $_trash_file/"$(basename $1)".$_new_name_T.temp # delete redundant file
        }

     # deleting...
        rsync -avh --out-format="%n -> %l bytes" $1 $_trash_file > $RM_ADVANCE/Content/tmp.txt&& {
            trap 'echo "\n\033[0;31mERROR\033[0m"' SIGINT # Get out with exit 130 when used Ctrl+c.
            command rm ${options_rm[@]} $1
            local _check_error=$?
        }
         
     # Has it been deleted or not
        [ $_check_error -eq 0 ] && {
         # option -v
            _show_output_rm_Advance "none" "none"

         # deleted
            _message_output_rm_Advance deleted
            echo " \033[4;3;31m$1\033[0m is \033[3;1;32m($_type_)\033[0m ->\033[0m \033[3;32mSuccessfully deleted.\033[0m" 
        } || {

         # Not
            echo "Exit $_check_error"
            rsync -a $_trash_file/"$(basename $1)" $(realpath $1) && command rm -rf $_trash_file/"$(basename $1)" # return deleted file
            [ $_check_error = 130 ] && {
                _add_option_rm_Advance $1 f "Manual"
                if [ $? -eq 1 ]; then 
                    return 1 
                else
                    _delete_rm_Advance $1
                    return 0
                fi
            } # exit 130
            echo "Add -f option to delete." # exit 1
            return 1
        }
    fi
}

_main_rm_Advance(){
    if [ ! -d $1 -a ! -f $1 ]; then
        echo "rm-Advance: $(realpath $1) :No such file or directory."
        return 1
    elif _check_option_fn_rm u; then
        [ $? -eq 0 ] && echo "  [option: ${options_rm[@]}] :bad substitution."; return 1
    else 
        [ -d $1 ] && local _type_="Dir" || local _type_="File"
        if ! test -r $1; then
            echo "$_error_rm_ $1: Permission denied."
            return 1
fi
    fi
    
    if [ $(command ls -ld $1 | awk '{print $3}') = $(whoami) ]; then
        [ -d $1 ] && {
            _add_option_rm_Advance $1 r 
            if [ $? -eq 1 ]; then
                return 1
            fi
        }
        _delete_rm_Advance $1
    else
        printf "-> ${$(realpath $1)%/*}/\033[0;31m$1($(command ls -ld $1 | awk '{print $3}'))\033[0m\033[3;32m is not yours, to skip[y/n]:\033[0m"
        read -q tf
        echo 
        if [ $tf = "y" ]; then
            [ -d $1 ] && {
                _add_option_rm_Advance $1 r "Auto"
                if [ $? -eq 1 ]; then
                    return 1
                fi
            }
            sudo chmod g+w $1
            [ $? -eq 0 ] && _delete_rm_Advance $1 || return 1
        else
            return 1
        fi
    fi 

}
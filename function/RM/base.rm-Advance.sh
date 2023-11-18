local RM_ADVANCE=$HOME/.config/zsh/function/RM
source $RM_ADVANCE/main.fn.rm-Advance.sh 
source $RM_ADVANCE/op.rm-Advance.sh
source $RM_ADVANCE/undo.op.rm-Advance.sh
source $RM_ADVANCE/compdef.rm-Advance.sh #auto completion

function rm-Advance(){
    
    local dir_or_file=()
    local options_rm=()
    local dir_or_file_none=()
    local _trash_dir="$HOME/.Trash/dir"
    local _trash_file="$HOME/.Trash/file"
    local _error_rm_="rm-Advance:"
    
 # check .Trash
    if [ ! -d $HOME/.Trash/dir ]; then
        mkdir -p $HOME/.Trash/dir
    fi 
    if [ ! -d $HOME/.Trash/file ]; then
        mkdir -p $HOME/.Trash/file
    fi
    
 # filter from input
    for test in $@; do
        if [ -f $test -o -d $test ]; then
            [ "$test" = "/" ] && echo ". \033[4;31m $test :Permission denied.\033[0m" && continue
            
            _check_permission_denied $test
            [ $? -eq 0 ] && dir_or_file+=$test

        elif [ ${test[1]} = "-" ]; then
            [ ${#test[@]} -eq 1 ] && echo "$_error_rm_ error -> $item" && return 1
            for item in "$test"; do
                [ "$item" = "--undo" ] && continue
                echo "$item" | fold -w1 | while read -r char; do
                    [ "$char" = "v" ] && local option_v=TRUE && {
                        [ ${#test} -eq 2 ] && test=${test/-v/} || test=${test/v/}
                    } && continue
                    [[ $char = "-" ]] && continue
                    if [ $char = "u" -o $char = "W" -o $char = "d" -o $char = "P" -o $char = "i"  -o $char = "f" -o $char = "R" -o $char = "r" ]; then
                        continue
                    else
                        echo "$_error_rm_ No option -> $item"
                        return 1
                    fi
                done
            done
            options_rm+=$test

        else
            dir_or_file_none+=$(basename $test)
        fi
    done

 # option -u --undo
    _check_option_fn_rm u
    if [ $? -eq 0 ] ; then
        _option_undo_fn_rm
        [ $? -eq 0 ] && return 0 || return 1
    fi
    
    if [ ${#dir_or_file_none[@]} -ne 0 ]; then
        for i in $dir_or_file_none; do
            _default_home_rm_Advance "$_error_rm_ " $(pwd)/$i " :No such file or directory."
            echo
        done
        return 1
    fi

 # delete from dir_or_file
    if [ ${#dir_or_file[@]} -ne 0 ]; then
        for fd in $dir_or_file[@]; do 
            _main_rm_Advance $fd
        done
    elif [ ${#options_rm[@]} -ne 0 ]; then 
        echo "$_error_rm_ only option." && return 1
    fi
}

_check_permission_denied(){
    local _temp_=${$(realpath $1)#/Users/huynguyen/}
    for i in $(echo $_temp_ | tr / "\n"); do
        if [ $i = ".Trash" ]; then
            echo ". \033[4;31m $1 :Permission denied.\033[0m" && return 1
        fi
    done && return 0
}

_default_home_rm_Advance(){
    printf $1 && printf ${2/\/Users\/huynguyen/\~} && printf $3
}

_message_output_rm_Advance(){
    [ $1 = "error" ] && printf "\033[0;31m[Message]\033[0m"
    [ $1 = "deleted" ] && printf "\033[0;35m[Message]\033[0m"
    [ $1 = "recover" ] && printf "\033[0;30m[Message]\033[0m"
}

local _RM_ADVANCE=$HOME/.config/zsh/function/RM
source $_RM_ADVANCE/main.fn.rm-Advance.sh 
source $_RM_ADVANCE/add.op.rm-Advance.sh
source $_RM_ADVANCE/undo.op.rm-Advance.sh

function rm(){
    
    local dir_or_file=()
    local options_rm=()
    local dir_or_file_none=()
    local _trash_dir="$HOME/.Trash/dir"
    local _trash_file="$HOME/.Trash/file"
    local _error_rm_="\033[0;31mrm-Advance:\033[0m"
    
    # check from .Trash
    if [ ! -d $HOME/.Trash/dir ]; then
        mkdir -p $HOME/.Trash/dir
    fi 
    if [ ! -d $HOME/.Trash/file ]; then
        mkdir -p $HOME/.Trash/file
    fi
    
    # # "/" is important
    # for i in $@; do
    #     if [ $i = "/" ]; then 
    #         echo "\033[0;31m[Warning]\033[0m This is \033[0;33m$i\033[0m cannot be deleted \033[0;31m[Warning]\033[0m" 
    #         return 0
    #     fi
    # done

    for test in $@; do
        if [ -f $test -o -d $test ]; then
            [ "$test" = "/" ] && echo "$test: Permission denied." && continue
            _check_permission_denied $test
            [ $? -eq 0 ] && dir_or_file+=$test

        elif [ ${test[1]} = "-" ]; then
            
            for item in "$test"; do
                [ "$item" = "--undo" ] && continue
                echo "$item" | fold -w1 | while read -r char; do
                if [[ $char = "-" ]]; then
                    continue
                elif [ $char = "u" -o $char = "W" -o $char = "d" -o $char = "P" -o $char = "i" -o $char = "v" -o $char = "f" -o $char = "R" -o $char = "r" ]; then
                    continue
                else
                    command cat -vs $HOME/.config/zsh/function/RM/help.rm-Advance && return 130
                fi
                done
            done
            options_rm+=$test

        else
            dir_or_file_none+=$(basename $test)
        fi
    done

    if [ ${#dir_or_file[@]} -eq 1 ]; then # input = 1
        if [ -d $1 -o -f $1 ]; then
            _main_rm_Advance ${dir_or_file[@]}
            [ $? -eq 0 ] && return 0 || return 1
        elif [ ${#options_rm} -ne 0 ]; then
            echo "rm-Advance: $options_rm[@]" && 
            return 1
        else
            return 1
        fi
    else # greater than 1

        # filter from input
        
        # option -u --undo
        _check_option_fn_rm u
        if [ $? -eq 0 ] ; then
            _option_undo_fn_rm
            [ $? -eq 0 ] && return 0 || return 1
        fi

        # delete from input
        if [ ${#dir_or_file[@]} -ne 0 ]; then
            for fd in $dir_or_file[@]; do 
                _main_rm_Advance $fd
            done
        elif [ ${#dir_or_file_none[@]} -ne 0 ]; then
            echo "$_error_rm_: $(pwd)/${dir_or_file_none[@]} :No such file or directory."
            return 1
        elif [ ${#options_rm[@]} -ne 0 ]; then 
            echo "$_error_rm_: ??"
        fi
    fi
}

_check_permission_denied(){
    for i in $(echo $(realpath $1) | tr / "\n"); do
        if [ $i = ".Trash" ]; then
            echo "$1: Permission denied."
            return 1
        fi
    done && return 0
}
source $HOME/.config/zsh/function/RM/_my_rm.sh
function rm(){
    
    local dir_or_file=()
    local options_rm=()
    local dir_or_file_none=()
    local _trash_dir="$HOME/.Trash/dir"
    local _trash_file="$HOME/.Trash/file"
    
    # check from .Trash
    if [ ! -d $HOME/.Trash/dir ]; then
        mkdir -p $HOME/.Trash/dir
    fi 
    if [ ! -d $HOME/.Trash/file ]; then
        mkdir -p $HOME/.Trash/file
    fi
    
    # "/" is important
    for i in $@; do
        if [ $i = "/" ]; then 
            echo "\033[0;31m[Warning]\033[0m This is \033[0;33m/\033[0m cannot be deleted \033[0;31m[Warning]\033[0m" 
            return 0
        fi
    done
    
    if [ $# -eq 1 ]; then # input = 1
        if [ -d $1 -o -f $1 ]; then
            local _base_name=$(basename $1)
            _my_main_rm $1
            # [ $? -eq 0 ] && return 0 || return 1
        else
            [ ${$1[1]} = "-" ] && echo "rm-Advance: what??" || echo "rm-Advance: $(pwd)/$1 :No such file or directory."; return 1
        fi
    else # greater than 1

        # filter from input
        for test in $@; do
            if [ -f $test -o -d $test ]; then
                dir_or_file+=$test
            elif [ ${test[1]} = "-" ]; then
                options_rm+=$test
            else
                dir_or_file_none+=$test
            fi
        done
        
        # option -u --undo
        _check_option_fn_rm u
        if [ $? -eq 0 ] ; then
            _option_undo_fn_rm
            [ $? -eq 0 ] && return 0 || return 1
        fi

        # delete from input
        if [ ${#dir_or_file[@]} -ne 0 ]; then
            for fd in $dir_or_file[@]; do 
                local _base_name=$(basename $1)
                _my_main_rm $fd
            done
        elif [ ${#dir_or_file_none[@]} -ne 0 ]; then
            echo "rm-Advance: $(pwd)/${dir_or_file_none[@]} :No such file or directory."
            return 1
        fi
    fi
}
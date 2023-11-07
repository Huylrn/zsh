source $HOME/.config/zsh/function/RM/_my_rm.sh
rm(){
    # check .trash
    if [ ! -d $HOME/.trash/dir ]; then
        mkdir -p $HOME/.trash/dir
    fi 
    if [ ! -d $HOME/.trash/file ]; then
        mkdir -p $HOME/.trash/file
    fi
    
    for i in $@; do
        if [ $i = "/" ]; then 
            echo "\033[0;31m[Warning]\033[0m This is \033[0;33m/\033[0m cannot be deleted \033[0;31m[Warning]\033[0m" 
            return 0
        fi
    done
    
    if [ $# -eq 1 ]; then
        _my_rm $1
        return 0
    else
        # if the file or dir is "/", stop.
        
        dir_or_file=()
        options_rm=()
        for test in $@; do
            if [ -f $test -o -d $test ]; then
                dir_or_file+=$test
            else
                options_rm+=$test
            fi
        done

        if [ ${#dir_or_file[@]} -ne 0 ]; then
            for fd in $dir_or_file[@]; do 
                _my_rm $fd
            done
        fi

        # clean array 
        dir_or_file=()
        options_rm=()
    fi
}
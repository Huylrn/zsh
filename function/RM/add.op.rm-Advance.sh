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

_add_option_rm_Advance(){
    _check_option_fn_rm $2
    if [ $? -eq 1 ]; then
        if [ "$_auto_add_option_rm_Advance" = "TRUE" ]; then 
            [ -d $1 -o -f $1 ] && {
                if [ "$_message_confirm_add_option_rm_Advance" = "TRUE" ] || [ $3 = "Manual" ] ; then
                    printf "\033[1;32mDo you want to add -$2 option to continue deleting \033[4;3;31m$1\033[0m \033[3;1;36m($_type_)\033[0m \033[1;32m[y/n]:\033[0m"
                    read -q tf
                    echo 
                    if [ $tf = "y" ]; then
                        options_rm+="-$2"
                        return 0
                    else
                        return 1
                    fi
                else # TURN OFF REQUIRE CONFIRM

                    options_rm+="-$2"
                    return 0
                fi
            } || return 0
        else
            [ $2 = "r" ] && echo "$_error_rm_: $1 is directory."
            [ $2 = "f" ] && echo "$_error_rm_: $1 permission denied."
            return 1
        fi
    else
        return 0
    fi
}
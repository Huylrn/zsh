#compdef rm-Advance
_rm-Advance(){
    local ret
    declare -a args 
    args=(
        '(-P)-P[overwrite files before deleting them]'
        '(-f --force)'{-f,--force}'[ignore nonexistent files, never prompt]'
        '(-I --interactive)-i[prompt before every removal]'
        '(-r -R --recursive)'{-r,-R,--recursive}'[remove directories and their contents recursively]'
        '(-u --undo)-u[file recovery <-u> <file_name>]:*:Recover:->opsU'
        '(-v)-v[explain what is being done]'
        '(-f)-f[ignore nonexistent files, never prompt]'
        '(-W)-W[attempt to undelete named files]'
        '(-d)-d[remove directories as well]'
        '*:: :->file'
    )
    
    args=(${args:#*)--*\[*})
    #  _arguments -C -s -S $args && ret=0
     _arguments -s $args && ret=0
    case "$state" in
        (opsU)
            eval $(echo "_files -W ~/.Trash/dir && _files -W ~/.Trash/file ")
            ;;
        (file)
            (( CURRENT > 0 )) && line[CURRENT]=()
            line=( ${line//(#m)[\[\]()\\*?#<>~\^\|]/\\$MATCH} )
            _files -F line && ret=0
            ;;
    esac      
    return $ret
}

compdef _rm-Advance rm-Advance
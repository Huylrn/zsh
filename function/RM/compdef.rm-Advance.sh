#compdef rm-Advance
_rm-Advance(){
    _arguments -s \
        "-P[overwrite files before deleting them]" \
        "-R[remove directories and their contents recursively]" \
        "-r[remove directories and their contents recursively]" \
        "-W[attempt to undelete named files]" \
        "-d[remove directories as well]" \
        "-f[ignore nonexistent files, never prompt]" \
        "-i[prompt before every removal]" \
        "-v[explain what is being done]" \
        "--undo[file recovery < rm -u | --undo > <file_name>]:*:Recover:->opsU" \
        "-u[file recovery < rm -u | --undo > <file_name>]:*:Recover:->opsU" \
        "*: :_files"
    case "$state" in
        opsU)
            eval $(echo "_files -W ~/.Trash/dir && _files -W ~/.Trash/file")
            ;;
    esac      
}

compdef _rm-Advance rm-Advance
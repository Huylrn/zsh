function search() {
    local key
    case "$1" in
    --bing | -b)
        if [ -z $2 ]; then
            echo "Search for bing"
            vared -p ">" 2
        fi
        web-search bing "${@:2}"
        ;;

    --translate | -t)
        [ -z ${2#*=} ] && echo "translate ; -t input=[en,vn]" && return 1
        if [ ${2#*=} = "en" ]; then
            if [ -z $3 ]; then
                echo "en -> vn:"
                vared -p ">" 3
            fi
            key="Dịch sang tiếng Việt : $3"
        elif [ ${2#*=} = "vn" ]; then
            if [ -z $3 ]; then
                echo "-vn -> en:"
                vared -p ">" 3
            fi
            key="Translation to English: $3"
        else
            echo "translate ; -t input=[en,vn]" && return 1
        fi
        web-search bing $key
        ;;

    --youtube | -y)
        [ -z $2 ] && open https://www.youtube.com || web-search youtube ${@:2}
        ;;

    --github | -g)
        local path_gb branch
        path_gb=https://github.com/Huylrn
        branch=master
        [ $2 = "." ] && open "$path_gb/$(basename $(pwd))" && return
        [ -z ${2#*=} ] && open $path_gb/${2/=/} || open $path_gb/${2%=*}/tree/$branch/${2#*=}
        ;;

    --help | -h)
        cat ~/.config/zsh/Content/web_search
        echo
        ;;
    *)
        open -a Microsoft\ Edge\ Dev
        ;;
    esac
    return
}

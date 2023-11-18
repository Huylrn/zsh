function search (){
    case "$1" in 
        text|-b)
            if [ -z $2 ]; then
                echo "Search the web"
                vared -p ">" 2
            fi
            web_search bing "${@:2}" ;;
        
        translate|-t)
            if [[ $2 = "IN:en" ]]; then
                if [ -z $3 ]; then
                    echo "en -> vn:"
                    vared -p ">" 3
                fi
                web_search bing "Dịch sang tiếng Việt : $3"
            elif [[ $2 = "IN:vn" ]]; then
                if [ -z $3 ]; then 
                    echo "vn -> en:"
                    vared -p ">" 3
                fi
                web_search bing "Translation to English: $3"
            else
                echo "translate ; -t [en,vn]"
                return 1
            fi ;;
        
        youtube|-y)
            [ -z $2 ] && open https://www.youtube.com || open "https://www.youtube.com/results?search_query=$2" ;;
        
        github|-g)
            local path_gb=https://github.com/Huylrn
            case "$2" in
                1) 
                    open $path_gb/learn ;;

                2)
                    open $path_gb/docs ;;

                3) 
                    open $path_gb/temp ;;

                4) 
                    open $path_gb/zsh ;;

                5) 
                    open $path_gb/macos ;;
                *)
                    open $path_gb/$2 ;;
            esac ;;

        --help|-h)
            cat ~/.config/zsh/Content/web_search
            echo ;;
        *)
            open -a Microsoft\ Edge\ Dev ;;
    esac
}
_search() 
{
    local cur prev words cur_upper
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    words=""
    case "${prev}" in
        search)
            words="github text translate youtube"
            ;;
        github|-g)
            words="Docs/ MacOS/ Learn/ zsh/ TEMP/"
            ;;
        translate|-t)
            words="IN:en IN:vn"
            ;;
        -h|--help)
            return
            ;;

    esac 
    COMPREPLY=($(compgen -W "$words" -- ${cur}))

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=($(compgen -W "-g -t -b -y --help" -- ${cur}))
        return 0
    fi
}
complete -F _search search

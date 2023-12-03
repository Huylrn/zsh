web-search() {
    local _base _bing _google _duckduckgo _yandex
    case "$1" in
    yandex)
        _yandex='https://yandex.com/search?text='${@:2}'&showconv=0' && open $_yandex
        ;;
    duckduckgo)
        _duckduckgo='https://duckduckgo.com/?q='${@:2}'&t=h_&ia=web' && open $_duckduckgo
        ;;
    *)
        _base='https://'$1'.com/search?q='${@:2}'&showconv=0' && open $_base
        ;;
    esac
}

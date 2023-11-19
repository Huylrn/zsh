web-search(){
    local _bing _google
    _base='https://www.'$1'.com/search?q='${@:2}'&showconv=0'
    # _bing='https://www.bing.com/search?q='$2'&showconv=0'
    # _google='https://www.google.com/search?q=chao&showconv=0'
    open $_base
}

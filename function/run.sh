function run(){
    local tail temp here
    tail="${1#*.}"
    case "$tail" in 
        sh|shell|zsh|bash|py)
            [ ! $(test -x $1) ] && chmod u+x $1 && ./$1
            ;;
        cpp|c)
            here=$(pwd)
            cd "${$(realpath $1)%/*}"
            [ $tail = "cpp" ] && g++ $1 -o temp || gcc $1 -o temp
            [ $? -eq 1 ] && echo "\033[1;7;31m $(basename $1) \033[0m" && return 1 || ./temp && command rm temp
            cd $here
            ;;
    esac
    echo "\033[5;32m...\033[0m"
    echo "\033[1;7;36m $(basename $1) \033[0m"
}
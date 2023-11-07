b '$1'(){ 
    tmp=${1##*.}
    if [ -n $tmp ]; then
        bat $1
    else
        bat -l $tmp $1
    fi
}

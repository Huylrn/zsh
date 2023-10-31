 rm '$1'(){
    if [ $1 = -r ]; then
        command rm -r $2
    fi
}
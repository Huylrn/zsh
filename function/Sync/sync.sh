check_to_exist(){   
    [ -d $1 ] && return $TRUE || return $FALSE
}
# check_to_exist(){   
#     # $1 - It the path to check
#     # $2 - It the command
#     if [ ! -d $1 ]; then
#         echo "\033[1;31m» $1\033[0m: Directory or file not exist."
#         # mkdir -pv $1/image $1/Gif $1/video
#         return 1
#     else
#         return 0
#     fi 
# }
function My_sync_run(){
    open -a Google\ Drive
    while read file; do
        if [ -f $file ]; then
            tmp=${file##*.}
            
            if [[ $tmp = mov ]] || [[ $tmp = mp4 ]]; then
                mv -nv $ltp/"$file" $ltp/video
            
            elif [[ $tmp = png ]] || [[ $tmp = jpeg ]]; then
                mv -nv $ltp/"$file" $ltp/image
            
            elif [[ $tmp = gif ]]; then   
                mv -nv $ltp/"$file" $ltp/Gif
                
            fi
        fi        
    done <<< "$(command ls $ltp)"

    if [ $? -eq 0 ]; then
        echo "\033[0;32m ~ ~ rsync running...\033[0m"
        rsync -a --progress $ltp/* $path_library 
        rsync -a --progress $path_library $Drive_huuy
    else    
        echo "\n\033[0;31m [Erorr]\033[0m Something went wrong, you can try run command again."
        return 0
    fi
}

sync_libary(){
    while read file; do
        if [ -f $file ]; then
            tmp=${file##*.}
            
            if [[ $tmp = mov ]] || [[ $tmp = mp4 ]]; then
                mv -nv $ltp/"$file" $ltp/video
            
            elif [[ $tmp = png ]] || [[ $tmp = jpeg ]]; then
                mv -nv $ltp/"$file" $ltp/image
            
            elif [[ $tmp = gif ]]; then   
                mv -nv $ltp/"$file" $ltp/Gif
                
            fi
        fi        
    done <<< "$(command ls $ltp)"
}
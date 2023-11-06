function My_sync_run(){
    path_library="/Users/$(whoami)/My_Sync/library"
    open -a Google\ Drive
    ltp="/Users/$(whoami)/library_temp"

    if [ ! -d $path_library ]; then
        echo "\033[1;31m» My_Sync/library\033[0m: Directory not exist."
        mkdir -pv $path_library/image $path_library/Gif $path_library/video
        echo "\033[1;32mMy_Sync/library created.\033[0m"
    fi 

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
        rsync -av --exclude=.DS_Store $ltp/* $path_library 
        rsync -a --exclude=.DS_Store $path_library /Users/huynguyen/Library/CloudStorage/GoogleDrive-huuynguyendd@gmail.com/My\ Drive
    else    
        echo "\n\033[0;31m [Erorr]\033[0m Something went wrong, you can try run command again."
        return 0
    fi
}
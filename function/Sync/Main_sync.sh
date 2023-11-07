source /Users/$(whoami)/.config/zsh/function/Sync/path_sync.sh
source /Users/$(whoami)/.config/zsh/function/Sync/sync.sh
M_run_sync_now(){
    check_to_exist $path_library
    if [ $? -eq 1 ]; then
        echo "\033[1;31m» $path_library\033[0m: Directory or file not exist."
        echo "\033[0;32m$(mkdir -pv $path_library/image $path_library/video $path_library/Gif)created.\033[0m"
    fi
}
# rsync -a --progress --exclude=.DS_Store
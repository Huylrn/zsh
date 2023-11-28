function clean(){
    case "$1" in
        nvim)
            clean_nvim
        ;;
    esac
}

clean_nvim(){
    command rm -rf ~/.cache/nvim
    command rm -rf ~/.local/share/nvim
    command rm -rf ~/.local/state/nvim
}

function clean_library(){
    local resource resource_1 resource_2 ITEM mylibrary_path
    resource_1=~/library_temp
    resource=($resource_1)
    ITEM=(png mov mp4 jpeg gif)
    mylibrary_path=~/mylibrary

    [ ! -d ~/mylibrary/Gif ] && mkdir ~/mylibrary/Gif
    [ ! -d ~/mylibrary/Image ] && mkdir ~/mylibrary/Image
    [ ! -d ~/mylibrary/Video ] && mkdir ~/mylibrary/Video
    [ ! -d ~/library_temp/BigData ] && mkdir ~/library_temp/BigData

    for _path in $resource; do
        for item in $ITEM; do
            while read line;do
                    [ -z $line ] && continue
                    if [ $(wc -c $line | awk '{print $1}') -gt 1000000000 ]; then
                        [ ! -f "$resource_1/BigData/$(basename $line)" ] && command mv "$line" $resource_1/BigData
                        continue
                    else
                        case "$item" in
                            mov|mp4)
                                command mv "$line" "$mylibrary_path/Video/" ;;
                            png|jpeg)
                                command mv "$line" "$mylibrary_path/Image/" ;;
                            gif)
                                command mv "$line" "$mylibrary_path/Gif/" ;;
                        esac
                    fi
            done <<< "$(noglob find $_path -name *".$item")"
        done
    done
}
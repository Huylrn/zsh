function clean_library(){
    local resource resource_1 resource_2 ITEM mylibrary_path
    resource_1=~/library_temp
    resource=($resource_1)
    ITEM=(png mov mp4 jpeg gif)
    mylibrary_path=~/mylibrary

    [ ! -d ~/mylibrary/Gif ] && mkdir ~/mylibrary/Gif
    [ ! -d ~/mylibrary/Image ] && mkdir ~/mylibrary/Image
    [ ! -d ~/mylibrary/Video ] && mkdir ~/mylibrary/Video

    for _path in $resource; do
        for item in $ITEM; do
            while read line;do
                    [ -z $line ] && continue
                    case "$item" in
                        mov|mp4)
                            command mv "$line" "$mylibrary_path/Video/"
                        ;;
                        png|jpeg)
                            command mv "$line" "$mylibrary_path/Image/"
                        ;;
                        gif)
                            command mv "$line" "$mylibrary_path/Gif/"
                        ;;
                    esac
            done <<< "$(noglob find $_path -name *".$item")"

        done
    done
}
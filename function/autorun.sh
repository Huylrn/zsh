autorun(){


    local BASE_TIME DAY_BASE_TIME MONTH_BASE_TIME YEAR_BASE_TIME 
    local TEMP_TIME DAY_TEMP_TIME MONTH_TEMP_TIME YEAR_TEMP_TIME
    TEMP_TIME=$(date +"%d %m %Y") 
    BASE_TIME="25 11 2023"
    BASE_TIME="$TEMP_TIME"
    # 31d: 1,3,5,7,8,10,12
    # 30d: 4,6,9,11
    # 28d: 2(no)
    # 29d: 2(yes)
    # yes: year%4==0 && year%100!=0
    DAY_BASE_TIME=$(echo $BASE_TIME | awk '{print $1}')
    MONTH_BASE_TIME=$(echo $BASE_TIME | awk '{print $2}')
    YEAR_BASE_TIME=$(echo $BASE_TIME | awk '{print $3}')
    
    DAY_TEMP_TIME=$(echo $TEMP_TIME | awk '{print $1}')
    MONTH_TEMP_TIME=$(echo $TEMP_TIME | awk '{print $2}')
    YEAR_TEMP_TIME=$(echo $TEMP_TIME | awk '{print $3}')

    case "$MONTH_BASE_TIME" in 
        01|03|05|07|08|10|12)
        ;;
        04|06|09|11)
        ;;
        02)
            if [ $(("$YEAR_BASE_TIME"%4)) -eq 0 ] && [ $(($YEAR_BASE_TIME%100)) -ne 0 ]; then
                echo YES
            fi
        ;;
    esac
    if [ $(($YEAR_BASE_TIME%4)) -eq 0 ] && [ $(($YEAR_BASE_TIME%100)) -ne 0 ]; then
        echo YES
    fi
    echo $DAY_TEMP_TIME
    echo $MONTH_TEMP_TIME
    echo $YEAR_TEMP_TIME
    
    echo $DAY_BASE_TIME
    echo $MONTH_BASE_TIME
    echo $YEAR_BASE_TIME
}

autorun
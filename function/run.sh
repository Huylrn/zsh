function run(){
    if [[ ${1#*.} = sh ]] || [[ ${1#*.} = shell ]] || [[ ${1#*.} = zsh ]]; then
        ./$1
        echo "Exit: 0"
        return 0
    fi
# Run c++
    if [ ${1#*.} = cpp  ]; then
        g++ $1 -o df
        
        # stop when error
        if [ ! -f $(pwd)/df ]; then
            return 0
        fi
        
        ./df
        echo "Exit: 0"
        rm df 
        return 0
    fi

# Run c
    if [ ${1#*.} = c  ]; then
        gcc $1 -o df
        
        # stop when error
        if [ ! -f $(pwd)/df ]; then
            return 0
        fi
        ./df
        echo "Exit: 0"
        rm df
        return 0
    fi

# Run python
    if [ ${1#*.} = py  ]; then
        python3 $1
        echo "Exit: 0"
        return 0
    fi
}

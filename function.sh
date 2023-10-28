
function run `$1` `$2`(){
    if [[ ${1#*.} = sh ]] || [[ ${1#*.} = shell ]]; then
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
#---------------------------------------------------------------

#---------------------------------------------------------------
#---------------------------------------------------------------
function df(){
  ./df
  rm df
}
#---------------------------------------------------------------
#update MacOS-github
function update-MacOS-github(){
    #Vim
    cp -R .vscodevimrc .vimrc ~/WorkSpace/MacOS/Vim
    sudo cp -R .vim ~/WorkSpace/MacOS/Vim

    #Vscode
    cp ~/Library/Application\ Support/Code/User/settings.json keybindings.json ~/WorkSpace/MacOS/VsCode

    #Config
    sudo cp -R .config ~/WorkSpace/MacOS/Config
    sudo cp -R .oh-my-zsh/custom ~/WorkSpace/MacOS/Config/.oh-my-zsh
    cp -R .zshrc  ~/WorkSpace/MacOS/Config

    #git-cmd
    cd ~/WorkSpace/MacOS
    git diff
    git add .
    git commit -am "$(date)"
    git push

}
#---------------------------------------------------------------
function git-$1(){
    if [ $1 = i ]; then 
        touch -c .gitignore
        echo ".DS_store" >> .gitignore
        git init
        git status
        return 0
    fi

    if [ $1 = f ]; then
        git diff
        read "?Label:" i

        if [ $i = q ]; then
            return 0
        fi
        git commit -am "$i"
        git push
        return 0
    fi

    if  [ -z $1 ]; then
        echo "No options"
        return 0
    fi

    exit 0
}
#---------------------------------------------------------------
function search '$1' '$2' '$3'(){

# default    
    if [ -z $1 ]; then 
        open -a Microsoft\ Edge\ Dev
        return 0
    fi 

# -b
    if [ $1 = -b ]; then
        if [ -z $2 ]; then
            echo "Search the web"
            read "?>" 2
        fi
        web_search bing "$2"
        return 0
    fi

# -g
    if [ $1 = -g ]; then 
        case "$2" in
            "1") 
                open https://github.com/Huylrn/learn
                return 0
            ;;

            "2")
                open https://github.com/Huylrn/docs
                return 0 
            ;;

            "3") 
                open https://github.com/Huylrn/temp
                return 0
            ;;

            "4") 
                open https://github.com/Huylrn/zsh
                return 0
            ;;

            "5") 
                open https://github.com/Huylrn/macos
                return 0
            ;;

        esac
            open https://github.com/Huylrn/"$2"
        return 0
    fi


# -t
    if [ $1 = -t ]; then
        if [ $2 = en ]; then
            if [ -z $3 ]; then
                echo "Dịch sang tiếng Việt:"
                read "?>" 3
            fi
            web_search bing "Dịch sang tiếng Việt : $3"
            return 0
        fi
        if [ $2 = vn ]; then
            if [ -z $3 ]; then 
                echo "Translation to English:"
                read "?>" 3
            fi
            web_search bing "Translation to English: $3"
            return 0
        fi

        return 0
    fi

# -y
    if [ $1 = -y ]; then
        if [ -z $2 ]; then
            open https://www.youtube.com
            return 0
        else
            open "https://www.youtube.com/results?search_query=$2"
            return 0
        fi

    fi 


# -h
    if [ $1 = -h ]; then
        cat /Users/huuynguyen/.config/zsh/Content/web_search
        echo ""
        
        return 0
    fi
    
}


#---------------------------------------------------------------
#---------------------------------------------------------------
#---------------------------------------------------------------

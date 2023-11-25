#update MacOS-github
function update-MacOS-github(){
    [ ! -d ~/WorkSpace/MacOS ] && return 1
    rsync -a ~/Library/Application\ Support/Code/User/settings.json ~/WorkSpace/MacOS/Config/VsCode/settings.json
    rsync -a ~/Library/Application\ Support/Code/User/keybindings.json ~/WorkSpace/MacOS/Config/VsCode/keybindings.json
    rsync -a ~/.vscodevimrc ~/WorkSpace/MacOS/Config/VsCode/.vscodevimrc
    rsync -a ~/.zshrc ~/WorkSpace/MacOS/Config/zsh/.zshrc

    #Vim
    # rsync -a --exclude=.git .vim ~/WorkSpace/MacOS/Vim~/WorkSpace/MacOS/VsCode

    #Config
    

    cd ~/WorkSpace/MacOS
    git add .
    git commit -m "$(date)"
    git push
}
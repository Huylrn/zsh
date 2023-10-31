#update MacOS-github
function update-MacOS-github(){
    #Vim
    # cd ~/WorkSpace/MacOS/Vim
    # sudo command rm -rf .vscodevimrc .vimrc
    cd ~
    cp -R .vscodevimrc .vimrc ~/WorkSpace/MacOS/Vim
    cp -R .vim ~/WorkSpace/MacOS/Vim~/WorkSpace/MacOS/VsCode

    #Vscode
    # cd ~/WorkSpace/MacOS/VsCode
    # sudo command rm -rf settings.json keybindings.json
    
    cp ~/Library/Application\ Support/Code/User/settings.json keybindings.json 

    #Config
    # cd ~/WorkSpace/MacOS/Config
    # sudo command rm -rf .config .zshrc
    
    cp -R .config .zshrc ~/WorkSpace/MacOS/Config

    # sudo command rm -rf .oh-my-zsh/custom
    
    cp -R .oh-my-zsh/custom ~/WorkSpace/MacOS/Config/.oh-my-zsh

    #git-cmd
    cd ~/WorkSpace/MacOS
    git diff
    git add .
    git commit -am "$(date)"
    git push
}

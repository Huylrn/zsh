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

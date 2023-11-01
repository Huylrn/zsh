#update MacOS-github
function update-MacOS-github(){
    # cd ~/WorkSpace/MacOS/Vim
    # sudo command rm -rf .vscodevimrc .vimrc
    #Vscode
    cd ~/Library/Application\ Support/Code/User
    rsync -a --exclude=.git settings.json keybindings.json ~/WorkSpace/MacOS/VsCode

    cd ~
    #Vim
    rsync -a .vscodevimrc .vimrc ~/WorkSpace/MacOS/Vim
    rsync -a --exclude=.git .vim ~/WorkSpace/MacOS/Vim~/WorkSpace/MacOS/VsCode

    # cd ~/WorkSpace/MacOS/VsCode
    # sudo command rm -rf settings.json keybindings.json

    #Config
    # cd ~/WorkSpace/MacOS/Config
    # sudo command rm -rf .config .zshrc
    
    rsync -a --exclude=.git .config .zshrc ~/WorkSpace/MacOS/Config

    # sudo command rm -rf .oh-my-zsh/custom
    
    rsync -a --exclude=.git .oh-my-zsh/custom ~/WorkSpace/MacOS/Config/.oh-my-zsh

    #git-cmd
    cd ~/WorkSpace/MacOS
    git diff
    git add .
    git commit -m "$(date)"
    git push
}

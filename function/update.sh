#update MacOS-github
function update-MacOS-github() {
  [ ! -d ~/WorkSpace/MacOS ] && return 1
  rsync -a ~/Library/Application\ Support/Code/User/settings.json ~/WorkSpace/MacOS/Config/VsCode/settings.json
  rsync -a ~/Library/Application\ Support/Code/User/keybindings.json ~/WorkSpace/MacOS/Config/VsCode/keybindings.json
  rsync -a ~/.vscode/extensions/rocketseat.theme-omni-1.0.12 ~/WorkSpace/MacOS/Theme/vscode/
  rsync -a ~/.config/vscode/.vscodevimrc ~/WorkSpace/MacOS/Config/VsCode/.vscodevimrc
  rsync -a ~/.config/vscode/.prettierrc ~/WorkSpace/MacOS/Config/VsCode/.prettierrc
  rsync -a ~/.zshrc ~/WorkSpace/MacOS/Config/zsh/.zshrc

  #Vim
  # rsync -a --exclude=.git .vim ~/WorkSpace/MacOS/Vim~/WorkSpace/MacOS/VsCode

  #Config

  cd ~/WorkSpace/MacOS
  git add .
  git commit -m "$(date)"
  git push
}

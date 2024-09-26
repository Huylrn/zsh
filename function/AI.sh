function ai() {
  case "$1" in
  --history | -h)
    cat /Users/luna/.config/zsh/Content/ai
    ;;
  *)
    if [ -z $1 ]; then
      echo "Ask me?"
      vared -p ">" 1
    fi
    open $'https://www.bing.com/chat\?sendquery\=1\&q\='$@'&form\=HECODX'
    echo $1 >>/Users/luna/.config/zsh/Content/ai

    ;;
  esac
}

ts(){
    # create the session if it doesn't already exist
  tmux has-session -t $1 2>/dev/null
  if [[ $? != 0 ]]; then
    tmux new-session -d -s $1
  fi

  # if a tmux session is already attached, switch to the new session; otherwise, attach the new
  # session
  if { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
    tmux switch -t $1
  else
    tmux attach -t $1
  fi
}

lts(){
    reply=("test1","test2","test3")

}

compctl -K lst ts
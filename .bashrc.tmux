#!/bin/bash

AUTOJUMP="/usr/share/autojump/autojump.sh"
if [ ! -e $AUTOJUMP ]; then
  echo 'autojump is not installed.'
  return 1
fi

. $AUTOJUMP

check-on-tmux() {
  if [ $SHLVL -eq 1 ]; then
    echo 'tmux is not started.' 1>&2
    return 1
  fi
  return 0
}

split-pane-4() {
  check-on-tmux || return 1
  tmux new-window
  tmux split-pane -v
  tmux split-pane -h
  tmux select-pane -U
  tmux split-pane -h
  tmux select-pane -L
}

start-git-pane(){
  check-on-tmux || return 1
  echo $1
  if [ $(j $1 1>&2; git status > /dev/null; echo $?) -ne 0 ]; then
          return 128
  fi
  tmux send-keys -t 1 "j $1 && gwlga" C-m
  tmux send-keys -t 2 "j $1 " C-m
  tmux send-keys -t 3 "j $1 && gwstat" C-m
  tmux send-keys -t 0 "j $1 && gwbranch" C-m
}

tmux-git(){
  check-on-tmux || return 1
  split-pane-4
  start-git-pane $1
}
stop-git-pane(){
  check-on-tmux || return 1
  tmux send-keys -t 1 C-c
  tmux send-keys -t 2 C-c
  tmux send-keys -t 3 C-c
  tmux send-keys -t 0 C-c
}


#!/bin/bash

tmux ls > /dev/null 2>&1
if [ $? -eq 1 ]; then
    tmux
else
    tmux ls
fi

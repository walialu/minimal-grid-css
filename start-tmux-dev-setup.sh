#!/usr/bin/env bash

MAIN_WINDOW_NAME="Code"
PROJECT_DEFAULT_CMD="nvim"
PROJECT_ROOT=""

get_source_directory_of_script_self() {
    local source
    local dir;
    source="${BASH_SOURCE[0]}"
    while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
        dir="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source" # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    dir="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
    echo "$dir"
}

PROJECT_ROOT="$(get_source_directory_of_script_self)"

main() {
        # Default stuff, this is basically the same for every project
        tmux new-window -n "$MAIN_WINDOW_NAME"
        tmux send-keys "cd $PROJECT_ROOT" C-m
        if [[ "$PROJECT_DEFAULT_CMD" != "" ]]; then
                tmux send-keys "$PROJECT_DEFAULT_CMD" C-m
        fi
        custom
}

# This functions is NOT THE SAME for every project
# Here we go with custom commands and splits
custom() {

        tmux new-window -n "Builders"
        tmux send-keys "cd $PROJECT_ROOT" C-m
        tmux send-keys "npm run serve" C-m
        tmux split-window -v -p 67
        tmux send-keys "cd $PROJECT_ROOT" C-m
        tmux send-keys "npm run watch-js" C-m
        tmux split-window -v -p 50
        tmux send-keys "cd $PROJECT_ROOT" C-m
        tmux send-keys "npm run watch-sass" C-m
	tmux previous-window
}

main


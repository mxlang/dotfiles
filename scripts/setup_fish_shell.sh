#! /bin/bash

set -e

if ! command -v brew >/dev/null 2>&1; then
    brew install fish
fi

FISH_PATH="$(command -v fish)"

if [[ -n "$FISH_PATH" ]] && ! grep -qx "$FISH_PATH" /etc/shells; then
    echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
    chsh -s "$(command -v fish)"
fi

#! /bin/bash

set -e

brew install fish

FISH_PATH="$(command -v fish)"

if [[ -n "$FISH_PATH" ]] && ! grep -qx "$FISH_PATH" /etc/shells; then
    echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
fi

chsh -s "$(command -v fish)"

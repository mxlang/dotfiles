#! /bin/bash

set -e

FILE="/etc/pam.d/sudo_local"
LINE="auth sufficient pam_tid.so"

sudo cp /etc/pam.d/sudo_local.template "$FILE"

if ! grep -Fxq "$LINE" "$FILE"; then
    echo "$LINE" | sudo tee -a "$FILE" > /dev/null
fi

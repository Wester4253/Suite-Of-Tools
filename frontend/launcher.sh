#!/bin/bash

# Detect OS
OS_TYPE=$(uname -s)

clear
echo "Suite Of Tools – Noa Butterfield"
echo

# Display OS info
if [ "$OS_TYPE" = "Darwin" ]; then
    echo "Detected OS: macOS"
elif [ "$OS_TYPE" = "Linux" ]; then
    echo "Detected OS: Linux"
else
    echo "Detected OS: $OS_TYPE (may not be fully supported)"
fi

echo
echo "Select a tool:"
echo "1. WiFi Network Diagnostics"
echo

read -p "Enter choice: " CHOICE </dev/tty

case "$CHOICE" in
    1)
        echo "Launching WiFi Diagnostics..."
        bash <(curl -fsSL https://raw.githubusercontent.com/Wester4253/Suite-Of-Tools/refs/heads/main/SCRIPTS/wifi/wifitester.sh)
        ;;
    *)
        echo "Invalid choice."
        ;;
esac

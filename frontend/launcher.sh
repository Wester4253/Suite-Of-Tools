#!/bin/bash

clear
echo "Suite Of Tools – Noa Butterfield"
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

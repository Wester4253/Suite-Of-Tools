#!/bin/bash

# Detect OS
OS_TYPE=$(uname -s)

# Color functions (compatible with Linux and macOS)
cyan() { echo -e "\033[1;36m$1\033[0m"; }
green() { echo -e "\033[1;32m$1\033[0m"; }
yellow() { echo -e "\033[1;33m$1\033[0m"; }
blue() { echo -e "\033[1;34m$1\033[0m"; }
magenta() { echo -e "\033[1;35m$1\033[0m"; }
bold() { echo -e "\033[1m$1\033[0m"; }

clear

# ASCII Art Banner

echo ""
magenta "             Made with ❤️  by Noa Butterfield"
echo ""
echo "════════════════════════════════════════════════════════"

# Display OS info
if [ "$OS_TYPE" = "Darwin" ]; then
    green "✓ Detected OS: macOS"
elif [ "$OS_TYPE" = "Linux" ]; then
    green "✓ Detected OS: Linux"
else
    yellow "⚠ Detected OS: $OS_TYPE (may not be fully supported)"
fi

echo "════════════════════════════════════════════════════════"
echo ""
bold "Select a tool:"
echo ""
blue "  [1] 📡 WiFi Network Diagnostics"
echo ""
echo "════════════════════════════════════════════════════════"
echo ""

read -p "Enter choice: " CHOICE </dev/tty

case "$CHOICE" in
    1)
        echo ""
        green "🚀 Launching WiFi Diagnostics..."
        echo ""
        bash <(curl -fsSL https://raw.githubusercontent.com/Wester4253/Suite-Of-Tools/main/SCRIPTS/wifi/LINUX/wifitester.sh)
        ;;
    *)
        echo ""
        yellow "❌ Invalid choice."
        ;;
esac


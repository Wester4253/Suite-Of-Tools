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

# ASCII Art Banner based on OS
if [ "$OS_TYPE" = "Darwin" ]; then
    # macOS Apple Logo
    cat << "EOF"
                         .8 
                      .888
                    .8888'
                   .8888'
                   888'
                   8'
      .88888888888. .88888888888.
   .8888888888888888888888888888888.
 .8888888888888888888888888888888888.
.&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
`%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
 `00000000000000000000000000000000000'
  `000000000000000000000000000000000'
   `0000000000000000000000000000000'
     `###########################'
jgs    `#######################'
         `#########''########'
           `""""""'  `"""""'
EOF
else
    # Linux Tux Logo
    cat << "EOF"
          _nnnn_                      
        dGGGGMMb     ,"""""""""""""".
       @p~qp~~qMb    | Linux Rules! |
       M|@||@) M|   _;..............'
       @,----.JM| -'
      JS^\__/  qKL
     dZP        qKRb
    dZP          qKKb
   fZP            SMMb
   HZM            MMMM
   FqM            MMMM
 __| ".        |\dS"qML
 |    `.       | `' \Zq
_)      \.___.,|     .'
\____   )MMMMMM|   .'
     `-'       `--' 
EOF
fi

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
        bash <(curl -fsSL https://raw.githubusercontent.com/Wester4253/Suite-Of-Tools/main/SCRIPTS/networking_tester/LINUX/wifitester.sh)
        ;;
    *)
        echo ""
        yellow "❌ Invalid choice."
        ;;
esac

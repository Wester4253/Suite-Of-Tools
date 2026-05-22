#!/bin/bash

# Detect OS
OS_TYPE=$(uname -s)

# Settings
DEFAULT_ASCII_URL="https://wstr.codes/ascii.txt"
BANNER_MODE="default"
CUSTOM_ASCII_URL=""
COLOR_MODE="rgb"

# Color functions (compatible with Linux and macOS)
cyan() { echo -e "\033[1;36m$1\033[0m"; }
green() { echo -e "\033[1;32m$1\033[0m"; }
yellow() { echo -e "\033[1;33m$1\033[0m"; }
blue() { echo -e "\033[1;34m$1\033[0m"; }
magenta() { echo -e "\033[1;35m$1\033[0m"; }
bold() { echo -e "\033[1m$1\033[0m"; }

colorize_banner() {
    local index=0
    local line
    local color
    local -a colors

    while IFS= read -r line || [ -n "$line" ]; do
        case "$COLOR_MODE" in
            rgb)
                colors=("\033[1;31m" "\033[1;32m" "\033[1;34m")
                color="${colors[$((index % ${#colors[@]}))]}"
                ;;
            purple-black)
                color="\033[35;40m"
                ;;
            other)
                colors=("\033[1;36m" "\033[1;33m" "\033[1;32m" "\033[1;35m")
                color="${colors[$((index % ${#colors[@]}))]}"
                ;;
            *)
                color=""
                ;;
        esac

        if [ -n "$color" ]; then
            printf "%b%s%b\n" "$color" "$line" "\033[0m"
        else
            printf "%s\n" "$line"
        fi
        index=$((index + 1))
    done
}

print_os_banner() {
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
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
}

print_default_banner() {
    if ! curl -fsSL "$DEFAULT_ASCII_URL"; then
        print_os_banner
    fi
}

print_custom_banner() {
    if [ -n "$CUSTOM_ASCII_URL" ]; then
        if ! curl -fsSL "$CUSTOM_ASCII_URL"; then
            print_default_banner
        fi
    else
        print_default_banner
    fi
}

render_banner() {
    clear
    case "$BANNER_MODE" in
        default) print_default_banner | colorize_banner ;;
        os) print_os_banner | colorize_banner ;;
        custom) print_custom_banner | colorize_banner ;;
        *) print_default_banner | colorize_banner ;;
    esac
}

ascii_settings_menu() {
    clear
    bold "ASCII banner"
    echo ""
    blue "  [1] Default (wstr.codes/ascii.txt)"
    blue "  [2] OS-based"
    blue "  [3] Custom from URL"
    blue "  [4] Back"
    echo ""
    read -p "Enter choice: " SETTING_CHOICE </dev/tty

    case "$SETTING_CHOICE" in
        1)
            BANNER_MODE="default"
            CUSTOM_ASCII_URL=""
            ;;
        2)
            BANNER_MODE="os"
            CUSTOM_ASCII_URL=""
            ;;
        3)
            read -p "Enter raw ASCII URL: " CUSTOM_ASCII_URL </dev/tty
            if [ -n "$CUSTOM_ASCII_URL" ]; then
                BANNER_MODE="custom"
            else
                BANNER_MODE="default"
            fi
            ;;
        4) return ;;
        *) yellow "❌ Invalid choice." ;;
    esac

    echo ""
    read -p "Press Enter to return..." </dev/tty
}

color_settings_menu() {
    clear
    bold "Banner colors"
    echo ""
    blue "  [a] RGB"
    blue "  [b] Purple/Black"
    blue "  [c] Other colors"
    blue "  [d] Back"
    echo ""
    read -p "Enter choice: " COLOR_CHOICE </dev/tty

    case "$COLOR_CHOICE" in
        a|A) COLOR_MODE="rgb" ;;
        b|B) COLOR_MODE="purple-black" ;;
        c|C) COLOR_MODE="other" ;;
        d|D) return ;;
        *) yellow "❌ Invalid choice." ;;
    esac

    echo ""
    read -p "Press Enter to return..." </dev/tty
}

settings_menu() {
    while true; do
        clear
        bold "Settings"
        echo ""
        blue "  [1] ASCII banner source"
        blue "  [2] Banner colors"
        blue "  [3] Back"
        echo ""
        read -p "Enter choice: " SETTING_CHOICE </dev/tty

        case "$SETTING_CHOICE" in
            1) ascii_settings_menu ;;
            2) color_settings_menu ;;
            3) return ;;
            *)
                echo ""
                yellow "❌ Invalid choice."
                echo ""
                read -p "Press Enter to continue..." </dev/tty
                ;;
        esac
    done
}

while true; do
    render_banner
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
    bold "Select an option:"
    echo ""
    blue "  [1] 📡 WiFi Network Diagnostics"
    blue "  [2] ⚙️ Settings"
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
            break
            ;;
        2) settings_menu ;;
        *)
            echo ""
            yellow "❌ Invalid choice."
            echo ""
            read -p "Press Enter to continue..." </dev/tty
            ;;
    esac
done

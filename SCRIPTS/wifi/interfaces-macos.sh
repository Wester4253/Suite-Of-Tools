#!/bin/bash

select_interface() {
    # Get list of interfaces from ifconfig
    IFACES=()
    while IFS= read -r iface; do
        # Skip empty lines
        [ -z "$iface" ] && continue
        IFACES+=("$iface")
    done < <(ifconfig -l | tr ' ' '\n')

    # Show menu
    echo "Select a network interface:"
    for i in "${!IFACES[@]}"; do
        printf "%d. %s\n" "$((i+1))" "${IFACES[$i]}"
    done

    # Read choice from terminal
    read -p "What interface? " CHOICE

    # Validate input
    if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || (( CHOICE < 1 || CHOICE > ${#IFACES[@]} )); then
        echo "Invalid choice."
        exit 1
    fi

    # Export selected interface
    IFACE="${IFACES[$((CHOICE-1))]}"
    export IFACE
}

# Only run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Redirect stdin from /dev/tty to allow interactive input when piped via curl
    if [ -t 0 ]; then
        # Already running interactively, no need to redirect
        :
    elif [ -r /dev/tty ]; then
        # Stdin is not a terminal (e.g., piped from curl), redirect from /dev/tty
        exec < /dev/tty
    else
        echo "Error: Cannot read from terminal. Please run this script directly, not piped through curl in a non-interactive environment." >&2
        exit 1
    fi
    
    # Example usage
    select_interface
    echo "You selected: $IFACE"
fi

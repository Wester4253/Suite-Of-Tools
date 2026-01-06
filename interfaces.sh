#!/bin/bash

select_interface() {
    # Get list of interfaces
    IFACES=()
    while IFS=: read -r _ name _; do
        IFACES+=("$name")
    done < <(ip -o link show)

    # Show menu
    echo "Select a network interface:"
    for i in "${!IFACES[@]}"; do
        printf "%d. %s\n" "$((i+1))" "${IFACES[$i]}"
    done

    # Read choice from terminal explicitly
    read -p "What interface? " CHOICE </dev/tty

    # Validate input
    if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || (( CHOICE < 1 || CHOICE > ${#IFACES[@]} )); then
        echo "Invalid choice."
        exit 1
    fi

    # Export selected interface
    IFACE="${IFACES[$((CHOICE-1))]}"
    export IFACE
}

# Example usage
select_interface
echo "You selected: $IFACE"

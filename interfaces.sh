#!/bin/bash

select_interface() {
    mapfile -t IFACES < <(ip -o link show | awk -F': ' '{print $2}')

    echo "Select a network interface:"
    for i in "${!IFACES[@]}"; do
        printf "%d. %s\n" "$((i+1))" "${IFACES[$i]}"
    done

    read -p "What interface? " CHOICE

    if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || (( CHOICE < 1 || CHOICE > ${#IFACES[@]} )); then
        echo "Invalid choice."
        exit 1
    fi

    IFACE="${IFACES[$((CHOICE-1))]}"
    export IFACE
}

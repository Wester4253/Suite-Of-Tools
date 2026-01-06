#!/bin/bash

ping4_test() { ping -I "$IFACE" -c 5 1.1.1.1; }
ping6_test() { ping6 -I "$IFACE" -c 5 2606:4700:4700::1111; }
dns_test()   { ping -I "$IFACE" -c 3 cloudflare.com; }

gateway_test() {
    GW=$(ip route show dev "$IFACE" | awk '/default/ {print $3}')
    [ -z "$GW" ] && echo "NO_GW" || ping -I "$IFACE" -c 3 "$GW"
}

packet_loss() {
    ping -I "$IFACE" -c 10 1.1.1.1 | grep -oP '\d+(?=% packet loss)'
}

latency_stats() {
    ping -I "$IFACE" -c 10 1.1.1.1 | grep -oP '(?<=rtt min/avg/max/mdev = ).*'
}

# Cloudflare API speed test (no deps)
run_speedtest() {
    curl -4 --interface "$IFACE" -s https://speed.cloudflare.com/__down?bytes=25000000 >/dev/null
    DL=$(curl -4 --interface "$IFACE" -s -w '%{speed_download}\n' -o /dev/null https://speed.cloudflare.com/__down?bytes=25000000)

    UL=$(dd if=/dev/zero bs=1M count=10 2>/dev/null | \
         curl -4 --interface "$IFACE" -s -w '%{speed_upload}\n' -o /dev/null -X POST https://speed.cloudflare.com/__up)

    echo "$DL $UL"
}

score_loss() {
    (( $1 == 0 )) && echo 100 && return
    (( $1 <= 2 )) && echo 90 && return
    (( $1 <= 5 )) && echo 75 && return
    (( $1 <= 10 )) && echo 50 && return
    echo 25
}

score_latency() {
    AVG=$(echo "$1" | cut -d'/' -f2 | cut -d'.' -f1)
    (( AVG < 30 )) && echo 100 && return
    (( AVG < 60 )) && echo 85 && return
    (( AVG < 100 )) && echo 65 && return
    echo 40
}

score_speed() {
    (( $1 > 300 )) && echo 100 && return
    (( $1 > 150 )) && echo 85 && return
    (( $1 > 50 )) && echo 65 && return
    echo 40
}

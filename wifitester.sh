#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/Wester4253/Suite-Of-Tools/main"
TMP="/tmp/wifitester.$$"

mkdir -p "$TMP"
cd "$TMP" || exit 1

curl -fsS "$BASE_URL/interfaces.sh" -o interfaces.sh || exit 1
curl -fsS "$BASE_URL/tests.sh"      -o tests.sh      || exit 1
curl -fsS "$BASE_URL/output.sh"     -o output.sh     || exit 1

chmod +x *.sh

source ./interfaces.sh
source ./tests.sh
source ./output.sh

print_header
select_interface

print_section "Interface Selected: $IFACE"
print_section "Running full network diagnostics..."

LOSS=$(packet_loss)
LAT=$(latency_stats)
read DL_RAW UL_RAW <<< "$(run_speedtest)"

DL=$(( DL_RAW * 8 / 1000000 ))
UL=$(( UL_RAW * 8 / 1000000 ))

LOSS_SCORE=$(score_loss "$LOSS")
LAT_SCORE=$(score_latency "$LAT")
SPD_SCORE=$(score_speed "$DL")
TOTAL=$(( (LOSS_SCORE + LAT_SCORE + SPD_SCORE) / 3 ))

print_section "Packet Loss"
echo "$LOSS%"
score_bar "$LOSS_SCORE"

print_section "Latency"
echo "$LAT"
score_bar "$LAT_SCORE"

print_section "Speed Test"
echo "Download: $DL Mbps"
echo "Upload:   $UL Mbps"
score_bar "$SPD_SCORE"

print_section "Overall Network Health"
score_bar "$TOTAL"

green "Diagnostics complete. Stay connected."

cd /
rm -rf "$TMP"

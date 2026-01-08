#!/bin/bash

# Parse command line arguments
VERBOSE=0
VERBOSE_SET_BY_FLAG=0
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=1
            VERBOSE_SET_BY_FLAG=1
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [-v|--verbose] [-h|--help]"
            echo "  -v, --verbose    Enable verbose output"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

export VERBOSE

# Redirect stdin from /dev/tty to allow interactive input when piped via curl
if [ -t 0 ]; then
    :
elif [ -r /dev/tty ]; then
    exec < /dev/tty
else
    echo "Error: Cannot read from terminal." >&2
    exit 1
fi

# FIXED BASE_URL: Added /SCRIPTS to match your new repo structure
BASE_URL="https://raw.githubusercontent.com/Wester4253/Suite-Of-Tools/main/SCRIPTS"
TMP_DIR="/tmp/wifitester.$$"

mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit 1

# FIXED DOWNLOAD PATHS: Added /wifi/ back into the specific file curls
curl -fsS "$BASE_URL/wifi/interfaces.sh" -o interfaces.sh || exit 1
curl -fsS "$BASE_URL/wifi/tests.sh"      -o tests.sh      || exit 1
curl -fsS "$BASE_URL/wifi/output.sh"     -o output.sh     || exit 1

chmod +x *.sh

source ./interfaces.sh
source ./tests.sh
source ./output.sh

cleanup_and_exit() {
    cd /
    rm -rf "$TMP_DIR"
    exit "${1:-1}"
}

print_header
select_interface

if [ "$VERBOSE_SET_BY_FLAG" = "0" ]; then
    echo ""
    read -p "Enable verbose mode? (y/N): " VERBOSE_CHOICE
    case "$VERBOSE_CHOICE" in
        [Yy]|[Yy][Ee][Ss])
            VERBOSE=1
            export VERBOSE
            cyan "Verbose mode enabled."
            ;;
        *)
            VERBOSE=0
            export VERBOSE
            ;;
    esac
fi

print_section "Interface Selected: $IFACE"
verbose "Interface type: $(ip -o link show "$IFACE" | awk '{print $2,$3,$17}')"

CARRIER_STATUS=$(ip -o link show "$IFACE" | grep -o 'state [A-Z]*' | awk '{print $2}')
verbose "Interface state: $CARRIER_STATUS"

IP_ADDRESSES=$(ip -o addr show "$IFACE" | awk '/inet / {print $4}')
verbose "IP addresses: $IP_ADDRESSES"

if [ "$CARRIER_STATUS" != "UP" ] && [ "$CARRIER_STATUS" != "UNKNOWN" ]; then
    red "Error: Interface $IFACE is not connected (state: $CARRIER_STATUS)."
    cleanup_and_exit 1
fi

if [ -z "$IP_ADDRESSES" ]; then
    red "Error: Interface $IFACE has no IPv4 address assigned."
    cleanup_and_exit 1
fi

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
rm -rf "$TMP_DIR"

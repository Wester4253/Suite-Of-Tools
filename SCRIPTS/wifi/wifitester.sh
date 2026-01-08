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

# Ensure we can take user input even if piped through curl | bash
if [ ! -t 0 ]; then
    exec < /dev/tty
fi

# FIXED: Added /SCRIPTS to the BASE_URL
BASE_URL="https://raw.githubusercontent.com/Wester4253/Suite-Of-Tools/main/SCRIPTS"
TMP_DIR="/tmp/wifitester.$$"

# Create temp folder
mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit 1

# FIXED: Added /wifi/ to the individual file paths
echo "Fetching components..."
curl -fsS "$BASE_URL/wifi/interfaces.sh" -o interfaces.sh || { echo "Failed to download interfaces.sh"; exit 1; }
curl -fsS "$BASE_URL/wifi/tests.sh"      -o tests.sh      || { echo "Failed to download tests.sh"; exit 1; }
curl -fsS "$BASE_URL/wifi/output.sh"     -o output.sh     || { echo "Failed to download output.sh"; exit 1; }

chmod +x *.sh

# Source the freshly downloaded scripts
source ./interfaces.sh
source ./tests.sh
source ./output.sh

# Cleanup function
cleanup_and_exit() {
    cd /
    rm -rf "$TMP_DIR"
    exit "${1:-1}"
}

print_header
select_interface

# Ask user about verbose mode if not set by command-line flag
if [ "$VERBOSE_SET_BY_FLAG" = "0" ]; then
    echo ""
    read -p "Enable verbose mode? (y/N): " VERBOSE_CHOICE
    case "$VERBOSE_CHOICE" in
        [Yy]|[Yy][Ee][Ss])
            VERBOSE=1
            export VERBOSE
            echo "Verbose mode enabled."
            ;;
        *)
            VERBOSE=0
            export VERBOSE
            ;;
    esac
fi

print_section "Interface Selected: $IFACE"

# Check if interface has carrier
CARRIER_STATUS=$(ip -o link show "$IFACE" | grep -o 'state [A-Z]*' | awk '{print $2}')

# Check if interface has IP address
IP_ADDRESSES=$(ip -o addr show "$IFACE" | awk '/inet / {print $4}')

# Validate interface
if [ "$CARRIER_STATUS" != "UP" ] && [ "$CARRIER_STATUS" != "UNKNOWN" ]; then
    echo "Error: Interface $IFACE is not connected (state: $CARRIER_STATUS)."
    cleanup_and_exit 1
fi

if [ -z "$IP_ADDRESSES" ]; then
    echo "Error: Interface $IFACE has no IPv4 address assigned."
    cleanup_and_exit 1
fi

print_section "Running full network diagnostics..."

# Run tests (Assuming these functions exist in the sourced files)
LOSS=$(packet_loss)
LAT=$(latency_stats)

# Run speedtest
DL_RAW=$(run_speedtest)

DL=$(( DL_RAW * 8 / 1000000 ))

# Scoring
LOSS_SCORE=$(score_loss "$LOSS")
LAT_SCORE=$(score_latency "$LAT")
SPD_SCORE=$(score_speed "$DL")
TOTAL=$(( (LOSS_SCORE + LAT_SCORE + SPD_SCORE) / 3 ))

# Output results
print_section "Packet Loss"
echo "$LOSS%"
score_bar "$LOSS_SCORE"

print_section "Latency"
echo "$LAT"
score_bar "$LAT_SCORE"

print_section "Speed Test"
echo "Download: $DL Mbps"
score_bar "$SPD_SCORE"

print_section "Overall Network Health"
score_bar "$TOTAL"

echo "Diagnostics complete."

# Final Clean up
cleanup_and_exit 0

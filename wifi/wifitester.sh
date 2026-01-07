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
    # Already running interactively, no need to redirect
    :
elif [ -r /dev/tty ]; then
    # Stdin is not a terminal (e.g., piped from curl), redirect from /dev/tty
    exec < /dev/tty
else
    echo "Error: Cannot read from terminal. Please run this script directly, not piped through curl in a non-interactive environment." >&2
    exit 1
fi

# Base URL for fetching scripts
# NOTE: This points to 'main' branch. When testing a PR branch, you may want to 
# change this temporarily to the PR branch name (e.g., copilot/fix-curl-choice-blocks)
BASE_URL="https://raw.githubusercontent.com/Wester4253/Suite-Of-Tools/main"
TMP_DIR="/tmp/wifitester.$$"

# Create temp folder
mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit 1

# Download latest scripts
curl -fsS "$BASE_URL/wifi/interfaces.sh" -o interfaces.sh || exit 1
curl -fsS "$BASE_URL/wifi/tests.sh"      -o tests.sh      || exit 1
curl -fsS "$BASE_URL/wifi/output.sh"     -o output.sh     || exit 1

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

# Check if interface has carrier (is connected)
CARRIER_STATUS=$(ip -o link show "$IFACE" | grep -o 'state [A-Z]*' | awk '{print $2}')
verbose "Interface state: $CARRIER_STATUS"

# Check if interface has IP address
IP_ADDRESSES=$(ip -o addr show "$IFACE" | awk '/inet/ {print $4}')
verbose "IP addresses: $IP_ADDRESSES"

# Validate interface is suitable for testing
if [ "$CARRIER_STATUS" != "UP" ] && [ "$CARRIER_STATUS" != "UNKNOWN" ]; then
    red "Error: Interface $IFACE is not connected (state: $CARRIER_STATUS)."
    red "Please connect the interface or select a different one."
    cleanup_and_exit 1
fi

if [ -z "$IP_ADDRESSES" ]; then
    red "Error: Interface $IFACE has no IP address assigned."
    red "Please configure an IP address on the interface or select a different one."
    cleanup_and_exit 1
fi

print_section "Running full network diagnostics..."

# Run packet loss and latency tests
LOSS=$(packet_loss)
LAT=$(latency_stats)

# Run Cloudflare speedtest API
read DL_RAW UL_RAW <<< "$(run_speedtest)"

# Convert from bytes/sec to Mbps
DL=$(( DL_RAW * 8 / 1000000 ))
UL=$(( UL_RAW * 8 / 1000000 ))

verbose "Download: $DL_RAW bytes/sec = $DL Mbps"
verbose "Upload: $UL_RAW bytes/sec = $UL Mbps"

# Score each metric
LOSS_SCORE=$(score_loss "$LOSS")
LAT_SCORE=$(score_latency "$LAT")
SPD_SCORE=$(score_speed "$DL")
TOTAL=$(( (LOSS_SCORE + LAT_SCORE + SPD_SCORE) / 3 ))

verbose "Scores - Loss: $LOSS_SCORE, Latency: $LAT_SCORE, Speed: $SPD_SCORE, Total: $TOTAL"

# Output results
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

# Clean up
cd /
rm -rf "$TMP_DIR"

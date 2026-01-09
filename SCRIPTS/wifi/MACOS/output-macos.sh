#!/bin/bash

green() { echo -e "\033[1;32m$1\033[0m"; }
red()   { echo -e "\033[1;31m$1\033[0m"; }
cyan()  { echo -e "\033[1;36m$1\033[0m"; }
yellow() { echo -e "\033[1;33m$1\033[0m"; }

# Verbose mode flag (default: off)
VERBOSE=${VERBOSE:-0}

verbose() {
    if [ "$VERBOSE" = "1" ]; then
        echo "$@" >&2
    fi
}

print_header() {
    cyan "Network Tester script, made by Noa Butterfield."
}

print_section() {
    echo
    cyan "$1"
}

print_result() {
    echo "$1"
}
pass() { echo -e "\033[1;32mPASS\033[0m $1"; }
fail() { echo -e "\033[1;31mFAIL\033[0m $1"; }
score_bar() {
    SCORE=$1
    if (( SCORE > 85 )); then pass "Score: $SCORE/100"
    elif (( SCORE > 60 )); then echo -e "\033[1;33mOK\033[0m Score: $SCORE/100"
    else fail "Score: $SCORE/100"
    fi
}

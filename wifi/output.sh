#!/bin/bash

green() { echo -e "\e[1;32m$1\e[0m"; }
red()   { echo -e "\e[1;31m$1\e[0m"; }
cyan()  { echo -e "\e[1;36m$1\e[0m"; }
yellow() { echo -e "\e[1;33m$1\e[0m"; }

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
pass() { echo -e "\e[1;32mPASS\e[0m $1"; }
fail() { echo -e "\e[1;31mFAIL\e[0m $1"; }
score_bar() {
    SCORE=$1
    if (( SCORE > 85 )); then pass "Score: $SCORE/100"
    elif (( SCORE > 60 )); then echo -e "\e[1;33mOK\e[0m Score: $SCORE/100"
    else fail "Score: $SCORE/100"
    fi
}

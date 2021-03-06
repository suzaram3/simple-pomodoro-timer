#!/bin/bash
# ------------------------------------------------------------------
#   Mitch Suzara
#   suzaram3@gmail.com
#   pomodoro timer
#   Simple pomodor countdown timer to assist with productivity.
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=some-unique-id
USAGE="Usage: command -ihv args"

BREAK_MINUTES=5
LONG_BREAK_MINUTES=20
SECONDS_PER_MINUTE=60
WORK_CYCLE=0
# four cycles of work before a longer break
WORK_MAX=4
# 25 minute working intervals
WORK_MINUTES=25

# strings for messages and alerts
BREAK_MESSAGE="Break time $USER"
LONG_BREAK_MESSAGE="Take a longer break $USER you earned it"
SOUND="Submarine"
STATUS=""
TITLE="TIME'S UP!!"
WORK_MESSAGE="Back to work $USER"

# work and break times
BREAK_TIME=$(( $BREAK_MINUTES * $SECONDS_PER_MINUTE ))
LONG_BREAK_TIME=$(( $LONG_BREAK_MINUTES * $SECONDS_PER_MINUTE ))
WORK_TIME=$(( $WORK_MINUTES * $SECONDS_PER_MINUTE ))

# test variables
# WORK_TEST_SECONDS=3
# BREAK_TEST_SECONDS=1

# display notification for work and break, audible queue alert user
display_notification() {
    case $STATUS in
        work)
        osascript -e "display notification \"$BREAK_MESSAGE\" sound name \"$SOUND\" with title \"$TITLE\""
        osascript -e "say \"$BREAK_MESSAGE\"";;
        break)
        osascript -e "display notification \"$WORK_MESSAGE\" sound name \"$SOUND\" with title \"$TITLE\""
        osascript -e "say \"$WORK_MESSAGE\"";;
        long)
        osascript -e "display notification \"$LONG_BREAK_MESSAGE\" sound name \"$SOUND\" with title \"$TITLE\""
        osascript -e "say \"$LONG_BREAK_MESSAGE\"";;
        *) 
        osascript -e "say \"let's begin\"";;
    esac
}

# countdown timer for work and break cycles
countdown1() {
        display_notification
        # will continue to run until SIGINT is detected "Ctrl + C"
        while true; do
                if [ "$WORK_CYCLE" -lt "$WORK_MAX" ]
                then
                    STATUS="work"
                    local now=$(date +%s)
                    local end=$((now + $WORK_TIME))
                    while (( now < end )); do
                        printf "Work Remaining: %s\r" "$(date -u -j -f  %s $((end - now)) +%T)"
                        sleep 0.25
                        now=$(date +%s)
                    done
                    display_notification
                    ((WORK_CYCLE++))
                    echo
                    clear
                    STATUS="break"
                    local now=$(date +%s)
                    local end=$((now + $BREAK_TIME))
                    while (( now < end )); do
                        printf "Break Remaining: %s\r" "$(date -u -j -f  %s $((end - now)) +%T)"
                        sleep 0.25
                        now=$(date +%s)
                    done
                    display_notification
                    echo
                    clear
                else
                    STATUS="long"
                    display_notification
                    WORK_CYCLE=0
                    local now=$(date +%s)
                    local end=$((now + $LONG_BREAK_TIME))
                    while (( now < end )); do
                        printf "Long Break Remaining: %s\r" "$(date -u -j -f  %s $((end - now)) +%T)"
                        sleep 0.25
                        now=$(date +%s)
                    done
                    echo
                    STATUS="work"
                    display_notification
                    clear
                fi
            done
}

countdown1
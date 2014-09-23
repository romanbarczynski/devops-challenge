#!/bin/bash

set -e

echo -e "\033[33mStarting test environment\033[0m"
./start_env.sh || (echo -e "\033[31mERROR while starting environment\033[0m"; exit 1)

COUNTER=`shuf -i 1-99999 -n 1`

{ echo "SET counter $COUNTER"; sleep 1; } | telnet localhost 6379 | grep "+OK"

check_counter() {
    if curl localhost:8080/counter | grep $1 ; then
        echo -e "\033[32mSUCCESS $2\033[0m"
    else
        echo -e "\033[31mFAILURE $2 expected counter $1\033[0m"
        false
    fi
}

increment_counter() {
    if curl -X POST -d incrBy=$1 localhost:8080/counter ; then
        echo -e "\n\033[32mCounter incremented by $1\033[0m"
    else
        echo -e "\n\033[31mERROR can't increment counter $1\033[0m"
        false
    fi
}

check_counter $COUNTER "Check initial value"

increment_counter 1

check_counter $((COUNTER+1)) "After first increment"

increment_counter 999

check_counter $((COUNTER+1000)) "After big increment"

echo -e "\033[33mStopping test environment\033[0m"
./stop_env.sh || (echo -e "\033[31mERROR while stopping environment\033[0m"; exit 1)

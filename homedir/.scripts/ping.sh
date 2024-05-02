#!/bin/bash

# Target endpoint
TARGET="ping.ubnt.com"

# Number of times to ping
COUNT=5

# Ping the target
echo "Pinging ${TARGET} ${COUNT} times..."
ping -c $COUNT $TARGET

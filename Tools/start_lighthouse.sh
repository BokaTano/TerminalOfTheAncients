#!/bin/bash

# 🏮 Lighthouse Server - Start Script
# This script builds and starts the lighthouse server for the BeaconPuzzle

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -d "lighthouse" ]; then
    echo -e "${RED}❌ Error: lighthouse directory not found. Please run this script from the TerminalOfTheAncients directory.${NC}"
    exit 1
fi

# Change to lighthouse directory
cd lighthouse

# Check if server is already running
if curl -s http://localhost:8080/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Lighthouse server is already running on port 8080${NC}"
    exit 0
fi

# Build the lighthouse server
echo -e "${YELLOW}🔨 Building lighthouse server...${NC}"
swift build 2>&1 | while IFS= read -r line; do
    if [[ $line =~ \[([0-9]+)/([0-9]+)\] ]]; then
        current="${BASH_REMATCH[1]}"
        total="${BASH_REMATCH[2]}"
        percentage=$((current * 100 / total))
        printf "\r[%-50s] %d%%" $(printf '#%.0s' $(seq 1 $((percentage/2)))) $percentage
    elif [[ $line =~ "Build complete" ]]; then
        printf "\r\033[K"  # Clear the progress bar line
        printf "\033[1A\033[K"  # Move up one line and clear "🔨 Building..."
        echo -e "${GREEN}✅ $line${NC}"
    elif [[ $line =~ "error:" ]]; then
        printf "\n"
        echo -e "${RED}❌ $line${NC}"
    fi
done

# Start the server in the background
echo -e "${BLUE}🚀 Starting lighthouse server on port 8080...${NC}"
.build/debug/lighthouse > /dev/null 2>&1 &
LIGHTHOUSE_PID=$!

# Wait a moment for server to start
sleep 2

# Check if server started successfully
if curl -s http://localhost:8080/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Lighthouse server is running on port 8080 (PID: $LIGHTHOUSE_PID)${NC}"
    echo -e "${BLUE}💡 To stop the server, run: kill $LIGHTHOUSE_PID${NC}"
else
    echo -e "${RED}❌ Failed to start lighthouse server${NC}"
    kill $LIGHTHOUSE_PID 2>/dev/null || true
    exit 1
fi 
#!/bin/bash

# 🏛️ Terminal of the Ancients - Build & Run Script
# This script builds the project and runs it for easy development

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo -e "${RED}❌ Error: Package.swift not found. Please run this script from the TerminalOfTheAncients directory.${NC}"
    exit 1
fi

# Build the project with progress bar
echo -e "${YELLOW}🔨 Building...${NC}"
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

# Run with arguments
if [ $# -eq 0 ]; then
    .build/debug/terminal-of-the-ancients
else
    .build/debug/terminal-of-the-ancients "$@"
fi 
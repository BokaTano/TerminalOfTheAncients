#!/bin/bash

# 🏛️ Terminal of the Ancients - Simple Test Script
# This script performs basic tests to ensure the game is working

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Simple Test for Terminal of the Ancients...${NC}"

# Check if we're in the right directory (Tests folder)
if [ ! -f "../Package.swift" ]; then
    echo -e "${RED}❌ Error: Package.swift not found. Please run this script from the Tests directory.${NC}"
    exit 1
fi

# Change to project root directory
cd ..

# Build the project
echo -e "${YELLOW}🔨 Building project...${NC}"
swift build > /dev/null 2>&1
echo -e "${GREEN}✅ Build successful${NC}"

# Check if executable exists
if [ -f ".build/debug/TOTA" ]; then
    echo -e "${GREEN}✅ Executable exists${NC}"
else
    echo -e "${RED}❌ Executable not found${NC}"
    exit 1
fi

# Test help command
if .build/debug/TOTA --help > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Help command works${NC}"
else
    echo -e "${RED}❌ Help command failed${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Simple test passed!${NC}" 
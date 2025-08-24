#!/bin/bash

# 🏛️ Terminal of the Ancients - Functionality Test Script
# This script tests specific game functionality

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Testing Terminal of the Ancients Functionality...${NC}"

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

# Test 1: Status command
echo -e "${YELLOW}📊 Testing status command...${NC}"
if .build/debug/TOTA --status; then
    echo -e "${GREEN}✅ Status command works${NC}"
else
    echo -e "${RED}❌ Status command failed${NC}"
    exit 1
fi

# Test 2: Reset command
echo -e "${YELLOW}🔄 Testing reset command...${NC}"
if .build/debug/TOTA --reset; then
    echo -e "${GREEN}✅ Reset command works${NC}"
else
    echo -e "${RED}❌ Reset command failed${NC}"
    exit 1
fi

# Test 3: Verify reset worked
echo -e "${YELLOW}🔍 Verifying reset...${NC}"
STATUS_OUTPUT=$(.build/debug/TOTA --status 2>&1)
if echo "$STATUS_OUTPUT" | grep -q "Current Task: 1"; then
    echo -e "${GREEN}✅ Reset verification passed${NC}"
else
    echo -e "${RED}❌ Reset verification failed${NC}"
    echo "Status output: $STATUS_OUTPUT"
    exit 1
fi

# Test 4: Jump command
echo -e "${YELLOW}📍 Testing jump command...${NC}"
if .build/debug/TOTA --jump 2; then
    echo -e "${GREEN}✅ Jump command works${NC}"
else
    echo -e "${RED}❌ Jump command failed${NC}"
    exit 1
fi

# Test 5: Verify jump worked
echo -e "${YELLOW}🔍 Verifying jump...${NC}"
STATUS_OUTPUT=$(.build/debug/TOTA --status 2>&1)
if echo "$STATUS_OUTPUT" | grep -q "Current Task: 3"; then
    echo -e "${GREEN}✅ Jump verification passed${NC}"
else
    echo -e "${RED}❌ Jump verification failed${NC}"
    echo "Status output: $STATUS_OUTPUT"
    exit 1
fi

# Test 6: Welcome command
echo -e "${YELLOW}🚀 Testing welcome command...${NC}"
if .build/debug/TOTA --welcome; then
    echo -e "${GREEN}✅ Welcome command works${NC}"
else
    echo -e "${RED}❌ Welcome command failed${NC}"
    exit 1
fi

# Test 7: Verify welcome worked
echo -e "${YELLOW}🔍 Verifying welcome...${NC}"
STATUS_OUTPUT=$(.build/debug/TOTA --status 2>&1)
if echo "$STATUS_OUTPUT" | grep -q "Current Task: 2"; then
    echo -e "${GREEN}✅ Welcome verification passed${NC}"
else
    echo -e "${RED}❌ Welcome verification failed${NC}"
    echo "Status output: $STATUS_OUTPUT"
    exit 1
fi

echo -e "${GREEN}🎉 All functionality tests passed!${NC}" 
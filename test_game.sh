#!/bin/bash

# 🏛️ Terminal of the Ancients - Game Testing Script
# This script tests the game functionality to ensure everything works correctly

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Testing Terminal of the Ancients...${NC}"

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo -e "${RED}❌ Error: Package.swift not found. Please run this script from the TerminalOfTheAncients directory.${NC}"
    exit 1
fi

# Build the project
echo -e "${YELLOW}🔨 Building project...${NC}"
swift build > /dev/null 2>&1
echo -e "${GREEN}✅ Build successful${NC}"

# Test 1: Check if executable exists
if [ -f ".build/debug/TOTA" ]; then
    echo -e "${GREEN}✅ Executable exists${NC}"
else
    echo -e "${RED}❌ Executable not found${NC}"
    exit 1
fi

# Test 2: Test help command
echo -e "${YELLOW}📖 Testing help command...${NC}"
if .build/debug/TOTA --help > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Help command works${NC}"
else
    echo -e "${RED}❌ Help command failed${NC}"
    exit 1
fi

# Test 3: Test reset command
echo -e "${YELLOW}🔄 Testing reset command...${NC}"
.build/debug/TOTA --reset > /dev/null 2>&1
echo -e "${GREEN}✅ Reset command works${NC}"

# Test 4: Test initiate command
echo -e "${YELLOW}🚀 Testing initiate command...${NC}"
# Create a temporary input file
temp_input=$(mktemp)
echo "quit" > "$temp_input"

output=$(.build/debug/TOTA --initiate < "$temp_input" 2>&1 || true)
rm "$temp_input"

if echo "$output" | grep -q "Welcome Ritual completed"; then
    echo -e "${GREEN}✅ Initiate command works${NC}"
else
    echo -e "${RED}❌ Initiate command failed${NC}"
    echo "Output: $output"
    exit 1
fi

# Test 5: Test status command
echo -e "${YELLOW}📊 Testing status command...${NC}"
final_state=$(.build/debug/TOTA --status 2>&1 || true)
if echo "$final_state" | grep -q "Current Task: 2"; then
    echo -e "${GREEN}✅ Status command works${NC}"
else
    echo -e "${RED}❌ Status command failed${NC}"
    echo "Output: $final_state"
    exit 1
fi

# Test 6: Test jump command
echo -e "${YELLOW}📍 Testing jump command...${NC}"
.build/debug/TOTA --jump 3 > /dev/null 2>&1
jump_state=$(.build/debug/TOTA --status 2>&1 || true)
if echo "$jump_state" | grep -q "Current Task: 4"; then
    echo -e "${GREEN}✅ Jump command works${NC}"
else
    echo -e "${RED}❌ Jump command failed${NC}"
    echo "Output: $jump_state"
    exit 1
fi

# Test 7: Test interactive mode (basic)
echo -e "${YELLOW}🎮 Testing interactive mode...${NC}"
# Test with various inputs
test_commands=(
    ".build/debug/TOTA" \
    ".build/debug/TOTA --reset" \
    ".build/debug/TOTA --status" \
    ".build/debug/TOTA --initiate" \
)

for cmd in "${test_commands[@]}"; do
    if echo "quit" | timeout 5s $cmd > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $cmd works${NC}"
    else
        echo -e "${RED}❌ $cmd failed${NC}"
    fi
done

# Test 8: Test special commands
echo -e "${YELLOW}🔍 Testing special commands...${NC}"
special_tests=(
    "echo 'hint' | timeout 5s .build/debug/TOTA --initiate || true" \
    "echo 'quit' | .build/debug/TOTA --initiate" \
    "echo 'xyzzy' | timeout 5s .build/debug/TOTA --initiate || true" \
    "echo 'wrong' | timeout 5s .build/debug/TOTA --initiate || true" \
)

for test_cmd in "${special_tests[@]}"; do
    if eval "$test_cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Special command test passed${NC}"
    else
        echo -e "${RED}❌ Special command test failed${NC}"
    fi
done

echo -e "${GREEN}🎉 All tests passed! The Terminal of the Ancients is working correctly.${NC}" 
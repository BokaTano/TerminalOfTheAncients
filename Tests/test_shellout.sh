#!/bin/bash

# 🧪 ShellOut Puzzle Test Script
# Tests the new ShellOut integration puzzle

set -e  # Exit on any error

echo "🧪 Testing ShellOut Puzzle Integration"
echo "======================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counter
PASSED=0
FAILED=0

# Test function
test_shellout() {
    local test_name="$1"
    local command="$2"
    local expected="$3"
    
    echo -e "\n${BLUE}Testing: $test_name${NC}"
    echo "Command: $command"
    
    local output
    output=$(eval "$command" 2>&1 || true)
    
    if echo "$output" | grep -q "$expected"; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((PASSED++))
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo "Expected: $expected"
        echo "Got: $output"
        ((FAILED++))
    fi
}

# Check if we're in the right directory (Tests folder)
if [ ! -f "../Package.swift" ]; then
    echo -e "${RED}❌ Error: Package.swift not found. Please run this script from the Tests directory.${NC}"
    exit 1
fi

# Change to project root directory
cd ..

# Build the project first
echo -e "\n${YELLOW}Building project...${NC}"
swift build

# Test 1: Check if build script exists and is executable
test_shellout "Build script exists" \
    "ls -la build_and_run.sh" \
    "build_and_run.sh"

# Test 2: Check if build script runs
test_shellout "Build script runs" \
    "./build_and_run.sh --status" \
    "Build successful"

# Test 3: Test ShellOut dependency is available
test_shellout "ShellOut dependency" \
    "swift package show-dependencies" \
    "ShellOut"

# Test 4: Test shell command execution (simulate puzzle)
test_shellout "Shell command execution" \
    "swift -e 'import ShellOut; print(try shellOut(to: \"echo automation\"))'" \
    "automation"

# Test 5: Test game with ShellOut puzzle
test_shellout "Game recognizes ShellOut puzzle" \
    "./build_and_run.sh --status" \
    "Current Task: 1 of 7"

# Summary
echo -e "\n${YELLOW}======================================"
echo "Test Summary"
echo "======================================"
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
echo -e "${RED}❌ Failed: $FAILED${NC}"
echo -e "${BLUE}📊 Total: $((PASSED + FAILED))${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All ShellOut tests passed!${NC}"
    echo -e "${YELLOW}The ShellOut integration is working correctly.${NC}"
    exit 0
else
    echo -e "\n${RED}💥 Some ShellOut tests failed.${NC}"
    exit 1
fi 
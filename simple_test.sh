#!/bin/bash

# Simple test script for Terminal of the Ancients
# Tests core functionality without getting stuck in input loops

echo "🧪 Simple Terminal of the Ancients Test"
echo "========================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Build the project
echo -e "\n${YELLOW}Building project...${NC}"
swift build

# Test counter
PASSED=0
FAILED=0

# Test function
test_command() {
    local test_name="$1"
    local command="$2"
    local expected="$3"
    
    echo -e "\n${YELLOW}Testing: $test_name${NC}"
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

# Test 1: Initial message
test_command "Initial message" \
    ".build/debug/terminal-of-the-ancients" \
    "Welcome, digital archaeologist"

# Test 2: Reset game
test_command "Reset game" \
    ".build/debug/terminal-of-the-ancients --reset" \
    "Game reset"

# Test 3: Status with no progress
test_command "Status with no progress" \
    ".build/debug/terminal-of-the-ancients --status" \
    "No game progress found"

# Test 4: Initiate flag (should complete first task)
test_command "Initiate flag" \
    ".build/debug/terminal-of-the-ancients --initiate" \
    "Welcome Ritual completed"

# Test 5: Status after initiate
test_command "Status after initiate" \
    ".build/debug/terminal-of-the-ancients --status" \
    "Current Task: 2 of 5"

# Test 6: Check if puzzle files are created
test_command "Puzzle files created" \
    "ls secret_code.txt treasure.json" \
    "secret_code.txt"

# Test 7: Check file contents
test_command "Secret code file contents" \
    "cat secret_code.txt" \
    "ancient"

test_command "Treasure JSON contents" \
    "cat treasure.json" \
    "swiftdata"

# Summary
echo -e "\n${YELLOW}========================================"
echo "Test Summary"
echo "========================================"
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
echo -e "${RED}❌ Failed: $FAILED${NC}"
echo -e "${YELLOW}📊 Total: $((PASSED + FAILED))${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All core functionality tests passed!${NC}"
    echo -e "${YELLOW}Note: Interactive input testing requires manual verification.${NC}"
    exit 0
else
    echo -e "\n${RED}💥 Some tests failed.${NC}"
    exit 1
fi 
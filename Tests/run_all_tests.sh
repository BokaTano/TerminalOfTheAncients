#!/bin/bash

# 🧪 Run All Tests Script
# This script runs all tests in the Tests folder

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Running All Tests for Terminal of the Ancients...${NC}"

# Check if we're in the Tests directory
if [ ! -f "../Package.swift" ]; then
    echo -e "${RED}❌ Error: Package.swift not found. Please run this script from the Tests directory.${NC}"
    exit 1
fi

# Change to project root directory
cd ..

# Test counter
PASSED=0
FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_script="$2"
    
    echo -e "\n${YELLOW}Running: $test_name${NC}"
    echo "======================================"
    
    if bash "Tests/$test_script"; then
        echo -e "${GREEN}✅ $test_name PASSED${NC}"
        ((PASSED++))
    else
        echo -e "${RED}❌ $test_name FAILED${NC}"
        ((FAILED++))
    fi
}

# Run all tests
run_test "Simple Test" "simple_test.sh"
run_test "Game Functionality Test" "test_game_functionality.sh"
run_test "ShellOut Test" "test_shellout.sh"
run_test "Full Game Test" "test_game.sh"

# Summary
echo -e "\n${YELLOW}======================================"
echo "Final Test Summary"
echo "======================================"
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
echo -e "${RED}❌ Failed: $FAILED${NC}"
echo -e "${BLUE}📊 Total: $((PASSED + FAILED))${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}💥 Some tests failed.${NC}"
    exit 1
fi 
#!/bin/bash

# Terminal of the Ancients - Automated Test Script
# This script tests various scenarios of the game

set -e  # Exit on any error

echo "🧪 Starting Terminal of the Ancients Test Suite"
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_output="$3"
    
    echo -e "\n${BLUE}Running test: $test_name${NC}"
    echo "Command: $command"
    
    # Run the command and capture output
    local output
    output=$(eval "$command" 2>&1 || true)
    
    # Check if expected output is in the result
    if echo "$output" | grep -q "$expected_output"; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo "Expected: $expected_output"
        echo "Got: $output"
        ((TESTS_FAILED++))
    fi
}

# Function to test game progression
test_game_progression() {
    local test_name="$1"
    local inputs="$2"
    local expected_final_state="$3"
    
    echo -e "\n${BLUE}Running progression test: $test_name${NC}"
    
    # Reset the game first
    .build/debug/terminal-of-the-ancients --reset > /dev/null 2>&1
    
    # Create a temporary file with inputs
    local temp_input=$(mktemp)
    echo "$inputs" > "$temp_input"
    
    # Run the game with inputs
    local output
    output=$(.build/debug/terminal-of-the-ancients --initiate < "$temp_input" 2>&1 || true)
    
    # Clean up
    rm "$temp_input"
    
    # Check the final state
    local final_state
    final_state=$(.build/debug/terminal-of-the-ancients --status 2>&1 || true)
    
    if echo "$final_state" | grep -q "$expected_final_state"; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo "Expected final state: $expected_final_state"
        echo "Got: $final_state"
        ((TESTS_FAILED++))
    fi
}

# Build the project first
echo -e "\n${YELLOW}Building project...${NC}"
swift build

# Test 1: Show initial message without --initiate
run_test "Initial message" \
    ".build/debug/terminal-of-the-ancients" \
    "Welcome, digital archaeologist!"

# Test 2: Reset game
run_test "Reset game" \
    ".build/debug/terminal-of-the-ancients --reset" \
    "Game reset! All progress has been cleared."

# Test 3: Show status when no progress
run_test "Status with no progress" \
    ".build/debug/terminal-of-the-ancients --status" \
    "No game progress found"

# Test 4: Test --initiate flag (should complete first task automatically)
run_test "Initiate flag" \
    ".build/debug/terminal-of-the-ancients --initiate" \
    "Welcome Ritual completed"

# Test 5: Test game progression through first few tasks
test_game_progression "Complete first two tasks" \
    "swift" \
    "Current Task: 3 of 5"

# Test 6: Test file reading task
test_game_progression "Complete file reading task" \
    "swift
ancient" \
    "Current Task: 4 of 5"

# Test 7: Test JSON parsing task
test_game_progression "Complete JSON parsing task" \
    "swift
ancient
swiftdata" \
    "Current Task: 5 of 5"

# Test 8: Test complete game
test_game_progression "Complete entire game" \
    "swift
ancient
swiftdata
terminal_of_the_ancients" \
    "All tasks completed"

# Test 9: Test hint functionality
run_test "Hint functionality" \
    "echo 'hint' | timeout 5s .build/debug/terminal-of-the-ancients --initiate || true" \
    "Hint:"

# Test 10: Test quit functionality
run_test "Quit functionality" \
    "echo 'quit' | .build/debug/terminal-of-the-ancients --initiate" \
    "Farewell, digital archaeologist"

# Test 11: Test easter egg
run_test "Easter egg" \
    "echo 'xyzzy' | timeout 5s .build/debug/terminal-of-the-ancients --initiate || true" \
    "easter egg"

# Test 12: Test incorrect answer handling
run_test "Incorrect answer handling" \
    "echo 'wrong' | timeout 5s .build/debug/terminal-of-the-ancients --initiate || true" \
    "Incorrect"

# Summary
echo -e "\n${YELLOW}================================================"
echo "🧪 Test Summary"
echo "================================================"
echo -e "✅ Tests Passed: $TESTS_PASSED${NC}"
echo -e "${RED}❌ Tests Failed: $TESTS_FAILED${NC}"
echo -e "${BLUE}📊 Total Tests: $((TESTS_PASSED + TESTS_FAILED))${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All tests passed! The game is working correctly.${NC}"
    exit 0
else
    echo -e "\n${RED}💥 Some tests failed. Please check the output above.${NC}"
    exit 1
fi 
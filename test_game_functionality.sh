#!/bin/bash

echo "🧪 Testing Game Functionality After Service Layer Refactoring"
echo "=============================================================="

# Test 1: Build the project
echo "📦 Test 1: Building the project..."
if swift build; then
    echo "✅ Build successful"
else
    echo "❌ Build failed"
    exit 1
fi

# Test 2: Check game status
echo -e "\n📊 Test 2: Checking game status..."
if .build/debug/terminal-of-the-ancients --status; then
    echo "✅ Status command works"
else
    echo "❌ Status command failed"
    exit 1
fi

# Test 3: Test reset functionality
echo -e "\n🔄 Test 3: Testing reset functionality..."
if .build/debug/terminal-of-the-ancients --reset; then
    echo "✅ Reset command works"
else
    echo "❌ Reset command failed"
    exit 1
fi

# Test 4: Verify reset worked
echo -e "\n📊 Test 4: Verifying reset worked..."
STATUS_OUTPUT=$(.build/debug/terminal-of-the-ancients --status 2>&1)
if echo "$STATUS_OUTPUT" | grep -q "Current Task: 1 of 4"; then
    echo "✅ Reset verified - back to task 1"
else
    echo "❌ Reset verification failed"
    echo "Status output: $STATUS_OUTPUT"
    exit 1
fi

# Test 5: Test jump functionality
echo -e "\n🎯 Test 5: Testing jump functionality..."
if .build/debug/terminal-of-the-ancients --jump 2; then
    echo "✅ Jump command works"
else
    echo "❌ Jump command failed"
    exit 1
fi

# Test 6: Verify jump worked
echo -e "\n📊 Test 6: Verifying jump worked..."
STATUS_OUTPUT=$(.build/debug/terminal-of-the-ancients --status 2>&1)
if echo "$STATUS_OUTPUT" | grep -q "Current Task: 3 of 4"; then
    echo "✅ Jump verified - now at task 3"
else
    echo "❌ Jump verification failed"
    echo "Status output: $STATUS_OUTPUT"
    exit 1
fi

# Test 7: Test initiate functionality
echo -e "\n🚀 Test 7: Testing initiate functionality..."
if .build/debug/terminal-of-the-ancients --initiate; then
    echo "✅ Initiate command works"
else
    echo "❌ Initiate command failed"
    exit 1
fi

# Test 8: Verify initiate worked
echo -e "\n📊 Test 8: Verifying initiate worked..."
STATUS_OUTPUT=$(.build/debug/terminal-of-the-ancients --status 2>&1)
if echo "$STATUS_OUTPUT" | grep -q "Current Task: 2 of 4"; then
    echo "✅ Initiate verified - now at task 2"
else
    echo "❌ Initiate verification failed"
    echo "Status output: $STATUS_OUTPUT"
    exit 1
fi

echo -e "\n🎉 All tests passed! Service layer refactoring is working correctly."
echo "📝 Test summary:"
echo "   ✅ Build system works"
echo "   ✅ Status command works"
echo "   ✅ Reset functionality works"
echo "   ✅ Jump functionality works"
echo "   ✅ Initiate functionality works"
echo "   ✅ Data persistence works" 
#!/bin/bash

echo "🧪 Simple Service Layer Test"
echo "============================"

# Test 1: Build
echo "📦 Building project..."
swift build
if [ $? -eq 0 ]; then
    echo "✅ Build successful"
else
    echo "❌ Build failed"
    exit 1
fi

# Test 2: Check if executable exists
echo "🔍 Checking executable..."
if [ -f ".build/debug/terminal-of-the-ancients" ]; then
    echo "✅ Executable exists"
else
    echo "❌ Executable not found"
    exit 1
fi

# Test 3: Test help
echo "❓ Testing help command..."
.build/debug/terminal-of-the-ancients --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Help command works"
else
    echo "❌ Help command failed"
    exit 1
fi

echo "🎉 Basic tests passed! Service layer refactoring appears to be working." 
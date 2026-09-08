#!/bin/bash
set -e

# Auto-detect Xcode developer directory if not already set or pointed to CommandLineTools
if [ -d "/Applications/Xcode.app/Contents/Developer" ] && [ -z "$DEVELOPER_DIR" ]; then
    export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

echo "🧪 Running Multi-Module Unit Tests via Tuist..."
tuist test --no-selective-testing

echo "🎉 All tests passed successfully!"

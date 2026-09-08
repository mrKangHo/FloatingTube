#!/bin/bash
set -e

# Auto-detect Xcode developer directory if not already set or pointed to CommandLineTools
if [ -d "/Applications/Xcode.app/Contents/Developer" ] && [ -z "$DEVELOPER_DIR" ]; then
    export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

echo "🚀 Generating Xcode Project and Workspace via Tuist..."
tuist generate --no-open

echo "✅ Tuist project generated successfully: FloatingTube.xcworkspace"

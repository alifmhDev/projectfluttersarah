#!/bin/bash

# Stop build on first error
set -e

# Install Flutter SDK
echo "🚀 Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Check Flutter version
flutter --version

# Get dependencies
flutter pub get

# Build for web
flutter build web --release

echo "✅ Flutter build completed!"

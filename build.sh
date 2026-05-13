#!/bin/bash

echo "Downloading Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Flutter version:"
flutter --version

echo "Getting packages..."
flutter pub get

echo "Building project..."
flutter build web --release

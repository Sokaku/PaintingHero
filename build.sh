#!/bin/bash
set -e

FLUTTER_VERSION="3.19.6"

echo "⬇️ Downloading Flutter $FLUTTER_VERSION (binary, no git clone)..."
curl -sL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz

echo "📦 Extracting Flutter..."
tar -xf flutter.tar.xz
export PATH="$PATH:$(pwd)/flutter/bin"

echo "✅ Flutter version:"
flutter --version --suppress-analytics

echo "📚 Getting packages..."
flutter pub get

echo "🏗️ Building for web..."
flutter build web --release --no-tree-shake-icons

echo "✅ Build complete!"

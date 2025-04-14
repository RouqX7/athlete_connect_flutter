#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🔧 Running Firebase setup script..."

# Run your Dart script to generate google-services.json
dart run tool/firebase_setup.dart

echo "✅ Firebase setup completed."
echo "🚀 Running Flutter app..."

# Now run your Flutter app
flutter run -v

#!/bin/bash

echo "========================================"
echo "  Import HP ke Firebase dan Run App"
echo "========================================"
echo ""

echo "[1/3] Checking dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to get dependencies"
    exit 1
fi
echo ""

echo "[2/3] Importing smartphones to Firebase..."
dart run scripts/import_to_firestore.dart
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to import data"
    exit 1
fi
echo ""

echo "[3/3] Starting Flutter app..."
echo ""
echo "Choose platform:"
echo "1. Web (Chrome)"
echo "2. Android"
echo "3. Windows"
echo ""
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        flutter run -d chrome
        ;;
    2)
        flutter run
        ;;
    3)
        flutter run -d windows
        ;;
    *)
        echo "Invalid choice. Running on Chrome by default..."
        flutter run -d chrome
        ;;
esac


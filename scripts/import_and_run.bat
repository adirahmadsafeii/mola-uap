@echo off
echo ========================================
echo   Import HP ke Firebase dan Run App
echo ========================================
echo.

echo [1/3] Checking dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b 1
)
echo.

echo [2/3] Importing smartphones to Firebase...
dart run scripts/import_to_firestore.dart
if %errorlevel% neq 0 (
    echo ERROR: Failed to import data
    pause
    exit /b 1
)
echo.

echo [3/3] Starting Flutter app...
echo.
echo Choose platform:
echo 1. Web (Chrome)
echo 2. Android
echo 3. Windows
echo.
set /p choice="Enter choice (1-3): "

if "%choice%"=="1" (
    flutter run -d chrome
) else if "%choice%"=="2" (
    flutter run
) else if "%choice%"=="3" (
    flutter run -d windows
) else (
    echo Invalid choice. Running on Chrome by default...
    flutter run -d chrome
)

pause


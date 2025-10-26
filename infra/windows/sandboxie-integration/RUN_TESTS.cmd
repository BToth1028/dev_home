@echo off
echo ========================================
echo Sandboxie Integration v1.0 - Test Suite
echo ========================================
echo.

cd /d "%~dp0"

echo Running automated tests...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "TEST_SUITE.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo All tests PASSED!
    echo Package is ready to use.
    echo ========================================
    pause
    exit /b 0
) else (
    echo.
    echo ========================================
    echo Some tests FAILED!
    echo Review errors above.
    echo ========================================
    pause
    exit /b 1
)


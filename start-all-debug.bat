@echo off

echo.
echo Starting Project Context OS (DEBUG MODE)
echo =========================================
echo.
echo Press any key to start...
pause

:: Test 1: Check current directory
echo.
echo TEST 1: Current Directory
cd
echo.

:: Test 2: Check if Docker Desktop exists
echo TEST 2: Docker Desktop Path
if exist "C:\Program Files\Docker\Docker\Docker Desktop.exe" (
    echo   Found: Docker Desktop exists
) else (
    echo   Not Found: Docker Desktop does not exist
)
echo.

:: Test 3: Check if Docker is running
echo TEST 3: Docker Status
docker info >nul 2>&1
if %errorlevel% equ 0 (
    echo   Docker is running
) else (
    echo   Docker is NOT running
)
echo.

:: Test 4: Check Python venv
echo TEST 4: Python Virtual Environment
if exist "C:\DEV\.venv\Scripts\activate.bat" (
    echo   Found: Python venv exists
) else (
    echo   Not Found: Python venv does not exist
)
echo.

:: Test 5: Check Backstage
echo TEST 5: Backstage
if exist "C:\DEV\backstage\package.json" (
    echo   Found: Backstage exists
) else (
    echo   Not Found: Backstage does not exist
)
echo.

:: Test 6: Check Sourcegraph
echo TEST 6: Sourcegraph
if exist "C:\DEV\sourcegraph\docker-compose.yaml" (
    echo   Found: Sourcegraph config exists
) else (
    echo   Not Found: Sourcegraph config does not exist
)
echo.

echo =========================================
echo Tests Complete!
echo =========================================
echo.
echo This window will stay open so you can see the results.
echo Press any key to close...
pause

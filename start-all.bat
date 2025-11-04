@echo off
setlocal enabledelayedexpansion

:: Start Everything - Project Context OS
:: =====================================

echo.
echo ================================================
echo   Starting Project Context OS
echo ================================================
echo.

:: Check if Docker Desktop is running
echo [1/5] Checking Docker Desktop...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo   Docker Desktop is not running. Please start it first.
    echo   After Docker Desktop starts, run this again.
    echo.
    pause
    exit /b 1
)
echo   Docker Desktop is running!
echo.

:: Start MkDocs
echo [2/5] Starting MkDocs (Documentation Portal)...
cd /d C:\DEV
if exist ".venv\Scripts\activate.bat" (
    start "MkDocs Server" cmd /k "cd /d C:\DEV && .venv\Scripts\activate.bat && mkdocs serve"
    echo   MkDocs starting on http://localhost:8000
) else (
    echo   Warning: Python venv not found at C:\DEV\.venv
    echo   Run: python -m venv .venv
    echo   Then: .venv\Scripts\pip install mkdocs-material
)
echo.

:: Start Sourcegraph
echo [3/5] Starting Sourcegraph (Code Search)...
cd /d C:\DEV\sourcegraph
start "Sourcegraph" cmd /k "docker compose up"
echo   Sourcegraph starting on http://localhost:7080
echo   (This takes 2-3 minutes to fully start)
echo.

:: Start Structurizr
echo [4/5] Starting Structurizr (Architecture Diagrams)...
cd /d C:\DEV\docs\architecture\c4
start "Structurizr" cmd /k "docker run -it --rm -p 8081:8080 -v %cd%:/usr/local/structurizr structurizr/lite"
echo   Structurizr starting on http://localhost:8081
echo.

:: Start Backstage
echo [5/5] Starting Backstage (Service Catalog)...
cd /d C:\DEV\backstage
if exist "package.json" (
    start "Backstage" cmd /k "yarn dev"
    echo   Backstage starting on http://localhost:7007
    echo   (Frontend on http://localhost:3000)
) else (
    echo   Warning: Backstage not found at C:\DEV\backstage
    echo   Run: npx @backstage/create-app@latest
)
echo.

:: Summary
echo.
echo ================================================
echo   All services are starting!
echo ================================================
echo.
echo   Please wait 30-60 seconds for services to be ready...
echo.
echo   Service Windows:
echo   - 4 terminal windows opened (one per service)
echo   - Do NOT close those windows
echo   - Services run in those windows
echo.
echo   URLs (will be ready soon):
echo   - Documentation:   http://localhost:8000
echo   - Service Catalog: http://localhost:7007
echo   - Code Search:     http://localhost:7080  (slowest - 2-3 min)
echo   - Architecture:    http://localhost:8081
echo.
echo   To check status: Run status-check.bat
echo   To stop all:     Run stop-all.bat
echo.

:: Ask if user wants to open browsers
set /p OPEN_BROWSERS="Open all portals in browser now? (y/n): "
if /i "%OPEN_BROWSERS%"=="y" (
    echo.
    echo Opening browsers in 10 seconds...
    echo (Give services time to start)
    timeout /t 10 /nobreak >nul
    start http://localhost:8000
    timeout /t 2 /nobreak >nul
    start http://localhost:7007
    timeout /t 2 /nobreak >nul
    start http://localhost:7080
    timeout /t 2 /nobreak >nul
    start http://localhost:8081
    echo   All portals opened!
)

echo.
echo ================================================
echo   Startup complete!
echo ================================================
echo.
echo   This window will close in 5 seconds...
echo   Check the other terminal windows for service output.
echo.
timeout /t 5 /nobreak >nul

endlocal

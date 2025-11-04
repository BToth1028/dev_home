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
    echo   Docker Desktop is not running.
    echo   Starting Docker Desktop now...
    echo.
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    
    echo   Waiting for Docker to start (this takes 30-90 seconds)...
    echo   Please be patient...
    echo.
    
    :: Wait for Docker to be ready (up to 3 minutes)
    set /a counter=0
    :wait_docker
    timeout /t 5 /nobreak >nul
    set /a counter+=1
    
    docker info >nul 2>&1
    if %errorlevel% neq 0 (
        if %counter% LSS 36 (
            echo   Still waiting... (%counter% of 36 checks)
            goto wait_docker
        ) else (
            echo.
            echo   ERROR: Docker Desktop did not start in time.
            echo   Please start Docker Desktop manually and try again.
            echo.
            pause
            exit /b 1
        )
    )
    echo.
    echo   Docker Desktop is ready!
) else (
    echo   Docker Desktop is already running!
)
echo.

:: Start MkDocs
echo [2/5] Starting MkDocs (Documentation Portal)...
cd /d C:\DEV
if exist ".venv\Scripts\activate.bat" (
    start "MkDocs Server" cmd /k "cd /d C:\DEV && .venv\Scripts\activate.bat && mkdocs serve"
    echo   MkDocs starting on http://localhost:8000
) else (
    echo   Warning: Python venv not found at C:\DEV\.venv
    echo   Skipping MkDocs. To set up:
    echo     python -m venv .venv
    echo     .venv\Scripts\pip install mkdocs-material
)
echo.

:: Start Sourcegraph
echo [3/5] Starting Sourcegraph (Code Search)...
cd /d C:\DEV\sourcegraph
if exist "docker-compose.yaml" (
    start "Sourcegraph" cmd /k "docker compose up"
    echo   Sourcegraph starting on http://localhost:7080
    echo   (This takes 2-3 minutes to fully start)
) else (
    echo   Warning: Sourcegraph config not found
)
echo.

:: Start Structurizr
echo [4/5] Starting Structurizr (Architecture Diagrams)...
cd /d C:\DEV\docs\architecture\c4
if exist "workspace.dsl" (
    start "Structurizr" cmd /k "docker run -it --rm -p 8081:8080 -v %cd%:/usr/local/structurizr structurizr/lite"
    echo   Structurizr starting on http://localhost:8081
) else (
    echo   Warning: Structurizr DSL not found
)
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
    echo   To install: npx @backstage/create-app@latest
)
echo.

:: Summary
echo.
echo ================================================
echo   All services are starting!
echo ================================================
echo.
echo   Please wait 60-90 seconds for all services to be ready...
echo.
echo   4 Terminal Windows Opened:
echo   - MkDocs Server
echo   - Sourcegraph
echo   - Structurizr
echo   - Backstage
echo.
echo   Do NOT close those windows! Services run in them.
echo.
echo   URLs (ready in ~60 seconds):
echo   - Documentation:   http://localhost:8000
echo   - Service Catalog: http://localhost:7007
echo   - Code Search:     http://localhost:7080  (slowest)
echo   - Architecture:    http://localhost:8081
echo.

:: Ask if user wants to open browsers
set /p OPEN_BROWSERS="Open all portals in browser? (y/n): "
if /i "%OPEN_BROWSERS%"=="y" (
    echo.
    echo Opening browsers in 15 seconds...
    echo (Giving services time to start)
    timeout /t 15 /nobreak >nul
    start http://localhost:8000
    timeout /t 2 /nobreak >nul
    start http://localhost:7007
    timeout /t 2 /nobreak >nul
    start http://localhost:7080
    timeout /t 2 /nobreak >nul
    start http://localhost:8081
    echo   All portals opened in browser!
)

echo.
echo ================================================
echo   Startup Complete!
echo ================================================
echo.
echo   Check status: Double-click "Check Context OS Status"
echo   Stop all:     Double-click "Stop Project Context OS"
echo.
echo   This window will close in 10 seconds...
echo   (Service windows will stay open)
echo.
timeout /t 10 /nobreak >nul

endlocal

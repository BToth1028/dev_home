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
    echo Docker Desktop is not running. Starting it now...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo Waiting for Docker to start (this takes 30-60 seconds)...
    
    :: Wait for Docker to be ready
    :wait_docker
    timeout /t 5 /nobreak >nul
    docker info >nul 2>&1
    if %errorlevel% neq 0 (
        echo   Still waiting...
        goto wait_docker
    )
    echo   Docker Desktop is ready!
) else (
    echo   Docker Desktop is already running
)
echo.

:: Start MkDocs
echo [2/5] Starting MkDocs (Documentation Portal)...
cd /d C:\DEV
start "MkDocs Server" cmd /k ".\.venv\Scripts\Activate.ps1; mkdocs serve"
timeout /t 2 /nobreak >nul
echo   MkDocs starting on http://localhost:8000
echo.

:: Start Sourcegraph
echo [3/5] Starting Sourcegraph (Code Search)...
cd /d C:\DEV\sourcegraph
start "Sourcegraph" cmd /k "docker compose up"
timeout /t 3 /nobreak >nul
echo   Sourcegraph starting on http://localhost:7080
echo.

:: Start Structurizr
echo [4/5] Starting Structurizr (Architecture Diagrams)...
cd /d C:\DEV\docs\architecture\c4
start "Structurizr" cmd /k "docker run -it --rm -p 8081:8080 -v %cd%:/usr/local/structurizr structurizr/lite"
timeout /t 3 /nobreak >nul
echo   Structurizr starting on http://localhost:8081
echo.

:: Start Backstage
echo [5/5] Starting Backstage (Service Catalog)...
cd /d C:\DEV\backstage
start "Backstage" cmd /k "yarn dev"
timeout /t 3 /nobreak >nul
echo   Backstage starting on http://localhost:7007
echo.

:: Wait for services to start
echo.
echo ================================================
echo   All services are starting!
echo ================================================
echo.
echo   Please wait 30-60 seconds for all services to be ready...
echo.
echo   URLs:
echo   - Documentation:  http://localhost:8000
echo   - Service Catalog: http://localhost:7007
echo   - Code Search:    http://localhost:7080
echo   - Architecture:   http://localhost:8081
echo.

:: Ask if user wants to open browsers
echo.
set /p OPEN_BROWSERS="Open all portals in browser? (y/n): "
if /i "%OPEN_BROWSERS%"=="y" (
    echo Opening browsers...
    timeout /t 5 /nobreak >nul
    start http://localhost:8000
    start http://localhost:7007
    start http://localhost:7080
    start http://localhost:8081
    echo   All portals opened!
)

echo.
echo ================================================
echo   Project Context OS is running!
echo ================================================
echo.
echo   Press any key to exit this window...
echo   (Services will keep running in their own windows)
echo.
pause >nul

endlocal


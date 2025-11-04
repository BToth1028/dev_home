@echo off

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
    
    echo   Waiting for Docker to start...
    echo   (This takes 30-90 seconds - please be patient)
    echo.
    
    :: Wait for Docker to be ready (check every 5 seconds, up to 3 minutes)
    set /a counter=0
    :wait_docker
    timeout /t 5 /nobreak >nul
    set /a counter+=1
    
    docker info >nul 2>&1
    if %errorlevel% neq 0 (
        if %counter% LSS 36 (
            echo   Still waiting for Docker... (check %counter% of 36)
            goto wait_docker
        ) else (
            echo.
            echo   ERROR: Docker Desktop did not start in time.
            echo   Please start Docker Desktop manually and run this again.
            echo.
            echo   Press any key to exit...
            pause >nul
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
    timeout /t 2 /nobreak >nul
    echo   Started: MkDocs on http://localhost:8000
) else (
    echo   Skipped: Python venv not found
)
echo.

:: Start Sourcegraph
echo [3/5] Starting Sourcegraph (Code Search)...
cd /d C:\DEV\sourcegraph
if exist "docker-compose.yaml" (
    start "Sourcegraph" cmd /k "docker compose up"
    timeout /t 3 /nobreak >nul
    echo   Started: Sourcegraph on http://localhost:7080
    echo   (Takes 2-3 minutes to fully start)
) else (
    echo   Skipped: Sourcegraph config not found
)
echo.

:: Start Structurizr
echo [4/5] Starting Structurizr (Architecture Diagrams)...
cd /d C:\DEV\docs\architecture\c4
if exist "workspace.dsl" (
    start "Structurizr" cmd /k "docker run -it --rm -p 8081:8080 -v %cd%:/usr/local/structurizr structurizr/lite"
    timeout /t 3 /nobreak >nul
    echo   Started: Structurizr on http://localhost:8081
) else (
    echo   Skipped: Structurizr DSL not found
)
echo.

:: Start Backstage
echo [5/5] Starting Backstage (Service Catalog)...
cd /d C:\DEV\backstage
if exist "package.json" (
    start "Backstage" cmd /k "yarn dev"
    timeout /t 3 /nobreak >nul
    echo   Started: Backstage on http://localhost:7007
) else (
    echo   Skipped: Backstage not found
)
echo.

:: Summary
echo.
echo ================================================
echo   All Services Started!
echo ================================================
echo.
echo   4 Terminal Windows Opened:
echo   - MkDocs Server
echo   - Sourcegraph  
echo   - Structurizr
echo   - Backstage
echo.
echo   Do NOT close those windows!
echo   Services run in those separate windows.
echo.
echo   Wait 60-90 seconds for everything to be ready, then open:
echo.
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
    timeout /t 15 /nobreak >nul
    start http://localhost:8000
    timeout /t 2 /nobreak >nul
    start http://localhost:7007
    timeout /t 2 /nobreak >nul
    start http://localhost:7080
    timeout /t 2 /nobreak >nul
    start http://localhost:8081
    echo   Browsers opened!
)

echo.
echo ================================================
echo   Ready!
echo ================================================
echo.
echo   This window will close in 5 seconds...
echo.
timeout /t 5 /nobreak >nul

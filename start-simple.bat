@echo off
echo.
echo ================================================
echo   Starting Project Context OS (Simple Version)
echo ================================================
echo.

:: Check if Docker is running
echo Checking Docker status...
docker info >nul 2>&1
if %errorlevel% equ 0 (
    echo Docker is already running!
    goto start_services
)

:: Docker not running - start it
echo Docker is not running. Starting it now...
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
echo.
echo Waiting for Docker to be ready...
echo (Checking every 3 seconds)
echo.

:: Check every 3 seconds until Docker is ready
set /a counter=0
:check_docker
set /a counter+=1
timeout /t 3 /nobreak >nul

docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo   Check %counter%: Docker not ready yet...
    if %counter% LSS 40 goto check_docker
    echo.
    echo ERROR: Docker did not start after 2 minutes.
    echo Please start Docker Desktop manually.
    pause
    exit /b 1
)

echo.
echo Docker is ready!
echo.

:start_services
echo ================================================
echo   Starting Services
echo ================================================
echo.

echo [1/4] Starting MkDocs...
start "MkDocs" cmd /k "cd C:\DEV && .venv\Scripts\activate.bat && mkdocs serve"
timeout /t 2 /nobreak >nul

echo [2/4] Starting Sourcegraph...
start "Sourcegraph" cmd /k "cd C:\DEV\sourcegraph && docker compose up"
timeout /t 2 /nobreak >nul

echo [3/4] Starting Structurizr...
start "Structurizr" cmd /k "cd C:\DEV\docs\architecture\c4 && docker run -it --rm -p 8081:8080 -v %cd%:/usr/local/structurizr structurizr/lite"
timeout /t 2 /nobreak >nul

echo [4/4] Starting Backstage...
start "Backstage" cmd /k "cd C:\DEV\backstage && yarn dev"
timeout /t 2 /nobreak >nul

echo.
echo ================================================
echo   All Services Started!
echo ================================================
echo.
echo 4 terminal windows opened (one per service)
echo Do NOT close those windows!
echo.
echo Wait 60-90 seconds, then open:
echo   http://localhost:8000 - Documentation
echo   http://localhost:7007 - Backstage  
echo   http://localhost:7080 - Sourcegraph
echo   http://localhost:8081 - Structurizr
echo.
echo Press any key to close this window...
pause >nul

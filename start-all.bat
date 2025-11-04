@echo off

:: Start Everything - Project Context OS
:: =====================================

echo.
echo ================================================
echo   Starting Project Context OS
echo ================================================
echo.

:: Check prerequisites
echo Checking prerequisites...
echo.

:: Check if yarn is installed
where yarn >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Yarn is not installed!
    echo Backstage requires Yarn to run.
    echo.
    echo Install with: npm install -g yarn
    echo.
    set YARN_MISSING=1
) else (
    echo [OK] Yarn is installed
    set YARN_MISSING=0
)

:: Check if Python venv exists
if exist "C:\DEV\.venv\Scripts\activate.bat" (
    echo [OK] Python venv exists
    set VENV_EXISTS=1
) else (
    echo WARNING: Python venv not found
    echo MkDocs will be skipped.
    echo.
    set VENV_EXISTS=0
)

echo.

:: Check if Docker is running
echo Checking Docker status...
docker info >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Docker is already running!
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
    echo Please start Docker Desktop manually and run this again.
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Docker is ready!
echo.

:start_services
echo ================================================
echo   Starting Services
echo ================================================
echo.

:: Start MkDocs
if %VENV_EXISTS% equ 1 (
    echo [1/4] Starting MkDocs...
    start "MkDocs" cmd /k "cd C:\DEV && .venv\Scripts\activate.bat && mkdocs serve"
    timeout /t 2 /nobreak >nul
    echo   Started on http://localhost:8000
) else (
    echo [1/4] Skipping MkDocs (venv not found)
)
echo.

:: Start Sourcegraph
echo [2/4] Starting Sourcegraph...
if exist "C:\DEV\sourcegraph\docker-compose.yaml" (
    start "Sourcegraph" cmd /k "cd C:\DEV\sourcegraph && docker compose up"
    timeout /t 2 /nobreak >nul
    echo   Started on http://localhost:7080
) else (
    echo   WARNING: docker-compose.yaml not found
)
echo.

:: Start Structurizr
echo [3/4] Starting Structurizr...
if exist "C:\DEV\docs\architecture\c4\workspace.dsl" (
    start "Structurizr" cmd /k "cd C:\DEV\docs\architecture\c4 && docker run -it --rm -p 8081:8080 -v %cd%:/usr/local/structurizr structurizr/lite"
    timeout /t 2 /nobreak >nul
    echo   Started on http://localhost:8081
) else (
    echo   WARNING: workspace.dsl not found
)
echo.

:: Start Backstage
if %YARN_MISSING% equ 0 (
    echo [4/4] Starting Backstage...
    if exist "C:\DEV\backstage\package.json" (
        start "Backstage" cmd /k "cd C:\DEV\backstage && yarn dev"
        timeout /t 2 /nobreak >nul
        echo   Started on http://localhost:7007
    ) else (
        echo   WARNING: Backstage not found
    )
) else (
    echo [4/4] Skipping Backstage (Yarn not installed)
    echo   To install Yarn: npm install -g yarn
)
echo.

:: Summary
echo ================================================
echo   Startup Complete!
echo ================================================
echo.
echo Services Running:
if %VENV_EXISTS% equ 1 (
    echo   - MkDocs:      http://localhost:8000
)
echo   - Sourcegraph: http://localhost:7080 (takes 2-3 min)
echo   - Structurizr: http://localhost:8081
if %YARN_MISSING% equ 0 (
    echo   - Backstage:   http://localhost:7007
)
echo.
echo Check the other terminal windows for service output.
echo Do NOT close those windows!
echo.

:: Show fixes if needed
if %YARN_MISSING% equ 1 (
    echo.
    echo TO FIX BACKSTAGE:
    echo   npm install -g yarn
    echo.
)

if %VENV_EXISTS% equ 0 (
    echo.
    echo TO FIX MKDOCS:
    echo   cd C:\DEV
    echo   python -m venv .venv
    echo   .venv\Scripts\pip install mkdocs-material
    echo.
)

:: Ask if user wants to open browsers
set /p OPEN_BROWSERS="Open all portals in browser? (y/n): "
if /i "%OPEN_BROWSERS%"=="y" (
    echo.
    echo Opening browsers in 10 seconds...
    timeout /t 10 /nobreak >nul
    if %VENV_EXISTS% equ 1 start http://localhost:8000
    timeout /t 1 /nobreak >nul
    if %YARN_MISSING% equ 0 start http://localhost:7007
    timeout /t 1 /nobreak >nul
    start http://localhost:7080
    timeout /t 1 /nobreak >nul
    start http://localhost:8081
    echo   Browsers opened!
)

echo.
echo This window will close in 5 seconds...
timeout /t 5 /nobreak >nul

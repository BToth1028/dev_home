@echo off

:: Check Status - Project Context OS
:: ===================================

echo.
echo ================================================
echo   Project Context OS - Status Check
echo ================================================
echo.

:: Check MkDocs
echo [1/5] MkDocs (Documentation Portal)
netstat -ano | findstr :8000 >nul 2>&1
if %errorlevel% equ 0 (
    echo   Status: RUNNING
    echo   URL:    http://localhost:8000
) else (
    echo   Status: NOT RUNNING
)
echo.

:: Check Backstage Frontend
echo [2/5] Backstage Frontend
netstat -ano | findstr :3000 >nul 2>&1
if %errorlevel% equ 0 (
    echo   Status: RUNNING
    echo   URL:    http://localhost:3000
) else (
    echo   Status: NOT RUNNING
)
echo.

:: Check Backstage Backend
echo [3/5] Backstage Backend
netstat -ano | findstr :7007 >nul 2>&1
if %errorlevel% equ 0 (
    echo   Status: RUNNING
    echo   URL:    http://localhost:7007
) else (
    echo   Status: NOT RUNNING
)
echo.

:: Check Sourcegraph
echo [4/5] Sourcegraph (Code Search)
netstat -ano | findstr :7080 >nul 2>&1
if %errorlevel% equ 0 (
    echo   Status: RUNNING
    echo   URL:    http://localhost:7080
) else (
    echo   Status: NOT RUNNING
)
echo.

:: Check Structurizr
echo [5/5] Structurizr (Architecture Diagrams)
netstat -ano | findstr :8081 >nul 2>&1
if %errorlevel% equ 0 (
    echo   Status: RUNNING
    echo   URL:    http://localhost:8081
) else (
    echo   Status: NOT RUNNING
)
echo.

:: Check Docker
echo [*] Docker Desktop
docker info >nul 2>&1
if %errorlevel% equ 0 (
    echo   Status: RUNNING
) else (
    echo   Status: NOT RUNNING
)
echo.

echo ================================================
echo   Status check complete
echo ================================================
echo.
pause


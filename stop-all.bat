@echo off

:: Stop Everything - Project Context OS
:: =====================================

echo.
echo ================================================
echo   Stopping Project Context OS
echo ================================================
echo.

:: Stop MkDocs (find and kill the process)
echo [1/4] Stopping MkDocs...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8000') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo   MkDocs stopped

:: Stop Backstage (find and kill the process)
echo [2/4] Stopping Backstage...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :7007') do (
    taskkill /F /PID %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo   Backstage stopped

:: Stop Docker containers
echo [3/4] Stopping Docker containers...
cd /d C:\DEV\sourcegraph
docker compose down >nul 2>&1
docker stop structurizr >nul 2>&1
docker rm structurizr >nul 2>&1
echo   Docker containers stopped

:: Close terminal windows
echo [4/4] Closing service windows...
taskkill /FI "WindowTitle eq MkDocs*" /F >nul 2>&1
taskkill /FI "WindowTitle eq Backstage*" /F >nul 2>&1
taskkill /FI "WindowTitle eq Sourcegraph*" /F >nul 2>&1
taskkill /FI "WindowTitle eq Structurizr*" /F >nul 2>&1
echo   Service windows closed

echo.
echo ================================================
echo   All services stopped!
echo ================================================
echo.
pause


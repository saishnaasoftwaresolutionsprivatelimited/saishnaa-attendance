@echo off
cd /d "%~dp0"
start "Saishnaa Backend" cmd /k "cd /d "%~dp0backend" && npm run dev"
timeout /t 3 /nobreak >nul
start "Saishnaa Frontend" cmd /k "cd /d "%~dp0frontend" && npm run dev"
timeout /t 3 /nobreak >nul
start "" http://localhost:5173/

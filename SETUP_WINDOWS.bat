@echo off
setlocal
cd /d "%~dp0"
echo =============================================
echo SAISHNAA Attendance System - First Time Setup
echo =============================================
echo.
echo [1/2] Installing and preparing backend...
cd backend
call npm install
if errorlevel 1 goto :error
call npx prisma generate
if errorlevel 1 goto :error
call npx prisma db push
if errorlevel 1 goto :error
call npm run prisma:seed
if errorlevel 1 goto :error
cd ..
echo.
echo [2/2] Installing frontend...
cd frontend
call npm install
if errorlevel 1 goto :error
cd ..
echo.
echo Setup completed successfully.
echo Use START_SAISHNAA.bat to run the application.
pause
exit /b 0
:error
echo.
echo Setup stopped because a command failed. Copy the error shown above.
pause
exit /b 1

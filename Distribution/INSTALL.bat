@echo off
REM Decibel Meter Installation Batch Script
REM This is a simple alternative to the PowerShell script
REM For advanced options, use INSTALL.ps1 (PowerShell)

setlocal enabledelayedexpansion

echo.
echo ============================================================
echo     Decibel Meter - Windows Installation
echo ============================================================
echo.

REM Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Administrator privileges required
    echo.
    echo Please run this script as Administrator:
    echo   1. Right-click on Command Prompt
    echo   2. Select "Run as administrator"
    echo   3. Navigate to this folder and run: %0
    echo.
    pause
    exit /b 1
)

REM Install certificate
echo Installing certificate...
powershell -Command "Import-PfxCertificate -FilePath '%CD%\devcert.pfx' -CertStoreLocation 'Cert:\LocalMachine\Root' -Password (ConvertTo-SecureString -String 'password' -AsPlainText -Force) -ErrorAction SilentlyContinue" >nul 2>&1

if %errorlevel% equ 0 (
    echo [OK] Certificate installed
) else (
    echo [WARNING] Certificate installation may have failed
)

REM Install MSIX package
echo Installing MSIX package...
powershell -Command "Add-AppxPackage -Path '%CD%\DecibelMeter.msix' -ErrorAction Stop" >nul 2>&1

if %errorlevel% equ 0 (
    echo [OK] MSIX package installed successfully
    echo.
    echo ============================================================
    echo Installation Complete!
    echo.
    echo Launch the app from:
    echo   - Windows Start Menu (search: 'Decibel Meter')
    echo   - Windows Settings ^> Apps
    echo ============================================================
    echo.
    timeout /t 3 /nobreak
) else (
    echo [ERROR] Failed to install MSIX package
    echo.
    echo Troubleshooting:
    echo   - Ensure you're running as Administrator
    echo   - Check if the certificate was installed properly
    echo   - Verify DecibelMeter.msix file exists
    echo.
    pause
    exit /b 1
)

endlocal

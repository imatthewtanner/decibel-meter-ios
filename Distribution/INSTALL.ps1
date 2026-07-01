# Decibel Meter Installation Script
# This script installs the Decibel Meter Windows app
# Requires: Windows 10 (build 18362+) or Windows 11

param(
    [switch]$SkipCertInstall = $false,
    [switch]$Quiet = $false
)

function Write-Header {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║         Decibel Meter - Windows Installation             ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Check-Admin {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host "⚠️  ADMINISTRATOR REQUIRED" -ForegroundColor Yellow
        Write-Host "This script needs to run as Administrator to install the certificate." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Please re-run this script as Administrator:" -ForegroundColor Yellow
        Write-Host "  1. Right-click on PowerShell" -ForegroundColor Yellow
        Write-Host "  2. Select 'Run as administrator'" -ForegroundColor Yellow
        Write-Host "  3. Run this script again" -ForegroundColor Yellow
        exit 1
    }
}

function Install-Certificate {
    $certPath = Join-Path $PSScriptRoot "devcert.pfx"
    
    if (-not (Test-Path $certPath)) {
        Write-Host "❌ Certificate not found: $certPath" -ForegroundColor Red
        exit 1
    }
    
    if (-not $Quiet) {
        Write-Host "📋 Installing development certificate..." -ForegroundColor Cyan
    }
    
    try {
        $securePassword = ConvertTo-SecureString -String "password" -AsPlainText -Force
        $cert = Import-PfxCertificate -FilePath $certPath `
            -CertStoreLocation "Cert:\LocalMachine\Root" `
            -Password $securePassword `
            -ErrorAction Stop
        
        Write-Host "✅ Certificate installed successfully" -ForegroundColor Green
        Write-Host "   Thumbprint: $($cert.Thumbprint)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Failed to install certificate:" -ForegroundColor Red
        Write-Host "   $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Troubleshooting:" -ForegroundColor Yellow
        Write-Host "  - Ensure you're running as Administrator" -ForegroundColor Yellow
        Write-Host "  - Some antivirus may block certificate installation" -ForegroundColor Yellow
        Write-Host "  - Ensure the certificate file is not corrupted" -ForegroundColor Yellow
        return $false
    }
}

function Install-MSIX {
    $msixPath = Join-Path $PSScriptRoot "DecibelMeter.msix"
    
    if (-not (Test-Path $msixPath)) {
        Write-Host "❌ MSIX package not found: $msixPath" -ForegroundColor Red
        exit 1
    }
    
    if (-not $Quiet) {
        Write-Host "📦 Installing Decibel Meter MSIX package..." -ForegroundColor Cyan
    }
    
    try {
        Add-AppxPackage -Path $msixPath -ErrorAction Stop
        Write-Host "✅ MSIX package installed successfully" -ForegroundColor Green
        return $true
    }
    catch {
        $errorMsg = $_.Exception.Message
        if ($errorMsg -like "*0x80073CF3*" -or $errorMsg -like "*signature*") {
            Write-Host "❌ Certificate not trusted or not installed" -ForegroundColor Red
            Write-Host "   Please run this script again (certificate must be installed first)" -ForegroundColor Red
        }
        elseif ($errorMsg -like "*0x80073CF9*" -or $errorMsg -like "*already installed*") {
            Write-Host "ℹ️  Decibel Meter is already installed" -ForegroundColor Yellow
            Write-Host "   To reinstall, first uninstall via Settings > Apps" -ForegroundColor Yellow
        }
        else {
            Write-Host "❌ Failed to install MSIX:" -ForegroundColor Red
            Write-Host "   $_" -ForegroundColor Red
        }
        return $false
    }
}

function Launch-App {
    Write-Host "🚀 Launching Decibel Meter..." -ForegroundColor Green
    Start-Sleep -Milliseconds 1000
    
    try {
        Start-Process -FilePath explorer.exe -ArgumentList "shell:appsFolder\decibelmeter.windows_1.0.0.0_x64__1234567890abc!App"
    }
    catch {
        Write-Host "ℹ️  You can launch the app from:" -ForegroundColor Cyan
        Write-Host "   - Windows Start Menu: Search for 'Decibel Meter'" -ForegroundColor Cyan
        Write-Host "   - Windows Settings > Apps" -ForegroundColor Cyan
    }
}

function Show-Success {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║        ✅ Installation Complete!                         ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can now launch Decibel Meter from:" -ForegroundColor Green
    Write-Host "  • Windows Start Menu (search: 'Decibel Meter')" -ForegroundColor Green
    Write-Host "  • Windows Settings > Apps > Decibel Meter" -ForegroundColor Green
    Write-Host ""
    Write-Host "Quick Start:" -ForegroundColor Cyan
    Write-Host "  1. Click 'Start' to begin measuring sound level" -ForegroundColor Cyan
    Write-Host "  2. View real-time dB reading and chart" -ForegroundColor Cyan
    Write-Host "  3. Click 'Stop' to save the measurement" -ForegroundColor Cyan
    Write-Host "  4. Use 'Export' to save as CSV" -ForegroundColor Cyan
    Write-Host ""
}

# Main installation flow
Write-Header
Check-Admin

if (-not $SkipCertInstall) {
    if (-not (Install-Certificate)) {
        exit 1
    }
}

if (Install-MSIX) {
    Show-Success
    Launch-App
}
else {
    exit 1
}

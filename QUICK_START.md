# Quick Start Guide - Decibel Meter Windows App

## Installation

### Option 1: Run from Release Build (Local Testing)
```powershell
cd "c:\Users\matthew\Documents\Decibel Meter\DecibelMeter.Windows"
.\bin\Release\net8.0-windows10.0.26100.0\win-x64\DecibelMeter.exe
```

### Option 2: Install MSIX Package (Distribution)
```powershell
# Step 1: Install the development certificate (admin required)
cd "c:\Users\matthew\Documents\Decibel Meter\DecibelMeter.Windows"
winapp cert install ./devcert.pfx

# Step 2: Install the MSIX package
# Option A: Double-click DecibelMeter.msix in Explorer
# Option B: Use PowerShell (admin required):
Add-AppxPackage -Path ".\DecibelMeter.msix"
```

Once installed via MSIX, launch from:
- Windows Start Menu → "Decibel Meter"
- Windows Settings → Apps → Decibel Meter → Launch

## Usage

### Measuring Sound Level
1. **Start Measurement**: Click blue "Start" button in Meter tab
2. **View Level**: See real-time dB reading (updates ~10x per second)
3. **Watch Chart**: Real-time chart shows last 100 measurements
4. **Stop**: Click red "Stop" button to end measurement
   - Measurement is automatically saved to history
   - Chart is cleared for next measurement

### Alerts & Notifications
1. **Settings Tab** → Enable Alerts checkbox
2. Set Alert Threshold slider (60-100 dB range)
3. When live measurement exceeds threshold, see status message

### Export Data
**From Current Measurement**:
- Click "Export Data" button in Meter tab
- File saved to: `Documents\DecibelMeter_Measurements_YYYY-MM-DD_HH-mm-ss.csv`

**From All History**:
- History tab → Click "Export All" button
- Same filename pattern, includes all recorded sessions

**CSV File Format**:
```
Date,Time,Duration,Minimum,Average,Peak
07/01/2024,12:08:00,00:10:23,45.3,62.1,78.5
07/01/2024,12:20:15,00:15:45,42.1,58.9,81.2
```

### View History
1. History tab → Shows all recorded measurements
2. Click delete button to remove individual session
3. Click "Clear All" to delete all sessions
4. Each session shows: Date, Time, Duration, Min/Avg/Peak levels

### Calibration
1. Settings tab → Calibration Offset slider
2. Compare your readings to a reference meter
3. Adjust offset up/down until readings match
4. Default offset: 0 dB

### Dark Mode
1. Settings tab → Enable dark mode checkbox
2. Click "Apply Theme" button
3. UI switches between Light and Dark themes

## File Locations

| Item | Location |
|------|----------|
| **Measurements DB** | `%AppData%\DecibelMeter\measurements.json` |
| **Exported CSV** | `%UserProfile%\Documents\DecibelMeter_Measurements_*.csv` |
| **MSIX Package** | `c:\Users\matthew\Documents\Decibel Meter\DecibelMeter.Windows\DecibelMeter.msix` |
| **App Executable (Release)** | `c:\Users\matthew\Documents\Decibel Meter\DecibelMeter.Windows\bin\Release\...` |

## Troubleshooting

### "MSIX installation failed"
- **Cause**: Certificate not installed
- **Solution**: Run `winapp cert install ./devcert.pfx` as Administrator first

### "Microphone not detected"
- **Cause**: Windows permission or no microphone device available
- **Solution**: 
  - Check Windows Settings → Privacy & Security → Microphone (enable for DecibelMeter)
  - Verify microphone is connected and working

### "App shows 0 dB constantly"
- **Cause**: Microphone issue or too quiet
- **Solution**: 
  - Test microphone in Windows Sound Settings
  - Ensure room has ambient sound (app measures live audio)
  - Check microphone volume is not muted

### "Can't export file"
- **Cause**: Permissions or Documents folder issue
- **Solution**: Ensure Documents folder exists and is writable

## Rebuild from Source

### Full Clean Build
```powershell
cd "c:\Users\matthew\Documents\Decibel Meter\DecibelMeter.Windows"
dotnet clean
dotnet build -c Release
```

### Rebuild MSIX Only (after code changes)
```powershell
dotnet build -c Release
winapp package ./bin/Release/net8.0-windows10.0.26100.0/win-x64 \
  --cert ./devcert.pfx \
  --output DecibelMeter.msix
```

## For Development / Testing

### Run with Debug Output
```powershell
cd "c:\Users\matthew\Documents\Decibel Meter\DecibelMeter.Windows"
dotnet run --configuration Debug
```

### Modify & Rebuild
1. Edit source files (`.cs` or `.xaml`)
2. Save changes
3. Press Ctrl+Shift+B in VS Code (or run `dotnet build`)
4. Restart app to see changes

### Package for New Certificate (if needed)
```powershell
# Generate new certificate
winapp cert generate --manifest ./Package.appxmanifest \
  --output devcert_new.pfx \
  --password password

# Update manifest if publisher name changed (edit Package.appxmanifest manually)

# Rebuild MSIX with new certificate
winapp package ./bin/Release/net8.0-windows10.0.26100.0/win-x64 \
  --cert ./devcert_new.pfx \
  --output DecibelMeter.msix
```

## Performance Tips

- **First launch**: App may take 2-3 seconds to start (WPF framework initialization)
- **Large history**: If you have 1000+ recordings, export then clear history to improve performance
- **Chart updates**: Real-time chart is limited to ~100 points for performance (automatic scrolling)

## System Requirements

- **OS**: Windows 10 (build 18362) or later
- **Processor**: Any modern x64 processor
- **RAM**: 100 MB minimum (typical usage)
- **Storage**: 50 MB for app + data
- **Microphone**: Any audio input device
- **.NET Runtime**: Included in MSIX package

## Contact & Support

For issues or enhancement requests, refer to the main project README.md

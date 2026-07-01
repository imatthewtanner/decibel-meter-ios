# Decibel Meter for Windows - Distribution Package

**Version**: 1.0.0  
**Platform**: Windows 10 (build 18362+) / Windows 11  
**Architecture**: x64  
**Size**: ~7.6 MB

---

## 📦 Package Contents

- **DecibelMeter.msix** - The application installer (MSIX format)
- **devcert.pfx** - Development certificate for package signing
- **INSTALL.ps1** - PowerShell installation script (recommended)
- **INSTALL.bat** - Batch file installation script (alternative)
- **README.md** - This file
- **FEATURES.md** - Complete feature list and documentation

---

## ⚡ Quick Installation

### Option 1: Automatic Install (Recommended)

**Windows 11 / PowerShell Users:**
```powershell
# Right-click PowerShell, choose "Run as Administrator", then run:
.\INSTALL.ps1
```

**Windows 10 / Command Prompt Users:**
```cmd
# Right-click Command Prompt, choose "Run as Administrator", then run:
INSTALL.bat
```

### Option 2: Manual Install

**Step 1: Install Certificate** (requires Admin)
```powershell
# Run as Administrator
Import-PfxCertificate -FilePath .\devcert.pfx `
    -CertStoreLocation "Cert:\LocalMachine\Root" `
    -Password (ConvertTo-SecureString -String "password" -AsPlainText -Force)
```

**Step 2: Install Application**
```powershell
Add-AppxPackage -Path .\DecibelMeter.msix
```

**Step 3: Launch**
- Search for "Decibel Meter" in Windows Start Menu
- Or go to Settings > Apps > Decibel Meter > Launch

---

## ✨ Features

**Real-Time Measurement**
- Live sound level measurement in decibels (dB)
- Current, average, and peak level tracking
- Sound level classification (Low/Moderate/High/VeryHigh)

**Data Visualization**
- Real-time scrolling chart of sound levels
- Color-coded display (Green → Yellow → Orange → Red)
- Automatic chart scaling

**Alerts & Notifications**
- Configurable sound level threshold alerts
- Two-tier alert system (85 dB, 100 dB)
- State tracking to prevent alert spam

**Data Management**
- Persistent measurement history
- One-click CSV export
- View and delete individual sessions
- Clear all measurements

**Customization**
- Calibration offset adjustment (±20 dB)
- Dark mode / Light mode toggle
- Enable/disable notifications
- Configurable alert thresholds (60-100 dB)

---

## 🎮 Getting Started

### First Launch

1. **Allow Microphone Access**
   - Windows may ask for microphone permission
   - Click "Yes" to allow Decibel Meter to access your microphone

2. **Main Interface**
   - **Meter Tab** - Live measurement and charting
   - **History Tab** - All recorded measurements
   - **Settings Tab** - Calibration and preferences

### Measuring Sound

1. Click the **Start** button to begin
2. Watch the real-time dB reading update
3. Monitor the live chart for level trends
4. Click **Stop** to end the measurement
5. Your session is automatically saved

### Export Data

- **Current Session**: Click "Export Data" in Meter tab
- **All Sessions**: Click "Export All" in History tab
- **File Location**: `Documents\DecibelMeter_Measurements_YYYY-MM-DD_HH-mm-ss.csv`
- **Format**: CSV with Date, Time, Duration, Min, Avg, Peak

### Calibration

1. Go to Settings tab
2. Use the "Calibration Offset" slider (±20 dB)
3. Compare readings to a reference meter
4. Adjust until readings match
5. Changes apply immediately to new measurements

---

## ❓ Troubleshooting

### Installation Issues

**"Administrator privileges required"**
- Solution: Right-click PowerShell/Command Prompt and select "Run as administrator"

**"Certificate not trusted" or "Invalid signature"**
- Solution: Re-run the installation script to install the certificate first

**"Package is already installed"**
- Solution: Uninstall via Settings > Apps > Decibel Meter, then reinstall

**"MSIX package not found"**
- Solution: Ensure DecibelMeter.msix file is in the same folder as the installation script

---

### Runtime Issues

**"Microphone not detected"**
- Check Windows Settings > Privacy & Security > Microphone is enabled
- Verify your microphone is connected and working
- Test in Windows Sound Settings

**"App shows 0 dB constantly"**
- Microphone may not have permission
- Check Settings > Privacy & Security > Microphone > Decibel Meter is enabled
- Try a different microphone input
- Ensure there is ambient sound to measure

**"Can't export file"**
- Check Documents folder exists and is accessible
- Ensure adequate disk space
- Check file permissions

**"Dark mode not working"**
- Toggle the checkbox in Settings > Appearance > Enable dark mode
- Click "Apply Theme" button
- Some Windows themes may override system theme

---

## 📋 System Requirements

| Requirement | Details |
|---|---|
| **OS** | Windows 10 (build 18362) or later, Windows 11 |
| **Architecture** | x64 processor |
| **RAM** | 100 MB minimum |
| **Storage** | 50 MB for app + data |
| **Microphone** | Any audio input device |
| **Permission** | Administrator for initial installation |

---

## 📁 File Locations

| Item | Location |
|---|---|
| Measurement Database | `%AppData%\DecibelMeter\measurements.json` |
| Exported CSV Files | `%UserProfile%\Documents\DecibelMeter_Measurements_*.csv` |
| Application Data | Windows Apps folder (managed by Windows) |

---

## 🔒 Security & Privacy

- **Local Processing**: All measurements are processed on your local machine
- **No Cloud**: No data is sent to external servers
- **Minimal Permissions**: Only requests microphone access
- **Open Design**: See `FEATURES.md` for complete technical details

---

## 🔧 Advanced Options

### Uninstall

**Using Settings:**
1. Windows Settings > Apps > Apps & features
2. Search for "Decibel Meter"
3. Click it and select "Uninstall"
4. Confirm

**Using PowerShell:**
```powershell
Get-AppxPackage -Name "decibelmeter.windows" | Remove-AppxPackage
```

### Remove Certificate

```powershell
# Run as Administrator
Remove-Item -Path Cert:\LocalMachine\Root\<thumbprint>
```
(Replace `<thumbprint>` with the certificate thumbprint from installation)

### Reinstall Certificate

```powershell
# Run as Administrator
Import-PfxCertificate -FilePath .\devcert.pfx `
    -CertStoreLocation "Cert:\LocalMachine\Root" `
    -Password (ConvertTo-SecureString -String "password" -AsPlainText -Force)
```

---

## 📞 Support

### Reporting Issues

If you encounter problems:
1. Check the Troubleshooting section above
2. Verify system requirements are met
3. Try uninstalling and reinstalling
4. Check for Windows updates

### Feature Requests

Suggestions for improvements welcome! The app is designed to be extensible.

---

## 📜 License & Attribution

- **Application**: Decibel Meter for Windows
- **License**: See LICENSE file in the distribution
- **Built With**:
  - .NET 8.0 Framework
  - WPF (Windows Presentation Foundation)
  - NAudio (audio processing)
  - OxyPlot (charting)
  - CommunityToolkit.Mvvm (MVVM pattern)

---

## 🚀 Next Steps

1. **Install** the application using one of the methods above
2. **Launch** from Windows Start Menu
3. **Configure** settings for your microphone
4. **Start** measuring and tracking sound levels
5. **Export** data for analysis when needed

---

## 📝 Version History

**1.0.0** (Current)
- Initial Windows release
- Real-time measurement and charting
- Data persistence and export
- Dark mode support
- Threshold alerts
- Calibration support

---

**Thank you for using Decibel Meter!**

For the latest updates and information, refer to the technical documentation files included in the source distribution.

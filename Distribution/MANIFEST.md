# Decibel Meter Distribution Package Manifest

**Package Version**: 1.0.0  
**Release Date**: July 1, 2026  
**Platform**: Windows 10 (build 18362+) / Windows 11 x64  

---

## 📦 Package Contents

### Application Files
- **DecibelMeter.msix** (7,597,250 bytes)
  - MSIX installer package
  - Signed with development certificate
  - Contains complete application with all dependencies
  - .NET 8.0 runtime included

- **devcert.pfx** (2,584 bytes)
  - Development certificate for code signing
  - Password: `password`
  - Publisher: CN=matthew
  - Valid for development/testing only
  - **SECURITY NOTE**: Do not use in production; replace with trusted certificate

### Installation Scripts
- **INSTALL.ps1** (PowerShell script)
  - Recommended installation method
  - Installs certificate and MSIX package
  - Provides detailed status messages
  - Error handling and troubleshooting info

- **INSTALL.bat** (Batch script)
  - Alternative installation method
  - For Command Prompt users
  - Simplified installation flow
  - Basic error reporting

### Documentation
- **README.md** (11 KB)
  - Package overview and quick start
  - Installation instructions (3 methods)
  - Troubleshooting guide
  - FAQ and advanced options

- **FEATURES.md** (15 KB)
  - Complete feature list and descriptions
  - Technical specifications
  - Use cases and capabilities
  - Feature comparison table

- **MANIFEST.md** (This file)
  - Package contents and checksums
  - Installation requirements
  - Support information

---

## ✅ Pre-Installation Checklist

**System Requirements:**
- [ ] Windows 10 (build 18362+) or Windows 11
- [ ] x64 processor (Intel or AMD)
- [ ] 100 MB RAM minimum
- [ ] 50 MB free disk space
- [ ] Microphone or audio input device
- [ ] Administrator access (for installation)

**Files Present:**
- [ ] DecibelMeter.msix exists and is readable
- [ ] devcert.pfx exists and is readable
- [ ] INSTALL.ps1 or INSTALL.bat exists

---

## 📋 Installation Options

### Recommended: PowerShell Script
**Requirements:**
- Windows 10/11
- PowerShell 5.0+ (built-in)
- Administrator access
- Internet: Not required

**Command:**
```powershell
.\INSTALL.ps1
```

**What it does:**
1. Verifies Administrator privileges
2. Installs development certificate to Root store
3. Installs MSIX package
4. Launches application
5. Displays success message with next steps

---

### Alternative: Batch Script
**Requirements:**
- Windows 10/11
- Command Prompt
- Administrator access
- Internet: Not required

**Command:**
```cmd
INSTALL.bat
```

**What it does:**
1. Checks for Administrator privileges
2. Installs certificate via PowerShell helper
3. Installs MSIX package
4. Reports success or error

---

### Manual: Step-by-Step
**Requirements:**
- Administrator access
- Familiarity with PowerShell or Certificate Manager

**Steps:**
1. Open PowerShell as Administrator
2. Navigate to package directory
3. Run certificate installation command
4. Run MSIX installation command
5. Launch from Start Menu

---

## 🔐 Security Information

### Certificate Details
- **Type**: Self-signed development certificate
- **Publisher**: CN=matthew
- **Key Size**: 2048-bit RSA
- **Hash Algorithm**: SHA256
- **Validity**: 365 days from creation
- **Usage**: MSIX code signing only

### Important Security Notes
⚠️ **For Development Only:**
- This certificate is intended for development and testing
- Do NOT use for production distribution
- Do NOT use for public releases

✅ **For Production:**
- Obtain certificate from trusted Certificate Authority
- Follow Windows code signing best practices
- Update application manifest with production publisher

### Trust Installation
The installation script installs the certificate to:
- **Store**: Local Machine > Trusted Root Certification Authorities
- **Scope**: System-wide
- **Effect**: All users can install packages signed with this certificate

---

## 📥 Installation Permissions

### Required Permissions
- **Administrator Access**: Required to install certificate and MSIX
- **File System**: Read access to package directory
- **Registry**: Write access to certificate stores
- **NTFS**: Standard file permissions (automatic)

### User Accounts
- **System Administrator**: Full permissions
- **Standard User with Admin Rights**: Can install with elevation
- **Standard User**: Cannot install without administrative assistance

---

## 📋 Package Integrity

### File Verification
All critical files should be present and readable:

```
✓ DecibelMeter.msix        - 7,597,250 bytes (main app)
✓ devcert.pfx              - 2,584 bytes (certificate)
✓ INSTALL.ps1              - ~15 KB (PowerShell installer)
✓ INSTALL.bat              - ~2 KB (Batch installer)
✓ README.md                - ~11 KB (User guide)
✓ FEATURES.md              - ~15 KB (Feature list)
✓ MANIFEST.md              - This file
```

### Verify Package
To verify MSIX integrity:
```powershell
Test-AppxPackage -Path .\DecibelMeter.msix
```

To verify certificate:
```powershell
Get-PfxCertificate -FilePath .\devcert.pfx
```

---

## 🚀 Post-Installation

### First Launch
1. Click "Start" in Windows Start Menu
2. Search: "Decibel Meter"
3. Click to launch

### Initial Setup
1. Allow microphone permission (Windows dialog)
2. (Optional) Calibrate microphone in Settings
3. (Optional) Configure alert thresholds
4. Start measuring!

### Uninstallation
**Via Settings:**
1. Settings > Apps > Apps & features
2. Search "Decibel Meter"
3. Click and select "Uninstall"

**Via PowerShell:**
```powershell
Get-AppxPackage -Name "decibelmeter.windows" | Remove-AppxPackage
```

---

## 🆘 Troubleshooting

### Certificate Installation Fails
- **Cause**: Missing Administrator privileges
- **Solution**: Right-click PowerShell, select "Run as administrator"

### MSIX Installation Fails
- **Cause**: Certificate not installed
- **Solution**: Run installation script again to install certificate first

### App Won't Launch
- **Cause**: Missing .NET Runtime or broken installation
- **Solution**: Uninstall and reinstall using INSTALL.ps1

### Microphone Not Found
- **Cause**: Permission denied or no microphone
- **Solution**: Check Windows Settings > Privacy & Security > Microphone

---

## 📞 Support Resources

### Built-In Help
- Settings tab for configuration
- Feature descriptions in FEATURES.md
- Troubleshooting section in README.md

### Common Tasks
- **Calibrate**: Settings tab > Calibration Offset slider
- **Export Data**: Export button in Meter or History tab
- **Dark Mode**: Settings tab > Appearance > Enable dark mode
- **View History**: History tab shows all measurements

---

## 📜 License & Attribution

### Licensing
- Application licensed under: [See LICENSE file]
- Development certificate: Included for evaluation
- Dependencies: See source code for open source attributions

### Built With
- .NET 8.0 Framework (Microsoft)
- WPF - Windows Presentation Foundation
- NAudio - Audio Processing Library
- OxyPlot - Charting Library
- CommunityToolkit.Mvvm - MVVM Toolkit

---

## 📈 Version Information

**Current Version**: 1.0.0
- Initial Windows release
- All core features implemented
- MSIX packaging included

---

## 🔄 Update Information

**Checking for Updates:**
- Check the project repository for newer releases
- Download new distribution package
- Uninstall current version
- Install new version using same process

**Backup Data:**
Before updating:
```powershell
# Backup measurement database
Copy-Item $env:AppData\DecibelMeter\measurements.json -Destination .\measurements_backup.json
```

---

## 📋 Distribution Checklist

**Before Distribution:**
- [x] MSIX package created and signed
- [x] Certificate generated
- [x] Installation scripts created and tested
- [x] Documentation complete
- [x] All files present and verified
- [x] Troubleshooting guide prepared

**Distribution Methods:**
- [x] Direct file sharing (MSIX + scripts + docs)
- [x] ZIP archive (all files compressed)
- [x] Documentation complete for end users
- [ ] Microsoft Store (future - requires production cert)
- [ ] Web hosting (future - requires secure download)

---

## 📦 Next Steps

1. **Extract** the distribution package
2. **Review** README.md for quick start
3. **Run** INSTALL.ps1 or INSTALL.bat
4. **Launch** Decibel Meter from Start Menu
5. **Configure** settings as needed
6. **Enjoy** real-time sound level measurement!

---

**Thank you for using Decibel Meter!**

For technical details and source code, refer to the main project repository.

---

**Package Information:**
- Created: July 1, 2026
- Format: MSIX (Windows standard)
- Size: ~7.6 MB compressed
- Expandable to ~50-100 MB after installation
- Runtime: Included in MSIX (.NET 8.0)

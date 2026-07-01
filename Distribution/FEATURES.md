# Decibel Meter - Complete Feature List

## 🎯 Core Measurement Features

### Real-Time Sound Level Capture
- **Audio Input**: Captures from default microphone (44.1 kHz, mono, 16-bit)
- **Update Rate**: ~10 readings per second
- **Display Format**: Large 72-point font showing current dB level
- **Color Coding**:
  - Green (< 55 dB) - Low / Quiet
  - Yellow (55-70 dB) - Moderate / Normal
  - Orange (70-85 dB) - High / Loud
  - Red (> 85 dB) - Very High / Dangerous

### Level Tracking
- **Current Level** - Real-time instantaneous reading
- **Average Level** - Mean of all measurements in current session
- **Peak Level** - Maximum level reached during session
- **Duration** - Elapsed time since measurement started
- **Session Count** - Total number of recorded measurements

### Sound Level Classification
Automatic categorization based on measured decibel levels:
- **Low** (< 55 dB) - Whisper, quiet library
- **Moderate** (55-70 dB) - Normal conversation
- **High** (70-85 dB) - Traffic, loud music
- **Very High** (> 85 dB) - Industrial noise, risk of hearing damage

---

## 📊 Data Visualization

### Real-Time Chart
- **Type**: Line series showing last 100 measurements
- **Update**: Live as new measurements come in
- **Scrolling**: Automatic right-scrolling as new data arrives
- **Scaling**: Automatic Y-axis scaling (dB range)
- **Interactivity**: Zoom and pan capabilities

### Color-Coded Display
- Current level shows as large text in color matching sound band
- Background colors match intensity of current measurement
- Color changes provide instant visual feedback

### Chart Features
- Displays trends over measurement duration
- Shows peaks and valleys in real-time
- Helps identify sound patterns
- Resets on each new measurement session

---

## 🚨 Alert System

### Threshold-Based Alerts
- **High Alert**: Triggers at 85 dB (default)
- **Very High Alert**: Triggers at 100 dB (default)
- **State Tracking**: Prevents alert spam by remembering state
- **Enable/Disable**: Toggle alerts on/off with checkbox

### Configurable Thresholds
- **Range**: 60-100 dB adjustable
- **Slider Control**: Smooth adjustment in Settings tab
- **Real-Time**: Changes apply immediately
- **Persistent**: Setting remembered across sessions (session-based)

### Alert Notifications
- **Display**: Status message shows alert text
- **Format**: "🚨 High Alert: 85+ dB detected"
- **Duration**: Displays until dismissed
- **Multiple Alerts**: Tracks separate High and Very High states

---

## 💾 Data Persistence

### Measurement History
- **Storage**: Local JSON file in AppData
- **Location**: `%AppData%\DecibelMeter\measurements.json`
- **Data**: Each session includes:
  - Timestamp (start date/time)
  - Duration
  - Minimum level
  - Average level
  - Peak level
  - Unique ID

### Session Management
- **View**: History tab displays all recorded sessions
- **Details**: Shows date, time, duration, and statistics for each session
- **Delete**: Remove individual sessions with delete button
- **Clear All**: Remove all history with one click
- **Persistence**: Data survives app restarts

### Session Statistics
- **Count**: Total number of recorded measurements
- **Status**: Current history state display
- **Filter**: Can view/delete/export specific sessions

---

## 📤 Data Export

### CSV Export Format
- **Header Row**: Date, Time, Duration, Minimum, Average, Peak
- **Format**: Standard CSV, comma-separated
- **Encoding**: UTF-8 text file
- **Compatibility**: Opens in Excel, Google Sheets, any spreadsheet app

### Export Options
- **Current Session**: "Export Data" button in Meter tab
- **All Sessions**: "Export All" button in History tab
- **Filename**: `DecibelMeter_Measurements_YYYY-MM-DD_HH-mm-ss.csv`
- **Location**: `%UserProfile%\Documents\` (My Documents)

### Export Features
- **Timestamp**: Each export filename includes date/time
- **Formatting**: Readable values with units (duration in HH:MM:SS format)
- **Multiple Files**: Each export creates new file (no overwrites)
- **Quick Access**: Status message shows export location

---

## ⚙️ Calibration

### Calibration Offset
- **Range**: ±20 dB adjustment
- **Default**: 0 dB (no offset)
- **Slider**: Smooth control with display value
- **Application**: Applied to all measurements in real-time

### Purpose
- Match your device to reference sound level meters
- Account for microphone variations
- Correct for environmental factors
- Improve measurement accuracy

### Usage
1. Compare reading to known sound reference
2. Adjust offset until values match
3. New offset applies to all future measurements
4. Offset persists during session (can be reset)

---

## 🌙 Appearance & Theming

### Theme Support
- **Light Mode**: White background, dark text (default)
- **Dark Mode**: Dark gray background, light text
- **Toggle**: Checkbox in Settings > Appearance
- **Apply Button**: Changes take effect immediately

### Color Schemes
**Light Mode:**
- Background: White
- Text: Black
- Accents: Blue, Green, Orange, Red
- Borders: Light gray

**Dark Mode:**
- Background: Dark gray (#2D2D2D)
- Text: Light gray/white
- Accents: Lighter versions
- Borders: Medium gray

### Theme Scope
- All UI elements respond to theme change
- Charts and data displays update
- Persists during session (manual selection)

---

## 🎛️ Settings & Configuration

### Calibration Settings
- Offset slider (±20 dB)
- Current value display
- Guidance text

### Notification Settings
- Enable/disable checkbox
- Alert threshold slider
- Current threshold display
- Real-time preview

### Appearance Settings
- Dark mode checkbox
- Apply Theme button
- Visual feedback

### Management
- Save Settings button (commits changes)
- Reset to Defaults button (restores original values)
- All settings are session-persistent

---

## 🔋 System Integration

### Windows Integration
- **App Name**: "Decibel Meter"
- **Package Identity**: `decibelmeter.windows`
- **Start Menu**: Appears in Windows Start Menu
- **Settings**: Appears in Settings > Apps > Apps & features
- **Uninstall**: Standard Windows uninstall process

### Permissions
- **Microphone**: Required to access audio input
- **File Access**: Reads/writes to AppData and Documents folders
- **Manifest**: Package declares all capabilities

### Background & Foreground
- **Type**: Foreground application (runs when user launches)
- **Duration**: Runs for measurement session
- **Exit**: User manually stops or closes app
- **Data**: All measurements saved automatically

---

## 💾 Memory & Performance

### Memory Usage
- **Typical**: ~100 MB RAM during operation
- **Chart**: Last 100 measurements in memory (limited size)
- **History**: All sessions stored in JSON file on disk
- **Startup**: ~2-3 seconds initialization time

### Performance
- **Update Rate**: ~10 Hz (10 measurements/second)
- **Chart Refresh**: Synchronized with measurement rate
- **Export Speed**: <1 second for typical session
- **File I/O**: Async operations don't block UI

### Optimization
- Chart limited to 100 points (scrolls automatically)
- History loaded on demand
- JSON compression for storage
- Efficient audio buffer management

---

## 🔒 Data & Privacy

### Local Storage
- All data stored on local machine only
- No cloud synchronization
- No internet connection required
- Data persists until manually deleted

### Privacy
- No telemetry or usage tracking
- No account required
- Microphone audio not recorded, only levels calculated
- No external network connections

### Data Control
- View all stored data via History tab
- Export data in standard CSV format
- Delete individual or all sessions
- Clear app data via uninstall

---

## 🛠️ Technical Specifications

### Audio Processing
- **Capture**: NAudio WaveInEvent from default microphone
- **Format**: 44.1 kHz, mono, 16-bit PCM
- **RMS Calculation**: 16-bit and float sample support
- **dB Conversion**: Using reference offset of 110.0
- **Buffer**: Real-time processing, minimal latency

### UI Framework
- **Technology**: WPF (Windows Presentation Foundation)
- **Pattern**: MVVM (Model-View-ViewModel)
- **Charting**: OxyPlot with LineSeries
- **Responsiveness**: Async/await for non-blocking operations

### Data Format
- **History**: JSON format for persistence
- **Export**: CSV text format
- **Configuration**: Observable properties with MVVM Toolkit

### Version Information
- **Application Version**: 1.0.0
- **.NET Framework**: 8.0
- **Windows Target**: 10.0.26100.0 (Windows 10 18362+)
- **Architecture**: x64

---

## 📋 Feature Comparison

| Feature | Status | Notes |
|---------|--------|-------|
| Real-time measurement | ✅ | Live dB reading |
| Chart visualization | ✅ | Last 100 measurements |
| Alert thresholds | ✅ | Configurable 60-100 dB |
| Data persistence | ✅ | JSON storage |
| CSV export | ✅ | All measurements |
| Dark mode | ✅ | Toggle in Settings |
| Calibration offset | ✅ | ±20 dB adjustment |
| History management | ✅ | View/delete sessions |
| Multi-device support | ❌ | Single microphone only |
| Cloud sync | ❌ | Local storage only |
| Background recording | ❌ | Foreground app only |
| System notifications | ❌ | UI status messages |

---

## 🎓 Use Cases

### Personal Audio Monitoring
- Monitor ambient noise levels
- Track sound patterns over time
- Identify noisy times of day

### Workplace Assessment
- Measure workplace noise levels
- Document sound conditions
- Export for analysis

### Environmental Monitoring
- Track sound pollution
- Create noise level reports
- Export historical data

### Audio Testing
- Calibrate microphone against reference
- Verify audio equipment functionality
- Test room acoustics

### Educational Use
- Learn about sound levels and dB scale
- Visualize real-time measurements
- Understand sound classification

---

**For installation and quick start instructions, see README.md**

**For technical architecture details, see the source distribution documentation**

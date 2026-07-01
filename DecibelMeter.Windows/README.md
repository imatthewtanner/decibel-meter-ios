# Decibel Meter for Windows (WPF)

A privacy-first desktop sound level meter for Windows built with WPF and .NET 8.

## Features

✅ **Real-time Sound Level Measurement**
- Live decibel readings from your microphone
- Current, average, and peak level tracking
- Sound level classification (Low, Moderate, High, Very High)

✅ **Measurement History**
- Automatic storage of measurement sessions
- View past measurements with details
- Quick delete and clear all functionality

✅ **Calibration**
- Adjustable calibration offset (-20 to +20 dB)
- Fine-tune readings to match a reference meter
- Settings persist across sessions

✅ **Privacy First**
- No internet connectivity required
- No tracking, analytics, or telemetry
- Microphone data processed in-memory and immediately discarded
- Only session summaries stored locally

✅ **Native Windows Integration**
- Built with WPF for native Windows UI
- Responsive and performant
- Runs on Windows 10/11 with .NET 8

## Project Structure

```
DecibelMeter.Windows/
├── Models/
│   ├── SoundLevelBand.cs          # Sound level classification
│   └── MeasurementSession.cs       # Historical measurement data
├── Services/
│   ├── SoundLevelCalculator.cs    # dB calculation logic (ported from iOS)
│   ├── SoundMeter.cs               # Real-time microphone capture
│   └── MeasurementStorage.cs      # Local data persistence
├── ViewModels/
│   ├── MeterViewModel.cs           # Real-time measurement logic
│   ├── HistoryViewModel.cs         # Historical data management
│   └── SettingsViewModel.cs       # Settings management
├── Converters/
│   ├── LevelToBrushConverter.cs   # XAML value converters
│   ├── LevelToStringConverter.cs
│   ├── DurationToStringConverter.cs
│   └── InvertBooleanConverter.cs
├── MainWindow.xaml                # Main UI
└── App.xaml                        # Application resources
```

## Building

### Prerequisites
- .NET 8.0 SDK or later
- Windows 10/11
- A microphone connected to your computer

### Build

```bash
cd DecibelMeter.Windows
dotnet build -c Release
```

### Run

```bash
./bin/Release/net8.0-windows/DecibelMeter.exe
```

Or run directly in development:

```bash
dotnet run
```

## Usage

1. **Start Measuring**: Click "Start" to begin capturing sound levels
2. **View Readings**: See current, average, and peak levels in real-time
3. **Stop Measuring**: Click "Stop" to end the session (automatically saves to history)
4. **View History**: Switch to the History tab to see past measurements
5. **Calibrate**: Go to Settings and adjust the offset to match a reference meter

## Technical Details

### Sound Level Calculation
- Captures 44.1 kHz mono audio from the default microphone
- Calculates RMS (Root Mean Square) from 16-bit samples
- Converts RMS to decibels using reference offset
- Applies user calibration offset for accuracy

### Levels Classification
- **Low** (0-55 dB): Relatively quiet environment
- **Moderate** (55-70 dB): Noticeable sound
- **High** (70-85 dB): Loud environment
- **Very High** (85+ dB): Very loud environment

### Data Storage
- Measurements stored in JSON format in `%AppData%\DecibelMeter\measurements.json`
- Each session includes: timestamp, duration, min/avg/peak levels
- Local storage only, no cloud sync

## Technologies Used

- **Framework**: .NET 8.0 with WPF
- **Audio**: NAudio 2.2.1 for microphone capture
- **MVVM**: MVVM Community Toolkit for reactive UI
- **Language**: C# with nullable reference types

## Port Notes

This is a Windows port of the original iOS Decibel Meter:
- ✅ All core functionality replicated
- ✅ Same sound calculation algorithms
- ✅ Similar UI workflow
- ✅ Privacy-first philosophy maintained
- ⚠️ Phone microphones may have different characteristics than desktop/laptop microphones
- ⚠️ Automatic gain control varies by device

## Limitations

- **Not a certified instrument** - Use only for approximate measurements
- **Microphone dependent** - Accuracy varies by microphone quality
- **Device-specific** - Different computers will have different baseline levels
- **AGC behavior** - Many microphones have automatic gain control that affects readings

## Future Enhancements

- Real-time frequency visualization
- Sound level alerts and notifications
- Graphical history charts
- Export measurements to CSV
- Dark mode support
- Multiple session comparison

## License

See LICENSE file in the parent directory

## Privacy

This app:
- ❌ Does NOT collect any data
- ❌ Does NOT connect to the internet
- ❌ Does NOT use analytics
- ❌ Does NOT store data outside your computer
- ✅ Processes audio in-memory only
- ✅ Stores only measurement summaries locally

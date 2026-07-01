using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DecibelMeter.Windows.Services;

namespace DecibelMeter.Windows.ViewModels
{
    public partial class SettingsViewModel : ObservableObject
    {
        private readonly ThemeService _themeService = new();

        [ObservableProperty]
        private double calibrationOffset;

        [ObservableProperty]
        private bool enableSoundNotifications = true;

        [ObservableProperty]
        private bool enableDarkMode;

        [ObservableProperty]
        private double alertThreshold = 85;

        public SettingsViewModel()
        {
            LoadSettings();
        }

        [RelayCommand]
        public void SaveSettings()
        {
            // Settings are automatically persisted in observable properties
            // Apply theme if changed
            if (EnableDarkMode != (_themeService.CurrentTheme == ThemeService.Theme.Dark))
            {
                _themeService.CurrentTheme = EnableDarkMode ? ThemeService.Theme.Dark : ThemeService.Theme.Light;
            }
        }

        [RelayCommand]
        public void ToggleDarkMode()
        {
            EnableDarkMode = !EnableDarkMode;
            _themeService.CurrentTheme = EnableDarkMode ? ThemeService.Theme.Dark : ThemeService.Theme.Light;
        }

        private void LoadSettings()
        {
            CalibrationOffset = 0;
            EnableSoundNotifications = true;
            EnableDarkMode = false;
            AlertThreshold = 85;
            _themeService.CurrentTheme = ThemeService.Theme.Light;
        }

        [RelayCommand]
        public void ResetToDefaults()
        {
            CalibrationOffset = 0;
            EnableSoundNotifications = true;
            EnableDarkMode = false;
            AlertThreshold = 85;
            _themeService.CurrentTheme = ThemeService.Theme.Light;
        }
    }
}

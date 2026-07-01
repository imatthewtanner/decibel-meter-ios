using System.Windows.Media;

namespace DecibelMeter.Windows.Services
{
    /// <summary>
    /// Manages application themes and dark mode
    /// </summary>
    public class ThemeService
    {
        public enum Theme
        {
            Light,
            Dark
        }

        private Theme _currentTheme = Theme.Light;

        public event EventHandler<Theme>? ThemeChanged;

        public Theme CurrentTheme
        {
            get => _currentTheme;
            set
            {
                if (_currentTheme != value)
                {
                    _currentTheme = value;
                    ApplyTheme(value);
                    ThemeChanged?.Invoke(this, value);
                }
            }
        }

        public void ApplyTheme(Theme theme)
        {
            var app = System.Windows.Application.Current;
            var resources = app.Resources;

            if (theme == Theme.Dark)
            {
                resources["BackgroundColor"] = Color.FromRgb(30, 30, 30);
                resources["ForegroundColor"] = Color.FromRgb(240, 240, 240);
                resources["BorderColor"] = Color.FromRgb(60, 60, 60);
                resources["BackgroundBrush"] = new SolidColorBrush(Color.FromRgb(30, 30, 30));
                resources["ForegroundBrush"] = new SolidColorBrush(Color.FromRgb(240, 240, 240));
                resources["BorderBrush"] = new SolidColorBrush(Color.FromRgb(60, 60, 60));
            }
            else
            {
                resources["BackgroundColor"] = Color.FromRgb(255, 255, 255);
                resources["ForegroundColor"] = Color.FromRgb(0, 0, 0);
                resources["BorderColor"] = Color.FromRgb(204, 204, 204);
                resources["BackgroundBrush"] = new SolidColorBrush(Color.FromRgb(255, 255, 255));
                resources["ForegroundBrush"] = new SolidColorBrush(Color.FromRgb(0, 0, 0));
                resources["BorderBrush"] = new SolidColorBrush(Color.FromRgb(204, 204, 204));
            }
        }

        public void ToggleTheme()
        {
            CurrentTheme = _currentTheme == Theme.Light ? Theme.Dark : Theme.Light;
        }
    }
}

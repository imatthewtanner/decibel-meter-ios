using DecibelMeter.Windows.Services;
using System.Globalization;
using System.Windows.Data;
using System.Windows.Media;

namespace DecibelMeter.Windows.Converters
{
    public class LevelToBrushConverter : IValueConverter
    {
        public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (value is not double level)
                return Brushes.Gray;

            var band = SoundLevelCalculator.GetBand(level);

            return band switch
            {
                Models.SoundLevelBand.Low => new SolidColorBrush(Color.FromRgb(76, 175, 80)),      // Green
                Models.SoundLevelBand.Moderate => new SolidColorBrush(Color.FromRgb(255, 193, 7)), // Yellow
                Models.SoundLevelBand.High => new SolidColorBrush(Color.FromRgb(255, 152, 0)),     // Orange
                Models.SoundLevelBand.VeryHigh => new SolidColorBrush(Color.FromRgb(244, 67, 54)), // Red
                _ => Brushes.Gray
            };
        }

        public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}

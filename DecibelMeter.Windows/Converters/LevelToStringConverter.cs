using System.Globalization;
using System.Windows.Data;

namespace DecibelMeter.Windows.Converters
{
    public class LevelToStringConverter : IValueConverter
    {
        public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (value is double level)
                return $"{level:F1} dB";

            return "-- dB";
        }

        public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}

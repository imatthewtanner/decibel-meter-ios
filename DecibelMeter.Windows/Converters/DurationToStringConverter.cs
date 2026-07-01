using System.Globalization;
using System.Windows.Data;

namespace DecibelMeter.Windows.Converters
{
    public class DurationToStringConverter : IValueConverter
    {
        public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (value is TimeSpan duration)
            {
                if (duration.TotalHours >= 1)
                    return duration.ToString(@"hh\:mm\:ss");
                else
                    return duration.ToString(@"mm\:ss");
            }

            return "00:00";
        }

        public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}

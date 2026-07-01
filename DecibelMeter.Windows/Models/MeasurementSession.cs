namespace DecibelMeter.Windows.Models
{
    /// <summary>
    /// Represents a recorded sound measurement session
    /// </summary>
    public class MeasurementSession
    {
        public int Id { get; set; }
        public DateTime StartedAt { get; set; }
        public TimeSpan Duration { get; set; }
        public double MinimumLevel { get; set; }
        public double AverageLevel { get; set; }
        public double PeakLevel { get; set; }

        public MeasurementSession()
        {
            StartedAt = DateTime.Now;
        }

        public MeasurementSession(
            DateTime startedAt,
            TimeSpan duration,
            double minimumLevel,
            double averageLevel,
            double peakLevel)
        {
            StartedAt = startedAt;
            Duration = duration;
            MinimumLevel = minimumLevel;
            AverageLevel = averageLevel;
            PeakLevel = peakLevel;
        }
    }
}

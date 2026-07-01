namespace DecibelMeter.Windows.Models
{
    /// <summary>
    /// Represents a sound level band (low, moderate, high, very high)
    /// </summary>
    public enum SoundLevelBand
    {
        Low,
        Moderate,
        High,
        VeryHigh
    }

    /// <summary>
    /// Extension methods for SoundLevelBand
    /// </summary>
    public static class SoundLevelBandExtensions
    {
        public static string GetTitle(this SoundLevelBand band) => band switch
        {
            SoundLevelBand.Low => "Low",
            SoundLevelBand.Moderate => "Moderate",
            SoundLevelBand.High => "High",
            SoundLevelBand.VeryHigh => "Very High",
            _ => "Unknown"
        };

        public static string GetGuidance(this SoundLevelBand band) => band switch
        {
            SoundLevelBand.Low => "A relatively quiet environment.",
            SoundLevelBand.Moderate => "Noticeable sound; monitor comfort over time.",
            SoundLevelBand.High => "A loud environment; consider reducing exposure.",
            SoundLevelBand.VeryHigh => "A very loud environment; move away or use appropriate protection.",
            _ => ""
        };
    }
}

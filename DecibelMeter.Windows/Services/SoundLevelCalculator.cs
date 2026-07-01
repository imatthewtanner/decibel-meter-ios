namespace DecibelMeter.Windows.Services
{
    /// <summary>
    /// Calculates sound levels in decibels and classifies into bands
    /// </summary>
    public static class SoundLevelCalculator
    {
        private const double ReferenceOffset = 110.0;
        public const double MinimumLevel = 0.0;
        public const double MaximumLevel = 140.0;

        /// <summary>
        /// Converts RMS value to decibels
        /// </summary>
        public static double Decibels(double rms)
        {
            if (rms <= 0)
                return -120;

            return 20 * Math.Log10(rms);
        }

        /// <summary>
        /// Converts raw dBFS to estimated sound pressure level
        /// </summary>
        public static double EstimatedLevel(double dbFS, double calibrationOffset)
        {
            var level = dbFS + ReferenceOffset + calibrationOffset;
            return Math.Clamp(level, MinimumLevel, MaximumLevel);
        }

        /// <summary>
        /// Calculates RMS from 16-bit audio samples
        /// </summary>
        public static double CalculateRmsFromInt16(short[] samples)
        {
            if (samples.Length == 0)
                return 0;

            double sum = 0;
            for (int i = 0; i < samples.Length; i++)
            {
                double normalized = samples[i] / 32768.0;
                sum += normalized * normalized;
            }

            double meanSquare = sum / samples.Length;
            return Math.Sqrt(meanSquare);
        }

        /// <summary>
        /// Calculates RMS from 32-bit float audio samples
        /// </summary>
        public static double CalculateRmsFromFloat(float[] samples)
        {
            if (samples.Length == 0)
                return 0;

            double sum = 0;
            for (int i = 0; i < samples.Length; i++)
            {
                sum += samples[i] * samples[i];
            }

            double meanSquare = sum / samples.Length;
            return Math.Sqrt(meanSquare);
        }

        /// <summary>
        /// Classifies a sound level into a band
        /// </summary>
        public static Models.SoundLevelBand GetBand(double level)
        {
            return level switch
            {
                < 55 => Models.SoundLevelBand.Low,
                < 70 => Models.SoundLevelBand.Moderate,
                < 85 => Models.SoundLevelBand.High,
                _ => Models.SoundLevelBand.VeryHigh
            };
        }
    }
}

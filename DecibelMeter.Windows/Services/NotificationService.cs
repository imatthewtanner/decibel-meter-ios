namespace DecibelMeter.Windows.Services
{
    /// <summary>
    /// Handles notifications and alerts for sound level thresholds
    /// </summary>
    public class NotificationService
    {
        private double _highThreshold = 85;
        private double _veryHighThreshold = 100;
        private bool _hasShownHighAlert = false;
        private bool _hasShownVeryHighAlert = false;

        public event EventHandler<string>? NotificationTriggered;

        public double HighThreshold
        {
            get => _highThreshold;
            set => _highThreshold = value;
        }

        public double VeryHighThreshold
        {
            get => _veryHighThreshold;
            set => _veryHighThreshold = value;
        }

        public void CheckLevel(double currentLevel)
        {
            if (currentLevel >= _veryHighThreshold && !_hasShownVeryHighAlert)
            {
                _hasShownVeryHighAlert = true;
                _hasShownHighAlert = false;
                ShowNotification($"⚠️ VERY HIGH SOUND LEVEL: {currentLevel:F1} dB", "Move away or use protection!");
            }
            else if (currentLevel >= _highThreshold && !_hasShownHighAlert && currentLevel < _veryHighThreshold)
            {
                _hasShownHighAlert = true;
                _hasShownVeryHighAlert = false;
                ShowNotification($"⚠️ HIGH SOUND LEVEL: {currentLevel:F1} dB", "Consider reducing exposure");
            }
            else if (currentLevel < _highThreshold)
            {
                _hasShownHighAlert = false;
                _hasShownVeryHighAlert = false;
            }
        }

        private void ShowNotification(string title, string message)
        {
            NotificationTriggered?.Invoke(this, $"{title}\n{message}");
        }

        public void Reset()
        {
            _hasShownHighAlert = false;
            _hasShownVeryHighAlert = false;
        }
    }
}

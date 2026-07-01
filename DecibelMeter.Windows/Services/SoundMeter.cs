using NAudio.Wave;
using System.Collections.ObjectModel;

namespace DecibelMeter.Windows.Services
{
    /// <summary>
    /// Captures audio from the microphone and measures sound levels in real-time
    /// </summary>
    public class SoundMeter : IDisposable
    {
        private IWaveIn? _waveIn;
        private byte[] _buffer = [];
        private DateTime _startedAt;
        private double _minimumLevel = SoundLevelCalculator.MaximumLevel;
        private double _totalLevel = 0;
        private int _sampleCount = 0;
        private double _peakLevel = 0;

        public event EventHandler<double>? LevelChanged;
        public event EventHandler? Started;
        public event EventHandler? Stopped;
        public event EventHandler? PermissionDenied;
        public event EventHandler<string>? ErrorOccurred;

        public double CurrentLevel { get; private set; }
        public double AverageLevel { get; private set; }
        public double PeakLevel { get; private set; }
        public TimeSpan Duration { get; private set; }
        public ObservableCollection<double> RecentLevels { get; } = new();
        public double CalibrationOffset { get; set; } = 0;
        public bool IsMeasuring { get; private set; }

        public SoundMeter()
        {
        }

        public void Start()
        {
            if (IsMeasuring)
                return;

            try
            {
                var waveInEvent = new WaveInEvent();
                waveInEvent.DeviceNumber = 0; // Default microphone
                waveInEvent.WaveFormat = new WaveFormat(44100, 16, 1); // 44.1kHz, 16-bit, mono
                waveInEvent.DataAvailable += WaveIn_DataAvailable;

                _waveIn = waveInEvent;
                ResetReadings();
                _startedAt = DateTime.Now;
                _waveIn.StartRecording();
                IsMeasuring = true;
                Started?.Invoke(this, EventArgs.Empty);
            }
            catch (Exception ex)
            {
                ErrorOccurred?.Invoke(this, ex.Message);
                _waveIn?.Dispose();
                _waveIn = null;
            }
        }

        public void Stop()
        {
            if (!IsMeasuring || _waveIn == null)
                return;

            try
            {
                _waveIn.StopRecording();
                IsMeasuring = false;
                Stopped?.Invoke(this, EventArgs.Empty);
            }
            catch (Exception ex)
            {
                ErrorOccurred?.Invoke(this, ex.Message);
            }
        }

        private void WaveIn_DataAvailable(object? sender, WaveInEventArgs e)
        {
            if (e.BytesRecorded == 0)
                return;

            // Extract 16-bit samples from the buffer
            byte[] data = new byte[e.BytesRecorded];
            Array.Copy(e.Buffer, data, e.BytesRecorded);

            // Convert bytes to short samples (16-bit)
            short[] samples = new short[e.BytesRecorded / 2];
            for (int i = 0; i < samples.Length; i++)
            {
                samples[i] = BitConverter.ToInt16(data, i * 2);
            }

            // Calculate RMS and convert to dB
            double rms = SoundLevelCalculator.CalculateRmsFromInt16(samples);
            double dbFS = SoundLevelCalculator.Decibels(rms);
            double estimatedLevel = SoundLevelCalculator.EstimatedLevel(dbFS, CalibrationOffset);

            // Update measurements
            CurrentLevel = estimatedLevel;
            Duration = DateTime.Now - _startedAt;

            // Update statistics
            _minimumLevel = Math.Min(_minimumLevel, estimatedLevel);
            _peakLevel = Math.Max(_peakLevel, estimatedLevel);
            _totalLevel += estimatedLevel;
            _sampleCount++;
            AverageLevel = _totalLevel / _sampleCount;

            // Keep recent levels for charting (last 100 samples)
            if (RecentLevels.Count >= 100)
                RecentLevels.RemoveAt(0);
            RecentLevels.Add(estimatedLevel);

            // Notify
            LevelChanged?.Invoke(this, estimatedLevel);
        }

        private void ResetReadings()
        {
            CurrentLevel = 0;
            AverageLevel = 0;
            PeakLevel = 0;
            Duration = TimeSpan.Zero;
            _minimumLevel = SoundLevelCalculator.MaximumLevel;
            _peakLevel = 0;
            _totalLevel = 0;
            _sampleCount = 0;
            RecentLevels.Clear();
        }

        public Models.MeasurementSession GetSummary()
        {
            return new Models.MeasurementSession(
                _startedAt,
                Duration,
                _minimumLevel == SoundLevelCalculator.MaximumLevel ? 0 : _minimumLevel,
                AverageLevel,
                _peakLevel
            );
        }

        public void Dispose()
        {
            Stop();
            _waveIn?.Dispose();
            _waveIn = null;
        }
    }
}

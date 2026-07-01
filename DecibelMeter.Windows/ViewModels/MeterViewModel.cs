using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DecibelMeter.Windows.Services;
using OxyPlot;
using OxyPlot.Series;
using System.IO;

namespace DecibelMeter.Windows.ViewModels
{
    public partial class MeterViewModel : ObservableObject
    {
        private readonly SoundMeter _soundMeter = new();
        private readonly MeasurementStorage _storage = new();
        private readonly NotificationService _notificationService = new();
        private readonly ExportService _exportService = new();

        [ObservableProperty]
        private double currentLevel;

        [ObservableProperty]
        private double averageLevel;

        [ObservableProperty]
        private double peakLevel;

        [ObservableProperty]
        private TimeSpan duration;

        [ObservableProperty]
        private bool isMeasuring;

        [ObservableProperty]
        private double calibrationOffset;

        [ObservableProperty]
        private Models.SoundLevelBand currentBand;

        [ObservableProperty]
        private string statusMessage = "Ready";

        [ObservableProperty]
        private double alertThreshold = 85;

        [ObservableProperty]
        private bool enableAlerts = true;

        [ObservableProperty]
        private PlotModel levelChart = new();

        public System.Collections.ObjectModel.ObservableCollection<double> RecentLevels
            => _soundMeter.RecentLevels;

        public MeterViewModel()
        {
            _soundMeter.LevelChanged += SoundMeter_LevelChanged;
            _soundMeter.Started += SoundMeter_Started;
            _soundMeter.Stopped += SoundMeter_Stopped;
            _soundMeter.ErrorOccurred += SoundMeter_ErrorOccurred;
            _notificationService.NotificationTriggered += NotificationService_NotificationTriggered;

            InitializeChart();
        }

        private void InitializeChart()
        {
            LevelChart = new PlotModel { Title = "Sound Level History" };
            LevelChart.Series.Add(new LineSeries { Title = "Level (dB)" });
        }

        [RelayCommand]
        public void StartMeasurement()
        {
            _soundMeter.CalibrationOffset = CalibrationOffset;
            _notificationService.Reset();
            InitializeChart();
            _soundMeter.Start();
        }

        [RelayCommand]
        public void StopMeasurement()
        {
            _soundMeter.Stop();
            var summary = _soundMeter.GetSummary();
            _storage.Add(summary);
        }

        [RelayCommand]
        public void UpdateCalibrationOffset(double offset)
        {
            CalibrationOffset = offset;
        }

        [RelayCommand]
        public async Task ExportData()
        {
            try
            {
                var filePath = _exportService.GetDefaultExportPath();
                var sessions = _storage.GetAll();
                _exportService.ExportToCSV(filePath, sessions);
                StatusMessage = $"✓ Exported to {Path.GetFileName(filePath)}";
            }
            catch (Exception ex)
            {
                StatusMessage = $"✗ Export failed: {ex.Message}";
            }
        }

        private void SoundMeter_LevelChanged(object? sender, double level)
        {
            CurrentLevel = level;
            AverageLevel = _soundMeter.AverageLevel;
            PeakLevel = _soundMeter.PeakLevel;
            Duration = _soundMeter.Duration;
            CurrentBand = SoundLevelCalculator.GetBand(level);

            // Update chart
            UpdateChart(level);

            // Check alerts
            if (EnableAlerts)
            {
                _notificationService.CheckLevel(level);
            }
        }

        private void UpdateChart(double level)
        {
            var series = LevelChart.Series.FirstOrDefault() as LineSeries;
            if (series != null)
            {
                series.Points.Add(new DataPoint(series.Points.Count, level));
                if (series.Points.Count > 100)
                    series.Points.RemoveAt(0);
                LevelChart.InvalidatePlot(false);
            }
        }

        private void SoundMeter_Started(object? sender, EventArgs e)
        {
            IsMeasuring = true;
            StatusMessage = "Measuring...";
        }

        private void SoundMeter_Stopped(object? sender, EventArgs e)
        {
            IsMeasuring = false;
            StatusMessage = "Measurement complete";
        }

        private void SoundMeter_ErrorOccurred(object? sender, string message)
        {
            IsMeasuring = false;
            StatusMessage = $"Error: {message}";
        }

        private void NotificationService_NotificationTriggered(object? sender, string message)
        {
            StatusMessage = message;
        }

        public void Dispose()
        {
            _soundMeter.Dispose();
        }
    }
}

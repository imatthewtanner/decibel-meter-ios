using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using DecibelMeter.Windows.Models;
using DecibelMeter.Windows.Services;
using System.Collections.ObjectModel;
using System.IO;

namespace DecibelMeter.Windows.ViewModels
{
    public partial class HistoryViewModel : ObservableObject
    {
        private readonly MeasurementStorage _storage = new();
        private readonly ExportService _exportService = new();

        [ObservableProperty]
        private ObservableCollection<MeasurementSession> sessions = new();

        [ObservableProperty]
        private MeasurementSession? selectedSession;

        [ObservableProperty]
        private int sessionCount;

        [ObservableProperty]
        private string statusMessage = "No sessions yet";

        public HistoryViewModel()
        {
            LoadSessions();
        }

        [RelayCommand]
        public void LoadSessions()
        {
            Sessions.Clear();
            var sessions = _storage.GetAll();
            foreach (var session in sessions)
            {
                Sessions.Add(session);
            }

            SessionCount = Sessions.Count;
            StatusMessage = SessionCount > 0 ? $"{SessionCount} measurement(s) recorded" : "No sessions yet";
        }

        [RelayCommand]
        public void DeleteSession(MeasurementSession session)
        {
            _storage.Remove(session);
            Sessions.Remove(session);
            SessionCount = Sessions.Count;
            StatusMessage = SessionCount > 0 ? $"{SessionCount} measurement(s) remaining" : "No sessions yet";
        }

        [RelayCommand]
        public void ClearAll()
        {
            if (Sessions.Count == 0)
                return;

            _storage.Clear();
            Sessions.Clear();
            SessionCount = 0;
            StatusMessage = "All measurements cleared";
        }

        [RelayCommand]
        public async Task ExportSessions()
        {
            try
            {
                if (Sessions.Count == 0)
                {
                    StatusMessage = "✗ No sessions to export";
                    return;
                }

                var filePath = _exportService.GetDefaultExportPath();
                _exportService.ExportToCSV(filePath, Sessions);
                StatusMessage = $"✓ Exported {Sessions.Count} sessions to {Path.GetFileName(filePath)}";
            }
            catch (Exception ex)
            {
                StatusMessage = $"✗ Export failed: {ex.Message}";
            }
        }

        public string FormatDuration(TimeSpan duration)
        {
            if (duration.TotalHours >= 1)
                return duration.ToString(@"hh\:mm\:ss");
            else
                return duration.ToString(@"mm\:ss");
        }
    }
}

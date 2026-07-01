using DecibelMeter.Windows.Models;
using System.IO;
using System.Text.Json;

namespace DecibelMeter.Windows.Services
{
    /// <summary>
    /// Handles local storage of measurement sessions
    /// </summary>
    public class MeasurementStorage
    {
        private readonly string _dataDirectory;
        private readonly string _dataFile;
        private readonly List<MeasurementSession> _sessions = new();

        public MeasurementStorage()
        {
            _dataDirectory = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                "DecibelMeter"
            );

            _dataFile = Path.Combine(_dataDirectory, "measurements.json");

            if (!Directory.Exists(_dataDirectory))
                Directory.CreateDirectory(_dataDirectory);

            Load();
        }

        public void Add(MeasurementSession session)
        {
            session.Id = _sessions.Count > 0 ? _sessions.Max(s => s.Id) + 1 : 1;
            _sessions.Add(session);
            Save();
        }

        public void Remove(MeasurementSession session)
        {
            _sessions.Remove(session);
            Save();
        }

        public IReadOnlyList<MeasurementSession> GetAll()
        {
            return _sessions.OrderByDescending(s => s.StartedAt).ToList();
        }

        public MeasurementSession? GetById(int id)
        {
            return _sessions.FirstOrDefault(s => s.Id == id);
        }

        private void Save()
        {
            try
            {
                var json = JsonSerializer.Serialize(_sessions, new JsonSerializerOptions { WriteIndented = true });
                File.WriteAllText(_dataFile, json);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error saving measurements: {ex.Message}");
            }
        }

        private void Load()
        {
            try
            {
                if (!File.Exists(_dataFile))
                    return;

                var json = File.ReadAllText(_dataFile);
                var sessions = JsonSerializer.Deserialize<List<MeasurementSession>>(json);
                if (sessions != null)
                    _sessions.AddRange(sessions);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading measurements: {ex.Message}");
            }
        }

        public void Clear()
        {
            _sessions.Clear();
            Save();
        }
    }
}

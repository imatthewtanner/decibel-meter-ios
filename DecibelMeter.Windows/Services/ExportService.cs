using System.IO;

namespace DecibelMeter.Windows.Services
{
    /// <summary>
    /// Handles exporting measurement data to CSV format
    /// </summary>
    public class ExportService
    {
        public void ExportToCSV(string filePath, IEnumerable<Models.MeasurementSession> sessions)
        {
            try
            {
                using var writer = new StreamWriter(filePath);
                writer.WriteLine("Date,Time,Duration (hh:mm:ss),Minimum (dB),Average (dB),Peak (dB)");

                foreach (var session in sessions.OrderBy(s => s.StartedAt))
                {
                    var date = session.StartedAt.ToShortDateString();
                    var time = session.StartedAt.ToShortTimeString();
                    var duration = session.Duration.ToString(@"hh\:mm\:ss");
                    var minLevel = session.MinimumLevel.ToString("F1");
                    var avgLevel = session.AverageLevel.ToString("F1");
                    var peakLevel = session.PeakLevel.ToString("F1");

                    writer.WriteLine($"{date},{time},{duration},{minLevel},{avgLevel},{peakLevel}");
                }

                System.Diagnostics.Debug.WriteLine($"Exported {sessions.Count()} sessions to {filePath}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error exporting to CSV: {ex.Message}");
                throw;
            }
        }

        public string GetDefaultExportPath()
        {
            var documentsFolder = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            var timestamp = DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss");
            return Path.Combine(documentsFolder, $"DecibelMeter_Measurements_{timestamp}.csv");
        }
    }
}

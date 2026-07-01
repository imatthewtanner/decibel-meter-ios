using DecibelMeter.Windows.ViewModels;
using System.Windows;

namespace DecibelMeter.Windows
{
    public partial class MainWindow : Window
    {
        private MeterViewModel? _meterViewModel;

        public MainWindow()
        {
            InitializeComponent();
            _meterViewModel = new MeterViewModel();
            DataContext = _meterViewModel;
        }

        protected override void OnClosed(EventArgs e)
        {
            base.OnClosed(e);
            _meterViewModel?.Dispose();
        }
    }
}

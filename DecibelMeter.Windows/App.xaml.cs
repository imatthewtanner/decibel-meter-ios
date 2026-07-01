using System.Windows;

namespace DecibelMeter.Windows
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();
        }

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);
            
            MainWindow = new MainWindow();
            MainWindow.Show();
        }
    }
}

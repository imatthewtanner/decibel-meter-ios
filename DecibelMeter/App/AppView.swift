import SwiftData
import SwiftUI

struct AppView: View {
    @State private var selectedTab: AppTab = .meter

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MeterView()
            }
            .tabItem { AppTab.meter.label }
            .tag(AppTab.meter)

            NavigationStack {
                HistoryView()
            }
            .tabItem { AppTab.history.label }
            .tag(AppTab.history)

            NavigationStack {
                SettingsView()
            }
            .tabItem { AppTab.settings.label }
            .tag(AppTab.settings)
        }
        .tint(.cyan)
    }
}

private enum AppTab: Hashable {
    case meter
    case history
    case settings

    @ViewBuilder
    var label: some View {
        switch self {
        case .meter:
            Label("Meter", systemImage: "waveform")
        case .history:
            Label("History", systemImage: "clock.arrow.circlepath")
        case .settings:
            Label("Settings", systemImage: "gearshape")
        }
    }
}

#Preview {
    AppView()
        .environment(SoundMeter())
        .modelContainer(for: MeasurementSession.self, inMemory: true)
}

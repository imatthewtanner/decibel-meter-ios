import SwiftData
import SwiftUI

@main
struct DecibelMeterApp: App {
    @State private var soundMeter = SoundMeter()

    var body: some Scene {
        WindowGroup {
            AppView()
                .environment(soundMeter)
        }
        .modelContainer(for: MeasurementSession.self)
    }
}

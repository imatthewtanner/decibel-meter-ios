import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("calibrationOffset") private var calibrationOffset = 0.0
    @State private var showsDeleteConfirmation = false

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Calibration", systemImage: "slider.horizontal.3")
                        Spacer()
                        Text(calibrationOffset, format: .number.precision(.fractionLength(1)))
                            .monospacedDigit()
                        Text("dB")
                            .foregroundStyle(.secondary)
                    }

                    Slider(value: $calibrationOffset, in: -20...20, step: 0.5)
                        .accessibilityLabel("Calibration offset")
                        .accessibilityValue("\(calibrationOffset.formatted(.number.precision(.fractionLength(1)))) decibels")

                    HStack {
                        Text("−20")
                        Spacer()
                        Button("Reset") {
                            calibrationOffset = 0
                        }
                        .buttonStyle(.borderless)
                        Spacer()
                        Text("+20")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            } header: {
                Text("Meter")
            } footer: {
                Text("Compare with a known sound meter in a steady environment, then adjust until the readings match.")
            }

            Section("Privacy") {
                Label("Audio is processed in memory", systemImage: "memorychip")
                Label("No audio recordings are stored", systemImage: "waveform.slash")
                Label("No network connection or analytics", systemImage: "network.slash")
            }

            Section {
                Button("Delete All Measurements", role: .destructive) {
                    showsDeleteConfirmation = true
                }
            } footer: {
                Text("This permanently removes every saved summary from this device.")
            }

            Section("About") {
                LabeledContent("Version", value: appVersion)
                LabeledContent("Minimum iOS", value: "17.0")
                Text("Readings are estimates. This app is not a certified instrument and is not intended for occupational, medical, or legal decisions.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
        .alert("Delete all measurements?", isPresented: $showsDeleteConfirmation) {
            Button("Delete All", role: .destructive, action: deleteAllMeasurements)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }

    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    private func deleteAllMeasurements() {
        do {
            try modelContext.delete(model: MeasurementSession.self)
            try modelContext.save()
        } catch {
            assertionFailure("Unable to delete measurement history: \(error)")
        }
    }
}

import Charts
import SwiftData
import SwiftUI
import UIKit

struct MeterView: View {
    @Environment(SoundMeter.self) private var meter
    @Environment(\.modelContext) private var modelContext
    @AppStorage("calibrationOffset") private var calibrationOffset = 0.0

    private var levelPoints: [LevelPoint] {
        meter.recentLevels.enumerated().map { index, level in
            LevelPoint(id: index, level: level)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                statusHeader

                MeterGaugeView(
                    level: meter.currentLevel,
                    isActive: meter.isMeasuring
                )

                if meter.isMeasuring {
                    liveStats
                    trendCard
                    guidanceCard
                } else {
                    idleCard
                }

                if case .denied = meter.status {
                    permissionCard
                }

                if let message = meter.errorMessage {
                    errorCard(message: message)
                }

                measurementButton
            }
            .padding()
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Decibel Meter")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            if meter.isMeasuring {
                stopAndStoreMeasurement()
            }
        }
    }

    private var statusHeader: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(meter.isMeasuring ? Color.green : Color.secondary.opacity(0.5))
                .frame(width: 8, height: 8)

            Text(meter.isMeasuring ? "Measuring live" : "Microphone idle")
                .font(.subheadline.weight(.medium))

            Spacer()

            if meter.isMeasuring {
                Text(meter.duration.measurementDuration)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.thinMaterial, in: Capsule())
    }

    private var liveStats: some View {
        HStack(spacing: 12) {
            StatCard(title: "Average", value: meter.averageLevel, icon: "waveform.path")
            StatCard(title: "Peak", value: meter.peakLevel, icon: "arrow.up.right")
        }
    }

    private var trendCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Recent levels", systemImage: "chart.xyaxis.line")
                .font(.headline)

            Chart(levelPoints) { item in
                AreaMark(
                    x: .value("Sample", item.id),
                    yStart: .value("Baseline", 30),
                    yEnd: .value("Level", item.level)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan.opacity(0.35), .cyan.opacity(0.02)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                LineMark(
                    x: .value("Sample", item.id),
                    y: .value("Level", item.level)
                )
                .foregroundStyle(.cyan)
                .interpolationMethod(.catmullRom)
            }
            .chartYScale(domain: 30...120)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(values: [40, 60, 80, 100, 120])
            }
            .frame(height: 140)
            .accessibilityLabel("Recent sound level chart")
        }
        .cardStyle()
    }

    private var guidanceCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: meter.currentBand == .veryHigh ? "exclamationmark.triangle.fill" : "ear")
                .font(.title2)
                .foregroundStyle(meter.currentBand.tint)

            VStack(alignment: .leading, spacing: 4) {
                Text(meter.currentBand.title)
                    .font(.headline)
                Text(meter.currentBand.guidance)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .cardStyle()
    }

    private var idleCard: some View {
        VStack(spacing: 10) {
            Image(systemName: "mic.and.signal.meter")
                .font(.system(size: 34))
                .foregroundStyle(.cyan)
            Text("Measure your environment")
                .font(.headline)
            Text("Tap Start to analyze microphone amplitude. Audio is processed in memory and is never saved.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .cardStyle()
    }

    private var permissionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Microphone access is off", systemImage: "mic.slash.fill")
                .font(.headline)
                .foregroundStyle(.red)
            Text("Enable microphone access in Settings to take measurements.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button("Open Settings") {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private func errorCard(message: String) -> some View {
        Label(message, systemImage: "exclamationmark.circle.fill")
            .font(.subheadline)
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardStyle()
    }

    private var measurementButton: some View {
        Button {
            if meter.isMeasuring {
                stopAndStoreMeasurement()
            } else {
                Task {
                    await meter.start(calibrationOffset: calibrationOffset)
                }
            }
        } label: {
            Label(
                meter.isMeasuring ? "Stop & Save" : meter.isRequestingPermission ? "Requesting Access…" : "Start Measurement",
                systemImage: meter.isMeasuring ? "stop.fill" : "play.fill"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(meter.isMeasuring ? .red : .cyan)
        .disabled(meter.isRequestingPermission)
        .accessibilityHint(meter.isMeasuring ? "Stops the microphone and saves a summary" : "Requests microphone access and begins measuring")
    }

    private func stopAndStoreMeasurement() {
        guard let summary = meter.stop() else { return }
        modelContext.insert(MeasurementSession(summary: summary))
        try? modelContext.save()
    }
}

private struct LevelPoint: Identifiable {
    let id: Int
    let level: Double
}

private struct StatCard: View {
    let title: String
    let value: Double
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text("\(value.formatted(.number.precision(.fractionLength(1)))) dB")
                .font(.title3.bold().monospacedDigit())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

private extension MeterStatus {
    var isRequestingPermission: Bool {
        self == .requestingPermission
    }
}

private extension SoundMeter {
    var isRequestingPermission: Bool {
        status.isRequestingPermission
    }

    var errorMessage: String? {
        switch status {
        case .unavailable(let message), .failed(let message):
            message
        default:
            nil
        }
    }
}

extension View {
    func cardStyle() -> some View {
        padding(16)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

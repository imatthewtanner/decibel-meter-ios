import SwiftUI

struct MeasurementDetailView: View {
    let session: MeasurementSession

    private var band: SoundLevelBand {
        SoundLevelCalculator.band(for: session.averageLevel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 6) {
                    Text(session.averageLevel.formatted(.number.precision(.fractionLength(1))))
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("average dB")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(band.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(band.tint)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(band.tint.opacity(0.14), in: Capsule())
                }
                .frame(maxWidth: .infinity)
                .cardStyle()

                VStack(spacing: 0) {
                    DetailRow(label: "Started", value: session.startedAt.formatted(date: .long, time: .shortened), icon: "calendar")
                    Divider()
                    DetailRow(label: "Duration", value: session.duration.measurementDuration, icon: "timer")
                    Divider()
                    DetailRow(label: "Minimum", value: "\(session.minimumLevel.formatted(.number.precision(.fractionLength(1)))) dB", icon: "arrow.down")
                    Divider()
                    DetailRow(label: "Peak", value: "\(session.peakLevel.formatted(.number.precision(.fractionLength(1)))) dB", icon: "arrow.up")
                }
                .cardStyle()

                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(.cyan)
                    Text(band.guidance)
                        .font(.subheadline)
                    Spacer()
                }
                .cardStyle()
            }
            .padding()
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Measurement")
        .navigationBarTitleDisplayMode(.inline)
    }
}
private struct DetailRow: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.cyan)
                .frame(width: 24)
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 12)
    }
}

import SwiftUI

struct MeterGaugeView: View {
    let level: Double
    let isActive: Bool

    private var progress: Double {
        min(max((level - 30) / 90, 0), 1)
    }

    private var band: SoundLevelBand {
        SoundLevelCalculator.band(for: level)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.primary.opacity(0.08), lineWidth: 24)

            Circle()
                .trim(from: 0, to: isActive ? progress : 0)
                .stroke(
                    AngularGradient(
                        colors: [.cyan, .green, .yellow, .orange, .red],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: 24, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.smooth(duration: 0.22), value: level)

            VStack(spacing: 6) {
                Text(isActive ? level.formatted(.number.precision(.fractionLength(1))) : "—")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())

                Text("dB")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)

                if isActive {
                    Text(band.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(band.tint)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(band.tint.opacity(0.14), in: Capsule())
                } else {
                    Text("Ready")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: 340)
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Sound level")
        .accessibilityValue(isActive ? "\(level.formatted(.number.precision(.fractionLength(1)))) decibels, \(band.title)" : "Not measuring")
    }
}

extension SoundLevelBand {
    var tint: Color {
        switch self {
        case .low: .cyan
        case .moderate: .green
        case .high: .orange
        case .veryHigh: .red
        }
    }
}

#Preview {
    MeterGaugeView(level: 72.4, isActive: true)
        .padding()
}

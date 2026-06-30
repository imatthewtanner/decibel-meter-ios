import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MeasurementSession.startedAt, order: .reverse) private var sessions: [MeasurementSession]

    var body: some View {
        Group {
            if sessions.isEmpty {
                ContentUnavailableView(
                    "No Measurements",
                    systemImage: "waveform.badge.plus",
                    description: Text("Completed measurement summaries will appear here.")
                )
            } else {
                List {
                    Section {
                        ForEach(sessions) { session in
                            NavigationLink {
                                MeasurementDetailView(session: session)
                            } label: {
                                MeasurementRow(session: session)
                            }
                        }
                        .onDelete(perform: delete)
                    } footer: {
                        Text("Audio is never stored—only these summary values remain on this device.")
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("History")
        .toolbar {
            if !sessions.isEmpty {
                EditButton()
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sessions[index])
        }
        try? modelContext.save()
    }
}

private struct MeasurementRow: View {
    let session: MeasurementSession

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(SoundLevelCalculator.band(for: session.averageLevel).tint.opacity(0.14))
                Image(systemName: "waveform")
                    .foregroundStyle(SoundLevelCalculator.band(for: session.averageLevel).tint)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(session.startedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.headline)
                Text("\(session.duration.measurementDuration) • Peak \(session.peakLevel.formatted(.number.precision(.fractionLength(0)))) dB")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(session.averageLevel.formatted(.number.precision(.fractionLength(0))))
                .font(.title2.bold().monospacedDigit())
                .accessibilityLabel("Average \(session.averageLevel.formatted(.number.precision(.fractionLength(0)))) decibels")
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .modelContainer(for: MeasurementSession.self, inMemory: true)
}

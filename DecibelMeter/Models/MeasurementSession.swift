import Foundation
import SwiftData

@Model
final class MeasurementSession {
    @Attribute(.unique) var id: UUID
    var startedAt: Date
    var duration: TimeInterval
    var minimumLevel: Double
    var averageLevel: Double
    var peakLevel: Double

    init(
        id: UUID = UUID(),
        startedAt: Date,
        duration: TimeInterval,
        minimumLevel: Double,
        averageLevel: Double,
        peakLevel: Double
    ) {
        self.id = id
        self.startedAt = startedAt
        self.duration = duration
        self.minimumLevel = minimumLevel
        self.averageLevel = averageLevel
        self.peakLevel = peakLevel
    }

    convenience init(summary: MeasurementSummary) {
        self.init(
            startedAt: summary.startedAt,
            duration: summary.duration,
            minimumLevel: summary.minimumLevel,
            averageLevel: summary.averageLevel,
            peakLevel: summary.peakLevel
        )
    }
}

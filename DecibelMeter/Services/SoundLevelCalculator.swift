import Accelerate
import AVFAudio
import Foundation

enum SoundLevelCalculator {
    static let referenceOffset = 110.0
    static let minimumLevel = 0.0
    static let maximumLevel = 140.0

    static func decibels(rms: Double) -> Double {
        guard rms > 0 else { return -120 }
        return 20 * log10(rms)
    }

    static func estimatedLevel(dbFS: Double, calibrationOffset: Double) -> Double {
        min(
            max(dbFS + referenceOffset + calibrationOffset, minimumLevel),
            maximumLevel
        )
    }

    static func decibels(from buffer: AVAudioPCMBuffer) -> Double {
        guard
            let channelData = buffer.floatChannelData,
            buffer.frameLength > 0,
            buffer.format.channelCount > 0
        else {
            return -120
        }

        let frameCount = vDSP_Length(buffer.frameLength)
        var totalMeanSquare = Float.zero

        for channel in 0..<Int(buffer.format.channelCount) {
            var channelMeanSquare = Float.zero
            vDSP_measqv(channelData[channel], 1, &channelMeanSquare, frameCount)
            totalMeanSquare += channelMeanSquare
        }

        let meanSquare = totalMeanSquare / Float(buffer.format.channelCount)
        return decibels(rms: sqrt(Double(meanSquare)))
    }

    static func band(for level: Double) -> SoundLevelBand {
        switch level {
        case ..<55:
            return .low
        case ..<70:
            return .moderate
        case ..<85:
            return .high
        default:
            return .veryHigh
        }
    }
}
enum SoundLevelBand: String, CaseIterable {
    case low
    case moderate
    case high
    case veryHigh

    var title: String {
        switch self {
        case .low: "Low"
        case .moderate: "Moderate"
        case .high: "High"
        case .veryHigh: "Very high"
        }
    }

    var guidance: String {
        switch self {
        case .low:
            "A relatively quiet environment."
        case .moderate:
            "Noticeable sound; monitor comfort over time."
        case .high:
            "A loud environment; consider reducing exposure."
        case .veryHigh:
            "A very loud environment; move away or use appropriate protection."
        }
    }
}

import Foundation

extension TimeInterval {
    var measurementDuration: String {
        let totalSeconds = max(Int(rounded()), 0)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        if minutes == 0 {
            return "\(seconds)s"
        }

        return "\(minutes)m \(seconds)s"
    }
}

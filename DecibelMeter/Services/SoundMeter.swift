import AVFAudio
import Foundation
import Observation

enum MeterStatus: Equatable {
    case idle
    case requestingPermission
    case measuring
    case denied
    case unavailable(String)
    case failed(String)
}

struct MeasurementSummary {
    let startedAt: Date
    let duration: TimeInterval
    let minimumLevel: Double
    let averageLevel: Double
    let peakLevel: Double
}

@MainActor
@Observable
final class SoundMeter {
    private(set) var status: MeterStatus = .idle
    private(set) var currentLevel = 0.0
    private(set) var averageLevel = 0.0
    private(set) var peakLevel = 0.0
    private(set) var duration: TimeInterval = 0
    private(set) var recentLevels: [Double] = []

    var calibrationOffset = 0.0

    @ObservationIgnored private var audioEngine: AVAudioEngine?
    @ObservationIgnored private var startedAt: Date?
    @ObservationIgnored private var sampleCount = 0
    @ObservationIgnored private var minimumLevel = SoundLevelCalculator.maximumLevel
    @ObservationIgnored private var lastPublishedAt = 0.0

    var isMeasuring: Bool {
        status == .measuring
    }

    var currentBand: SoundLevelBand {
        SoundLevelCalculator.band(for: currentLevel)
    }

    func start(calibrationOffset: Double) async {
        guard !isMeasuring else { return }

        status = .requestingPermission
        let permissionGranted = await AVAudioApplication.requestRecordPermission()

        guard permissionGranted else {
            status = .denied
            return
        }

        self.calibrationOffset = calibrationOffset
        resetReadings()

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record, mode: .measurement)
            try session.setPreferredIOBufferDuration(0.05)
            try session.setActive(true)

            let engine = AVAudioEngine()
            let inputNode = engine.inputNode
            let inputFormat = inputNode.inputFormat(forBus: 0)

            guard inputFormat.sampleRate > 0, inputFormat.channelCount > 0 else {
                try? session.setActive(false, options: .notifyOthersOnDeactivation)
                status = .unavailable("No microphone input is currently available.")
                return
            }

            inputNode.installTap(
                onBus: 0,
                bufferSize: 2_048,
                format: inputFormat
            ) { [weak self] buffer, _ in
                let dbFS = SoundLevelCalculator.decibels(from: buffer)
                Task { @MainActor [weak self] in
                    self?.receive(dbFS: dbFS)
                }
            }

            audioEngine = engine
            startedAt = Date()
            engine.prepare()
            try engine.start()
            status = .measuring
        } catch {
            stopAudioEngine()
            status = .failed(error.localizedDescription)
        }
    }

    @discardableResult
    func stop() -> MeasurementSummary? {
        let summary: MeasurementSummary?

        if let startedAt, sampleCount > 0 {
            summary = MeasurementSummary(
                startedAt: startedAt,
                duration: max(Date().timeIntervalSince(startedAt), duration),
                minimumLevel: minimumLevel,
                averageLevel: averageLevel,
                peakLevel: peakLevel
            )
        } else {
            summary = nil
        }

        stopAudioEngine()
        status = .idle
        return summary
    }

    private func receive(dbFS: Double) {
        guard isMeasuring, let startedAt else { return }

        let now = ProcessInfo.processInfo.systemUptime
        guard now - lastPublishedAt >= 0.08 else { return }
        lastPublishedAt = now

        let measuredLevel = SoundLevelCalculator.estimatedLevel(
            dbFS: dbFS,
            calibrationOffset: calibrationOffset
        )
        let smoothingFactor = sampleCount == 0 ? 1.0 : 0.25
        currentLevel += smoothingFactor * (measuredLevel - currentLevel)

        sampleCount += 1
        averageLevel += (currentLevel - averageLevel) / Double(sampleCount)
        peakLevel = max(peakLevel, currentLevel)
        minimumLevel = min(minimumLevel, currentLevel)
        duration = Date().timeIntervalSince(startedAt)

        recentLevels.append(currentLevel)
        if recentLevels.count > 60 {
            recentLevels.removeFirst(recentLevels.count - 60)
        }
    }

    private func resetReadings() {
        currentLevel = 0
        averageLevel = 0
        peakLevel = 0
        duration = 0
        recentLevels = []
        sampleCount = 0
        minimumLevel = SoundLevelCalculator.maximumLevel
        lastPublishedAt = 0
        startedAt = nil
    }

    private func stopAudioEngine() {
        if let audioEngine {
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.stop()
        }
        audioEngine = nil
        startedAt = nil
        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
    }
}

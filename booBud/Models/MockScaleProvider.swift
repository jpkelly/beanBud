import Foundation

/// Generates synthetic weight readings that simulate a real Bookoo scale.
/// Used for testing the app UI without BLE hardware.
@Observable
final class MockScaleProvider {

    // MARK: - Simulated Scale State

    /// Current simulated weight in grams.
    private(set) var weightGrams: Double = 0

    /// Current simulated flow rate in g/s.
    private(set) var flowRate: Double = 0

    /// Battery percentage (fixed for mock).
    let batteryPercent: Int = 85

    /// Whether the simulated pour is active.
    private(set) var isPouring = false

    /// Elapsed seconds since timer started.
    private(set) var elapsedSeconds: Double = 0

    // MARK: - Configuration

    /// How often readings fire (seconds).
    var updateInterval: TimeInterval = 0.1

    /// Target pour flow rate in g/s when pouring.
    var pourRate: Double = 3.0

    /// Total target weight to pour (stops automatically when reached).
    var targetWeight: Double = 250

    /// Whether to auto-stop pouring when targetWeight is reached.
    var autoStopAtTarget: Bool = true

    // MARK: - Callbacks

    /// Called on each tick with a new WeightReading.
    var onReading: ((WeightReading) -> Void)?

    // MARK: - Private

    private var timer: Timer?
    private var startTime: Date?
    private var lastTickTime: Date?
    private var pouredSoFar: Double = 0

    // MARK: - Control

    func start() {
        guard timer == nil else { return }
        startTime = Date()
        lastTickTime = Date()
        elapsedSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isPouring = false
        flowRate = 0
    }

    func tare() {
        weightGrams = 0
        pouredSoFar = 0
        flowRate = 0
        isPouring = false
    }

    func startPour(rate: Double? = nil, target: Double? = nil) {
        if let rate { pourRate = rate }
        if let target { targetWeight = target }
        pouredSoFar = 0
        isPouring = true
    }

    func stopPour() {
        isPouring = false
        flowRate = 0
    }

    /// Reset the entire simulation.
    func reset() {
        stop()
        weightGrams = 0
        flowRate = 0
        pouredSoFar = 0
        isPouring = false
        elapsedSeconds = 0
        startTime = nil
        lastTickTime = nil
    }

    // MARK: - Tick

    private func tick() {
        guard let lastTick = lastTickTime else { return }
        let now = Date()
        let dt = now.timeIntervalSince(lastTick)
        lastTickTime = now

        // Advance elapsed time
        if let start = startTime {
            elapsedSeconds = now.timeIntervalSince(start)
        }

        // Simulate pouring
        if isPouring {
            let increment = pourRate * dt
            pouredSoFar += increment
            weightGrams += increment

            if autoStopAtTarget && pouredSoFar >= targetWeight {
                weightGrams = targetWeight
                isPouring = false
                flowRate = 0
            } else {
                flowRate = pourRate
            }
        }

        // Clamp weight at 0
        if weightGrams < 0 { weightGrams = 0 }

        let reading = WeightReading(
            grams: weightGrams,
            isStable: !isPouring && abs(flowRate) < 0.1,
            timestamp: now
        )
        onReading?(reading)
    }
}

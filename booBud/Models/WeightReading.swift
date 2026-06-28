import Foundation

/// A single weight reading from the scale.
struct WeightReading {
    /// Raw value in grams (the scale's native unit).
    let grams: Double
    /// Flow rate in grams per second.
    let flowRate: Double
    /// Timestamp of when this reading was received.
    let timestamp: Date

    /// Whether the scale reports this as a stable (non-fluctuating) reading.
    let isStable: Bool

    init(grams: Double, flowRate: Double = 0, isStable: Bool = true, timestamp: Date = Date()) {
        self.grams = grams
        self.flowRate = flowRate
        self.isStable = isStable
        self.timestamp = timestamp
    }

    /// Convenience — returns weight in the requested display unit.
    func value(in unit: WeightUnit) -> Double {
        unit.convert(grams: grams)
    }

    /// Formatted string for the given unit.
    func formatted(in unit: WeightUnit) -> String {
        unit.format(value(in: unit))
    }
}

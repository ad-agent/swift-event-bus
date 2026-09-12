import Foundation
/// Metrics tracking for the event bus.
public actor EventMetrics: Sendable {
    public private(set) var emitted = 0
    public private(set) var delivered = 0
    public func recordEmission() { emitted += 1 }
    public func recordDelivery() { delivered += 1 }
}

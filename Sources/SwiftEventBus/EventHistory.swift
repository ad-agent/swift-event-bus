import Foundation
/// Keeps a bounded history of emitted events for replay.
public actor EventHistory<E: Sendable> {
    private var buffer: [E] = []
    private let maxSize: Int
    public init(maxSize: Int = 100) { self.maxSize = maxSize }
    public func record(_ event: E) { buffer.append(event); if buffer.count > maxSize { buffer.removeFirst() } }
    public func replay(_ handler: @Sendable (E) async -> Void) async { for event in buffer { await handler(event) } }
    public var count: Int { buffer.count }
    public func clear() { buffer.removeAll() }
}

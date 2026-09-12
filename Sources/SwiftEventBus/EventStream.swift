import Foundation

extension EventBus {
    /// Returns an `AsyncStream` delivering events of the specified type.
    ///
    /// The stream automatically deregisters its subscription when cancelled or terminated.
    /// - Parameter eventType: The type of event to stream.
    /// - Returns: An asynchronous stream of events.
    public func stream<E: Sendable>(for eventType: E.Type) -> AsyncStream<E> {
        AsyncStream { continuation in
            let id = self.on(eventType) { event in
                continuation.yield(event)
            }
            continuation.onTermination = { @Sendable [weak self] _ in
                Task {
                    await self?.off(id: id)
                }
            }
        }
    }
}

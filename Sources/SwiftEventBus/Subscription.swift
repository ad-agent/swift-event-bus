import Foundation

/// A token representing an active subscription that can be cancelled.
public struct Subscription: Sendable {
    public let id: UUID
    private let canceller: @Sendable () async -> Void

    public init(id: UUID, cancel: @escaping @Sendable () async -> Void) {
        self.id = id
        self.canceller = cancel
    }

    /// Cancels the subscription, removing it from the event bus.
    public func cancel() async {
        await canceller()
    }
}

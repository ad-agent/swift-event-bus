import Foundation
/// Type-erased event filter for conditional event handling.
public struct EventFilter<E: Sendable>: Sendable {
    private let predicate: @Sendable (E) -> Bool

    public init(_ predicate: @escaping @Sendable (E) -> Bool) {
        self.predicate = predicate
    }

    public func matches(_ event: E) -> Bool {
        predicate(event)
    }

    /// A filter that matches all events.
    public static var all: EventFilter<E> {
        EventFilter { _ in true }
    }
}

extension EventBus {
    /// Subscribe with a filter — handler only fires when the filter matches.
    public func on<E: Sendable>(
        _ eventType: E.Type,
        filter: EventFilter<E>,
        handler: @escaping @Sendable (E) async -> Void
    ) -> UUID {
        on(eventType) { event in
            if filter.matches(event) { await handler(event) }
        }
    }
}

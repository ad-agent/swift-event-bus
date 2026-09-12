import Foundation

/// A type-safe asynchronous event bus supporting typed and wildcard event subscriptions.
public actor EventBus {
    private typealias EventHandler = @Sendable (any Sendable) async -> Void

    private var handlers: [ObjectIdentifier: [UUID: EventHandler]] = [:]
    private var wildcardHandlers: [UUID: EventHandler] = [:]

    public init() {}

    /// Registers an asynchronous handler for a specific event type.
    @discardableResult
    public func on<E: Sendable>(
        _ eventType: E.Type,
        handler: @escaping @Sendable (E) async -> Void
    ) -> UUID {
        let id = UUID()
        let key = ObjectIdentifier(eventType)
        handlers[key, default: [:]][id] = { event in
            if let typed = event as? E { await handler(typed) }
        }
        return id
    }

    /// Registers a wildcard handler invoked for any event emitted on the bus.
    @discardableResult
    public func onAny(handler: @escaping @Sendable (any Sendable) async -> Void) -> UUID {
        let id = UUID()
        wildcardHandlers[id] = handler
        return id
    }

    /// Subscribes to an event type and returns a cancellable `Subscription`.
    public func subscribe<E: Sendable>(
        _ eventType: E.Type,
        handler: @escaping @Sendable (E) async -> Void
    ) -> Subscription {
        let id = on(eventType, handler: handler)
        return Subscription(id: id) { [weak self] in await self?.off(id: id) }
    }

    /// Unregisters a handler by its identifier.
    public func off(id: UUID) {
        for key in handlers.keys { handlers[key]?.removeValue(forKey: id) }
        wildcardHandlers.removeValue(forKey: id)
    }

    /// Emits an event to all matching registered handlers and wildcard handlers.
    public func emit<E: Sendable>(_ event: E) async {
        let key = ObjectIdentifier(E.self)
        let typeHandlers = handlers[key]?.values.map { $0 } ?? []
        let wildcards = Array(wildcardHandlers.values)

        await withTaskGroup(of: Void.self) { group in
            for handler in typeHandlers { group.addTask { await handler(event) } }
            for handler in wildcards { group.addTask { await handler(event) } }
        }
    }
}

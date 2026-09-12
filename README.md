# SwiftEventBus

A type-safe, asynchronous event bus designed for modern Swift concurrency with wildcard subscriptions.

`SwiftEventBus` leverages Swift 6 actors and structured concurrency to provide thread-safe event publishing and subscription across your application without locks or data races.

## Features

- **Type-Safe Subscriptions**: Register handlers strongly typed to any `Sendable` event.
- **Wildcard Subscriptions**: Intercept all events with global wildcard listeners.
- **AsyncStream Support**: Consume events as native `AsyncStream` sequences.
- **Swift 6 Concurrency**: Fully actor-isolated and data-race free.

## Installation

Add `SwiftEventBus` to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ad-agent/swift-event-bus.git", from: "1.0.0")
]
```

## Quick Start

```swift
import SwiftEventBus

struct OrderPlaced: Sendable {
    let id: String
}

let bus = EventBus()

// Subscribe to a specific event
let subId = await bus.on(OrderPlaced.self) { event in
    print("Received order: \(event.id)")
}

// Publish an event
await bus.emit(OrderPlaced(id: "ORD-123"))

// Unsubscribe
await bus.off(id: subId)
```

## License

MIT License. See [LICENSE](LICENSE) for details.

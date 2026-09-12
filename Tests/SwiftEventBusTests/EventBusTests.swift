import Foundation
import Testing
@testable import SwiftEventBus

private struct UserEvent: Sendable, Equatable {
    let username: String
}

private actor Collector {
    var names: [String] = []
    func add(_ name: String) { names.append(name) }
}

@Suite("EventBus Lifecycle Tests")
struct EventBusTests {
    @Test("Registers, emits, and unregisters handlers")
    func lifecycle() async {
        let bus = EventBus()
        let collector = Collector()

        let id = await bus.on(UserEvent.self) { event in
            await collector.add(event.username)
        }

        await bus.emit(UserEvent(username: "alice"))
        let first = await collector.names
        #expect(first == ["alice"])

        await bus.off(id: id)
        await bus.emit(UserEvent(username: "bob"))
        let second = await collector.names
        #expect(second == ["alice"])
    }
}

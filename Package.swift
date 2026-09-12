// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftEventBus",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftEventBus",
            targets: ["SwiftEventBus"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftEventBus"
        ),
        .testTarget(
            name: "SwiftEventBusTests",
            dependencies: ["SwiftEventBus"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

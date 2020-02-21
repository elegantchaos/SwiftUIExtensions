// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftUIExtensions",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SwiftUIExtensions",
            targets: ["SwiftUIExtensions"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftUIExtensions",
            dependencies: []),
        .testTarget(
            name: "SwiftUIExtensionsTests",
            dependencies: ["SwiftUIExtensions"]),
    ]
)

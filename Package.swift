// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIImageProvider",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
    ],
    products: [
        .library(
            name: "UIImageProvider",
            targets: ["UIImageProvider"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "UIImageProvider",
            dependencies: []
        ),
        .testTarget(
            name: "UIImageProviderTests",
            dependencies: ["UIImageProvider"]
        ),
    ]
)

// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIImageProvider",
    platforms: [
        .iOS(.v9),
        .macCatalyst(.v13),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        .library(
            name: "UIImageProvider",
            targets: ["UIImageProvider"]),
    ],
    dependencies: [
         .package(url: "https://github.com/AKoulabukhov/MVVMHelpers", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UIImageProvider",
            dependencies: ["MVVMHelpers"]),
        .testTarget(
            name: "UIImageProviderTests",
            dependencies: ["UIImageProvider"]),
    ]
)

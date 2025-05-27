// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "DesignTokens",
    platforms: [.iOS(.v16), .tvOS(.v16), .watchOS(.v11)],
    products: [
        .library(
            name: "DesignTokens",
            targets: ["DesignTokens"]),
    ],
    targets: [
        .target(name: "DesignTokens"),
    ]
)

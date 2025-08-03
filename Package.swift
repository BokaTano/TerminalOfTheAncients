// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "terminal-of-the-ancients",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "TOTA",
            targets: ["TOTA"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),

        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.3.0"),
        .package(url: "https://github.com/vapor/vapor", from: "4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "TOTA",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ShellOut", package: "ShellOut"),
                .product(name: "Vapor", package: "vapor"),
            ],
            path: "Sources/terminal-of-the-ancients"
        )

    ]
)

// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "lighthouse",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.65.0")
    ],
    targets: [
        .executableTarget(
            name: "lighthouse",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]
        )
    ]
)

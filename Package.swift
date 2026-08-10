// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FloatingTube",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "FloatingTube",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "FloatingTubeTests",
            dependencies: ["FloatingTube"]
        ),
    ]
)


// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FloatingTube",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "FloatingTube", targets: ["FloatingTube"]),
        .library(name: "FloatingTubeDomain", targets: ["FloatingTubeDomain"]),
        .library(name: "FloatingTubeData", targets: ["FloatingTubeData"]),
        .library(name: "FloatingTubePresentation", targets: ["FloatingTubePresentation"]),
    ],
    targets: [
        .target(
            name: "FloatingTubeDomain",
            path: "Sources/FloatingTubeDomain"
        ),
        .target(
            name: "FloatingTubeData",
            dependencies: ["FloatingTubeDomain"],
            path: "Sources/FloatingTubeData"
        ),
        .target(
            name: "FloatingTubePresentation",
            dependencies: ["FloatingTubeDomain"],
            path: "Sources/FloatingTubePresentation"
        ),
        .executableTarget(
            name: "FloatingTube",
            dependencies: [
                "FloatingTubeDomain",
                "FloatingTubeData",
                "FloatingTubePresentation"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "FloatingTubeDomainTests",
            dependencies: ["FloatingTubeDomain"]
        ),
        .testTarget(
            name: "FloatingTubeDataTests",
            dependencies: ["FloatingTubeData", "FloatingTubeDomain"]
        ),
        .testTarget(
            name: "FloatingTubePresentationTests",
            dependencies: ["FloatingTubePresentation", "FloatingTubeDomain"]
        )
    ]
)

import ProjectDescription

let project = Project(
    name: "FloatingTube",
    organizationName: "antigravity",
    targets: [
        // 1. Domain Layer: Pure business logic & entities
        .target(
            name: "FloatingTubeDomain",
            destinations: .macOS,
            product: .framework,
            bundleId: "com.antigravity.FloatingTubeDomain",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["Sources/FloatingTubeDomain/**"],
            dependencies: []
        ),
        
        // 2. Data Layer: Repositories & Services implementation
        .target(
            name: "FloatingTubeData",
            destinations: .macOS,
            product: .framework,
            bundleId: "com.antigravity.FloatingTubeData",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["Sources/FloatingTubeData/**"],
            dependencies: [
                .target(name: "FloatingTubeDomain")
            ]
        ),
        
        // 3. Presentation Layer: ViewModels, Views, Components & Localization
        .target(
            name: "FloatingTubePresentation",
            destinations: .macOS,
            product: .framework,
            bundleId: "com.antigravity.FloatingTubePresentation",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["Sources/FloatingTubePresentation/**"],
            dependencies: [
                .target(name: "FloatingTubeDomain"),
                .target(name: "FloatingTubeData")
            ]
        ),
        
        // 4. Application Layer: App lifecycle, DI Container & Entry Point
        .target(
            name: "FloatingTube",
            destinations: .macOS,
            product: .app,
            bundleId: "com.antigravity.FloatingTube",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleIconFile": "AppIcon",
                "CFBundleIconName": "AppIcon",
                "CFBundleName": "FloatingTube",
                "CFBundleShortVersionString": "1.1.0",
                "LSMinimumSystemVersion": "13.0",
                "NSHighResolutionCapable": true,
                "NSAppTransportSecurity": [
                    "NSAllowsArbitraryLoads": true
                ]
            ]),
            sources: ["Sources/FloatingTube/**"],
            resources: ["Sources/FloatingTube/Resources/**"],
            dependencies: [
                .target(name: "FloatingTubeDomain"),
                .target(name: "FloatingTubeData"),
                .target(name: "FloatingTubePresentation")
            ]
        ),
        
        // 5. Domain Unit Tests
        .target(
            name: "FloatingTubeDomainTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "com.antigravity.FloatingTubeDomainTests",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["Tests/FloatingTubeDomainTests/**"],
            dependencies: [
                .target(name: "FloatingTubeDomain")
            ]
        ),
        
        // 6. Data Unit Tests
        .target(
            name: "FloatingTubeDataTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "com.antigravity.FloatingTubeDataTests",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["Tests/FloatingTubeDataTests/**"],
            dependencies: [
                .target(name: "FloatingTubeData"),
                .target(name: "FloatingTubeDomain")
            ]
        )
    ]
)

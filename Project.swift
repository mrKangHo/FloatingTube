import ProjectDescription

let project = Project(
    name: "FloatingTube",
    organizationName: "antigravity",
    targets: [
        // 1. Domain Layer: Pure business logic, Entities, UseCases & Interfaces (No external framework dependencies)
        .target(
            name: "FloatingTubeDomain",
            destinations: .macOS,
            product: .framework,
            bundleId: "com.antigravity.FloatingTube.domain",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["Sources/FloatingTubeDomain/**"],
            dependencies: []
        ),
        
        // 2. Data Layer: Repositories & Platform Services implementation (Depends only on Domain)
        .target(
            name: "FloatingTubeData",
            destinations: .macOS,
            product: .framework,
            bundleId: "com.antigravity.FloatingTube.data",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["Sources/FloatingTubeData/**"],
            dependencies: [
                .target(name: "FloatingTubeDomain")
            ]
        ),
        
        // 3. Presentation Layer: UI Views, ViewModels, Localization & Window Management (Depends only on Domain)
        .target(
            name: "FloatingTubePresentation",
            destinations: .macOS,
            product: .framework,
            bundleId: "com.antigravity.FloatingTube.presentation",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .default,
            sources: ["Sources/FloatingTubePresentation/**"],
            dependencies: [
                .target(name: "FloatingTubeDomain")
            ]
        ),
        
        // 4. Application Layer: App Lifecycle, DI Container & Entry Point (Assembles Domain, Data, Presentation)
        .target(
            name: "FloatingTube",
            destinations: .macOS,
            product: .app,
            bundleId: "com.antigravity.FloatingTube",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleExecutable": "FloatingTube",
                "CFBundleIconFile": "AppIcon",
                "CFBundleIconName": "AppIcon",
                "CFBundleName": "FloatingTube",
                "CFBundleShortVersionString": "1.1.0",
                "CFBundleVersion": "1",
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
            bundleId: "com.antigravity.FloatingTube.domainTests",
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
            bundleId: "com.antigravity.FloatingTube.dataTests",
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

// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Modules",
            type: .dynamic,
            targets: [
                // MARK: - Core Interfaces
                "Core-NetworkingInterface",
                "Core-RepositoryInterface",

                // MARK: - Core Modules
                "Core-Foundation",
                "Core-UI",
                "Core-Networking",
                "Core-Repository",
                
                // MARK: - Feature Modules
                "Feature-Products",
            ]
        )
    ],
    dependencies: [
        // MARK: - Third Party
        .package(
            url: "https://github.com/bocato/LightInjection.git",
            .branch("main")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "0.17.0"
        ),
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.8.2"
        ),
    ],
    targets: [
        // @TODO: add description to modules
                
        // MARK: - Core Modules
        
        // Core-Foundation
        .target(
            name: "Core-Foundation",
            dependencies: []
        ),
        .testTarget(
            name: "Core-FoundationTests",
            dependencies: [
                "Core-Foundation"
            ]
        ),
        
        // Core-UI
        .target(
            name: "Core-UI",
            dependencies: []
        ),
        .testTarget(
            name: "Core-UITests",
            dependencies: [
                "Core-UI",
            ]
        ),

        // Core-Networking
        .target(
            name: "Core-NetworkingInterface",
            dependencies: []
        ),
        .target(
            name: "Core-Networking",
            dependencies: []
        ),
        .testTarget(
            name: "Core-NetworkingTests",
            dependencies: [
                "Core-NetworkingInterface",
                "Core-Networking"
            ]
        ),

        // Core-Repository
        .target(
            name: "Core-RepositoryInterface",
            dependencies: []
        ),
        .target(
            name: "Core-Repository",
            dependencies: [
                "Core-NetworkingInterface",
            ]
        ),
        .testTarget(
            name: "Core-RepositoryTests",
            dependencies: [
                "Core-RepositoryInterface",
                "Core-Repository"
            ]
        ),
        
        // MARK: - Feature Modules
        
        // Feature-Products
        .target(
            name: "Feature-Products",
            dependencies: [
                "Core-UI",
                "Core-RepositoryInterface",
                .product(name: "LightInjection", package: "LightInjection"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "Feature-ProductsTests",
            dependencies: [
                "Feature-Products",
                "Core-RepositoryInterface",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SnapshotTesting", package: "SnapshotTesting")
            ],
            exclude: [
                "*.png"
            ]
        ),
    ]
)

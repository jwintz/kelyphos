// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Kelyphos",
    platforms: [
        .macOS(.v26),
        .iOS(.v26)
    ],
    products: [
        .library(name: "KelyphosKit", targets: ["KelyphosKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.44.1"),
    ],
    targets: [
        .target(
            name: "KelyphosKit",
            path: "Sources/KelyphosKit"
        ),
        .executableTarget(
            name: "KelyphosDemo",
            dependencies: [
                "KelyphosKit",
            ],
            path: "Sources/KelyphosDemo"
        ),
        .testTarget(
            name: "KelyphosKitTests",
            dependencies: ["KelyphosKit"],
            path: "Tests/KelyphosKitTests"
        )
    ]
)

// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TimelineUI",
    platforms: [
        .iOS(.v26),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "TimelineUI",
            targets: ["TimelineUI"]
        ),
        .library(
            name: "TimelineUIEventKit",
            targets: ["TimelineUIEventKit"]
        ),
    ],
    targets: [
        .target(
            name: "TimelineUI"
        ),
        .target(
            name: "TimelineUIEventKit",
            dependencies: ["TimelineUI"],
            linkerSettings: [
                .linkedFramework("EventKit"),
            ]
        ),
        .executableTarget(
            name: "RenderPreviews",
            dependencies: ["TimelineUI"],
            path: "Sources/RenderPreviews"
        ),
        .testTarget(
            name: "TimelineUITests",
            dependencies: ["TimelineUI"]
        ),
    ]
)

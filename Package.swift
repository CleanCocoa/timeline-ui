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
    ],
    targets: [
        .target(
            name: "TimelineUI"
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

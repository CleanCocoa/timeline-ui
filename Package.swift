// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var targets: [Target] = [
	.target(name: "TimelineUI"),
	.target(
		name: "TimelineUIEventKit",
		dependencies: ["TimelineUI"],
		linkerSettings: [.linkedFramework("EventKit")]
	),
	.testTarget(
		name: "TimelineUITests",
		dependencies: ["TimelineUI"]
	),
]

#if os(macOS)
targets.append(
	.executableTarget(
		name: "RenderPreviews",
		dependencies: ["TimelineUI"],
		path: "Sources/RenderPreviews",
		linkerSettings: [.linkedFramework("AppKit")]
	)
)
#endif

let package = Package(
	name: "TimelineUI",
	platforms: [.iOS(.v26), .macOS(.v14)],
	products: [
		.library(name: "TimelineUI", targets: ["TimelineUI"]),
		.library(name: "TimelineUIEventKit", targets: ["TimelineUIEventKit"]),
	],
	targets: targets
)

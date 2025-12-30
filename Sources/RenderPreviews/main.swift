import AppKit
import SwiftUI
import TimelineUI

let sampleItems: [TimelineItem] = [
	TimelineItem(
		title: "Team Meeting",
		startDate: makeDate(hour: 10, minute: 0),
		endDate: makeDate(hour: 11, minute: 0),
		color: .blue,
		location: "Conference Room A",
		isPrimary: true
	),
	TimelineItem(
		title: "Lunch",
		startDate: makeDate(hour: 12, minute: 0),
		endDate: makeDate(hour: 13, minute: 0),
		color: .green,
		location: "Cafeteria",
		isPrimary: false
	),
	TimelineItem(
		title: "Code Review",
		startDate: makeDate(hour: 14, minute: 30),
		endDate: makeDate(hour: 15, minute: 30),
		color: .purple,
		isPrimary: false
	),
]

let conflictingItems: [TimelineItem] = [
	TimelineItem(
		title: "New Event",
		startDate: makeDate(hour: 10, minute: 30),
		endDate: makeDate(hour: 11, minute: 30),
		color: .accentColor,
		location: "Main Office",
		isPrimary: true
	),
	TimelineItem(
		title: "Existing Meeting",
		startDate: makeDate(hour: 10, minute: 0),
		endDate: makeDate(hour: 11, minute: 0),
		color: .red,
		location: "Room 101",
		isPrimary: false
	),
	TimelineItem(
		title: "Another Meeting",
		startDate: makeDate(hour: 11, minute: 0),
		endDate: makeDate(hour: 12, minute: 0),
		color: .orange,
		isPrimary: false
	),
]

let manyItems: [TimelineItem] = [
	TimelineItem(
		title: "Standup",
		startDate: makeDate(hour: 10, minute: 0),
		endDate: makeDate(hour: 10, minute: 30),
		color: .blue,
		isPrimary: false
	),
	TimelineItem(
		title: "Design Review",
		startDate: makeDate(hour: 10, minute: 0),
		endDate: makeDate(hour: 11, minute: 0),
		color: .purple,
		isPrimary: false
	),
	TimelineItem(
		title: "1:1 with Sarah",
		startDate: makeDate(hour: 10, minute: 15),
		endDate: makeDate(hour: 10, minute: 45),
		color: .green,
		isPrimary: false
	),
	TimelineItem(
		title: "Sprint Planning",
		startDate: makeDate(hour: 10, minute: 0),
		endDate: makeDate(hour: 11, minute: 30),
		color: .orange,
		isPrimary: false
	),
	TimelineItem(
		title: "Client Call",
		startDate: makeDate(hour: 10, minute: 30),
		endDate: makeDate(hour: 11, minute: 0),
		color: .red,
		isPrimary: false
	),
	TimelineItem(
		title: "New Meeting",
		startDate: makeDate(hour: 10, minute: 15),
		endDate: makeDate(hour: 11, minute: 15),
		color: .accentColor,
		isPrimary: true
	),
	TimelineItem(
		title: "Lunch & Learn",
		startDate: makeDate(hour: 10, minute: 0),
		endDate: makeDate(hour: 10, minute: 45),
		color: .cyan,
		isPrimary: false
	),
	TimelineItem(
		title: "Interview",
		startDate: makeDate(hour: 10, minute: 30),
		endDate: makeDate(hour: 11, minute: 30),
		color: .pink,
		isPrimary: false
	),
]

let allDayItems: [TimelineItem] = [
	TimelineItem(
		title: "Company Retreat",
		startDate: makeDate(hour: 0, minute: 0),
		endDate: makeDate(hour: 23, minute: 59),
		isAllDay: true,
		color: .cyan,
		isPrimary: false
	),
	TimelineItem(
		title: "Holiday",
		startDate: makeDate(hour: 0, minute: 0),
		endDate: makeDate(hour: 23, minute: 59),
		isAllDay: true,
		color: .pink,
		isPrimary: false
	),
	TimelineItem(
		title: "Team Standup",
		startDate: makeDate(hour: 9, minute: 0),
		endDate: makeDate(hour: 9, minute: 30),
		color: .accentColor,
		isPrimary: true
	),
]

enum ViewType {
	case day
	case compact(HeightMode, height: CGFloat)
}

struct AnimationPreviewContainer<CompactContent: View, ExpandedContent: View>: View {
	let progress: Double
	let compactSize: CGSize
	let expandedSize: CGSize
	let compactCornerRadius: CGFloat
	let expandedCornerRadius: CGFloat
	let compactContent: () -> CompactContent
	let expandedContent: () -> ExpandedContent

	init(
		progress: Double,
		compactSize: CGSize,
		expandedSize: CGSize,
		compactCornerRadius: CGFloat = 12,
		expandedCornerRadius: CGFloat = 20,
		@ViewBuilder compact: @escaping () -> CompactContent,
		@ViewBuilder expanded: @escaping () -> ExpandedContent
	) {
		self.progress = progress
		self.compactSize = compactSize
		self.expandedSize = expandedSize
		self.compactCornerRadius = compactCornerRadius
		self.expandedCornerRadius = expandedCornerRadius
		self.compactContent = compact
		self.expandedContent = expanded
	}

	private var interpolatedSize: CGSize {
		CGSize(
			width: compactSize.width + (expandedSize.width - compactSize.width) * progress,
			height: compactSize.height + (expandedSize.height - compactSize.height) * progress
		)
	}

	private var interpolatedCornerRadius: CGFloat {
		compactCornerRadius + (expandedCornerRadius - compactCornerRadius) * progress
	}

	var body: some View {
		ZStack {
			Color.black.opacity(progress * 0.4)
				.ignoresSafeArea()

			ZStack {
				compactContent()
					.frame(width: compactSize.width, height: compactSize.height)
					.opacity(1.0 - progress)

				expandedContent()
					.frame(width: expandedSize.width, height: expandedSize.height)
					.opacity(progress)
			}
			.frame(width: interpolatedSize.width, height: interpolatedSize.height)
			.clipped()
			.clipShape(RoundedRectangle(cornerRadius: interpolatedCornerRadius))
			.background(.regularMaterial, in: RoundedRectangle(cornerRadius: interpolatedCornerRadius))
		}
	}
}

func springProgress(t: Double) -> Double {
	let duration = 0.4
	let bounce = 0.15
	let omega = 2.0 * .pi / duration
	let zeta = 1.0 - bounce
	let scaledT = t * duration
	let decay = exp(-zeta * omega * scaledT)
	let dampedFreq = omega * sqrt(max(0, 1.0 - zeta * zeta))
	let oscillation = cos(dampedFreq * scaledT)
	return max(0, min(1, 1.0 - decay * oscillation))
}

let previewScenarios: [(name: String, items: [TimelineItem], viewType: ViewType)] = [
	("day-simple", sampleItems, .day),
	("day-conflicts", conflictingItems, .day),
	("day-with-allday", allDayItems, .day),
	("day-many", manyItems, .day),
	("compact-simple", sampleItems, .compact(.fixed(hours: 2), height: 132)),
	("compact-conflicts", conflictingItems, .compact(.fixed(hours: 2), height: 132)),
	("compact-many", manyItems, .compact(.fixed(hours: 2), height: 132)),
	("compact-fixed-1", conflictingItems, .compact(.fixed(hours: 1), height: 88)),
	("compact-fixed-0", conflictingItems, .compact(.fixed(hours: 0), height: 88)),
	("compact-flexible", conflictingItems, .compact(.flexible, height: 173)),
]

func makeDate(hour: Int, minute: Int) -> Date {
	var components = DateComponents()
	components.year = 2025
	components.month = 1
	components.day = 20
	components.hour = hour
	components.minute = minute
	return Calendar.current.date(from: components)!
}

@MainActor
func renderAllPreviews() {
	let outputDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
		.appendingPathComponent("previews")
	let lightDir = outputDir.appendingPathComponent("light")
	let darkDir = outputDir.appendingPathComponent("dark")

	try? FileManager.default.createDirectory(at: lightDir, withIntermediateDirectories: true)
	try? FileManager.default.createDirectory(at: darkDir, withIntermediateDirectories: true)

	for (name, items, viewType) in previewScenarios {
		let view: AnyView
		let size: CGSize
		switch viewType {
		case .day:
			view = AnyView(
				DayTimelineView(items: items)
					.frame(width: 375, height: 500)
					.padding(16)
					.background(.background)
					.clipShape(RoundedRectangle(cornerRadius: 16))
					.padding(20)
					.background(Color(nsColor: .windowBackgroundColor))
			)
			size = CGSize(width: 435, height: 572)
		case .compact(let heightMode, let height):
			view = AnyView(
				CompactTimelineView(items: items, heightMode: heightMode)
					.frame(width: 375, height: height)
					.clipShape(RoundedRectangle(cornerRadius: 12))
					.background(.background, in: RoundedRectangle(cornerRadius: 12))
					.padding(20)
					.background(Color(nsColor: .windowBackgroundColor))
			)
			size = CGSize(width: 415, height: height + 40)
		}

		renderToFiles(name: name, view: view, size: size, lightDir: lightDir, darkDir: darkDir)
	}

	for (name, view, size) in accessControlPreviews() {
		renderToFiles(name: name, view: view, size: size, lightDir: lightDir, darkDir: darkDir)
	}

	print("Done! Previews saved to \(outputDir.path)")
}

@MainActor
func renderToFiles(name: String, view: AnyView, size: CGSize, lightDir: URL, darkDir: URL) {
	if let lightImage = renderView(view.environment(\.colorScheme, .light), size: size) {
		let outputPath = lightDir.appendingPathComponent("\(name).png")
		savePNG(lightImage, to: outputPath)
		print("Rendered light/\(name).png")
	}

	if let darkImage = renderView(view.environment(\.colorScheme, .dark), size: size) {
		let outputPath = darkDir.appendingPathComponent("\(name).png")
		savePNG(darkImage, to: outputPath)
		print("Rendered dark/\(name).png")
	}
}

@MainActor
func accessControlPreviews() -> [(name: String, view: AnyView, size: CGSize)] {
	[
		(
			"access-prompt-compact",
			AnyView(
				AccessPromptView.calendar(
					style: .compact,
					title: "Check for conflicts",
					message: "See if this time works with your schedule",
					buttonLabel: "Enable Calendar"
				) {}
				.frame(width: 280)
				.padding(16)
				.background(.background)
				.clipShape(RoundedRectangle(cornerRadius: 12))
				.padding(20)
				.background(Color(nsColor: .windowBackgroundColor))
			),
			CGSize(width: 352, height: 180)
		),
		(
			"access-prompt-expanded",
			AnyView(
				AccessPromptView.calendar(style: .expanded) {}
					.frame(width: 320, height: 300)
					.background(.background)
					.clipShape(RoundedRectangle(cornerRadius: 16))
					.padding(20)
					.background(Color(nsColor: .windowBackgroundColor))
			),
			CGSize(width: 360, height: 340)
		),
		(
			"access-restricted-timeline",
			AnyView(
				CompactTimelineView(items: [], heightMode: .fixed(hours: 2))
					.frame(width: 375, height: 132)
					.accessRestricted(true) {
						AccessPromptView.calendar(
							style: .compact,
							title: "See Your Schedule",
							message: "Allow calendar access to show your events",
							buttonLabel: "Grant Calendar Access"
						) {}
					}
					.clipShape(RoundedRectangle(cornerRadius: 12))
					.background(.background, in: RoundedRectangle(cornerRadius: 12))
					.padding(20)
					.background(Color(nsColor: .windowBackgroundColor))
			),
			CGSize(width: 415, height: 172)
		),
	]
}

@MainActor
func renderAnimationFrames() {
	let outputDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
		.appendingPathComponent("previews")
		.appendingPathComponent("animation")
	let lightDir = outputDir.appendingPathComponent("light")
	let darkDir = outputDir.appendingPathComponent("dark")

	try? FileManager.default.createDirectory(at: lightDir, withIntermediateDirectories: true)
	try? FileManager.default.createDirectory(at: darkDir, withIntermediateDirectories: true)

	let frameCount = 30
	let compactSize = CGSize(width: 375, height: 132)
	let expandedSize = CGSize(width: 335, height: 420)
	let containerSize = CGSize(width: 415, height: 520)

	for frameIndex in 0..<frameCount {
		let t = Double(frameIndex) / Double(frameCount - 1)
		let progress = springProgress(t: t)

		let view = AnyView(
			AnimationPreviewContainer(
				progress: progress,
				compactSize: compactSize,
				expandedSize: expandedSize
			) {
				CompactTimelineView(items: conflictingItems, heightMode: .fixed(hours: 2))
			} expanded: {
				ExpandedTimelineContent(items: conflictingItems) {
					VStack(spacing: 4) {
						Text("January 20, 2025")
							.font(.headline)
						Text("3 events")
							.font(.subheadline)
							.foregroundStyle(.secondary)
					}
					.frame(maxWidth: .infinity)
					.padding()
				}
			}
			.frame(width: containerSize.width, height: containerSize.height)
			.background(Color(nsColor: .windowBackgroundColor))
		)

		let name = String(format: "frame_%03d", frameIndex)
		renderToFiles(name: name, view: view, size: containerSize, lightDir: lightDir, darkDir: darkDir)
	}

	print("Animation frames saved to \(outputDir.path)")
	print(
		"To create GIF: ffmpeg -framerate 30 -i previews/animation/light/frame_%03d.png -filter_complex \"[0:v]reverse,fifo[r];[0:v][r]concat=n=2:v=1[out];[out]fps=15,scale=400:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse\" previews/expand-animation.gif"
	)
}

@MainActor
func renderView<V: View>(_ view: V, size: CGSize) -> NSImage? {
	let hostingView = NSHostingView(rootView: view)
	hostingView.frame = CGRect(origin: .zero, size: size)

	let bitmapRep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds)
	guard let rep = bitmapRep else { return nil }
	hostingView.cacheDisplay(in: hostingView.bounds, to: rep)

	let image = NSImage(size: size)
	image.addRepresentation(rep)
	return image
}

func savePNG(_ image: NSImage, to url: URL) {
	guard let tiffData = image.tiffRepresentation,
		let bitmapRep = NSBitmapImageRep(data: tiffData),
		let pngData = bitmapRep.representation(using: .png, properties: [:])
	else { return }
	try? pngData.write(to: url)
}

@main
struct RenderPreviewsCLI {
	static func main() {
		if CommandLine.arguments.contains("--animation") {
			renderAnimationFrames()
		} else {
			renderAllPreviews()
		}
	}
}

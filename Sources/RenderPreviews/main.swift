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

	print("Done! Previews saved to \(outputDir.path)")
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
		renderAllPreviews()
	}
}

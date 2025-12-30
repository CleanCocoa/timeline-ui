import SwiftUI

/// A full-day timeline view with an hour grid.
///
/// Use `DayTimelineView` to display a complete daily schedule. The view automatically
/// expands to fill available vertical space, showing more hours when there's room.
///
/// ```swift
/// DayTimelineView(items: events)
/// ```
///
/// Events are positioned by their start and end times on an hour grid. Overlapping
/// events are automatically arranged side-by-side in columns.
///
/// ## All-Day Events
///
/// Events with `isAllDay: true` appear in a separate section at the top of the timeline,
/// above the hour grid.
///
/// ## Responsive Layout
///
/// The view uses a `GeometryReader` to detect available height and expands the visible
/// time range accordingly. Place it in a container with a defined height:
///
/// ```swift
/// DayTimelineView(items: events)
///     .frame(height: 500)
/// ```
public struct DayTimelineView: View {
	/// The events to display on the timeline.
	public let items: [TimelineItem]

	/// Creates a day timeline view.
	///
	/// - Parameter items: The events to display. Pass an empty array to show just the hour grid.
	///   The view centers on the first event's time, or the current time if no events are provided.
	public init(items: [TimelineItem]) {
		self.items = items
	}

	private let hourHeight: CGFloat = 44
	private let labelWidth: CGFloat = 48

	private var baseDate: Date {
		items.first(where: { $0.isPrimary })?.startDate ?? items.first?.startDate ?? Date()
	}

	private var allDayItems: [TimelineItem] {
		items.filter { $0.isAllDay }
	}

	private var timedItems: [TimelineItem] {
		items.filter { !$0.isAllDay }
	}

	private func timeRange(availableHeight: CGFloat) -> (start: Int, end: Int) {
		let calendar = Calendar.current

		guard let firstTimed = timedItems.first else {
			let hour = calendar.component(.hour, from: baseDate)
			return (max(0, hour - 1), min(23, hour + 2))
		}

		var earliestHour = calendar.component(.hour, from: firstTimed.startDate)
		var latestHour = earliestHour

		for item in timedItems {
			let startHour = hoursSinceBase(item.startDate)
			let endHour = hoursSinceBase(item.endDate)
			earliestHour = min(earliestHour, startHour)
			latestHour = max(latestHour, endHour)
		}

		var start = max(0, earliestHour - 1)
		var end = min(latestHour + 2, earliestHour + 24)

		let hoursNeeded = end - start + 1
		let hoursThatFit = Int(availableHeight / hourHeight)
		if hoursThatFit > hoursNeeded {
			let extraHours = hoursThatFit - hoursNeeded
			let expandBefore = extraHours / 2
			let expandAfter = extraHours - expandBefore
			start = max(0, start - expandBefore)
			end = min(23, end + expandAfter)
		}

		return (start, end)
	}

	private func hoursSinceBase(_ date: Date) -> Int {
		let calendar = Calendar.current
		let baseHour = calendar.component(.hour, from: baseDate)
		let hours = Int(date.timeIntervalSince(baseDate) / 3600)
		return baseHour + hours
	}

	public var body: some View {
		GeometryReader { geometry in
			let allDayHeight = allDayItems.isEmpty ? 0 : CGFloat(min(allDayItems.count, 3)) * 24 + 16
			let availableHeight = geometry.size.height - allDayHeight - 16
			let range = timeRange(availableHeight: availableHeight)
			let hours = Array(range.start...range.end)
			let contentWidth = geometry.size.width - labelWidth

			VStack(alignment: .leading, spacing: 8) {
				if !allDayItems.isEmpty {
					allDaySection
				}

				ZStack(alignment: .topLeading) {
					hourLines(hours: hours, contentWidth: contentWidth)

					ForEach(buildEventLayout()) { layoutItem in
						TimelineEventBlock(
							item: layoutItem.item,
							column: layoutItem.column,
							totalColumns: layoutItem.totalColumns,
							hourHeight: hourHeight,
							rangeStart: range.start,
							baseDate: baseDate,
							labelWidth: labelWidth,
							contentWidth: contentWidth
						)
					}
				}
			}
			.padding(.vertical, 8)
		}
	}

	private struct LayoutItem: Identifiable {
		let id: UUID
		let item: TimelineItem
		var column: Int = 0
		var totalColumns: Int = 1
	}

	private func buildEventLayout() -> [LayoutItem] {
		var layoutItems = timedItems.map { LayoutItem(id: $0.id, item: $0) }
		layoutItems.sort { $0.item.startDate < $1.item.startDate }

		var columns: [[LayoutItem]] = []
		for i in layoutItems.indices {
			var placed = false
			for colIndex in columns.indices {
				guard let lastInColumn = columns[colIndex].last else { continue }
				if layoutItems[i].item.startDate >= lastInColumn.item.endDate {
					columns[colIndex].append(layoutItems[i])
					layoutItems[i].column = colIndex
					placed = true
					break
				}
			}
			if !placed {
				layoutItems[i].column = columns.count
				columns.append([layoutItems[i]])
			}
		}

		let totalCols = max(columns.count, 1)
		for i in layoutItems.indices {
			layoutItems[i].totalColumns = totalCols
		}

		return layoutItems
	}

	private var allDaySection: some View {
		VStack(alignment: .leading, spacing: 4) {
			ForEach(allDayItems.prefix(3)) { item in
				HStack(spacing: 6) {
					RoundedRectangle(cornerRadius: 2)
						.fill(item.color)
						.frame(width: 4)
					Text(item.title)
						.font(.caption)
						.lineLimit(1)
				}
				.frame(height: 20)
			}
			if allDayItems.count > 3 {
				Text("+\(allDayItems.count - 3) more")
					.font(.caption2)
					.foregroundStyle(.secondary)
			}
		}
		.padding(.horizontal, labelWidth + 8)
	}

	private func hourLines(hours: [Int], contentWidth: CGFloat) -> some View {
		VStack(alignment: .leading, spacing: 0) {
			ForEach(hours, id: \.self) { hour in
				HStack(alignment: .top, spacing: 0) {
					Text(formatHour(hour % 24))
						.font(.caption)
						.foregroundStyle(.secondary)
						.frame(width: labelWidth, alignment: .trailing)
						.padding(.trailing, 8)
						.offset(y: -7)

					Rectangle()
						.fill(.quaternary)
						.frame(height: 1)
						.frame(maxWidth: .infinity)
				}
				.frame(height: hourHeight)
			}
		}
	}

	private func formatHour(_ hour: Int) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		let calendar = Calendar.current
		let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
		return formatter.string(from: date)
	}
}

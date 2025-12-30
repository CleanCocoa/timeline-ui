import SwiftUI

/// Controls how a ``CompactTimelineView`` determines its height.
///
/// Use `flexible` to fill available space, or `fixed(hours:)` for a specific time window.
///
/// ```swift
/// CompactTimelineView(items: events)                           // Fills container
/// CompactTimelineView(items: events, heightMode: .flexible)    // Same as above
/// CompactTimelineView(items: events, heightMode: .fixed(hours: 2))  // Shows ~2 hours
/// ```
public enum HeightMode: Sendable {
	/// The timeline expands to fill available vertical space.
	///
	/// Use this mode when embedding the timeline in a container with a defined height,
	/// such as a sheet, card, or fixed-size frame. The view calculates how many hours
	/// fit in the available space and displays that range.
	case flexible

	/// The timeline displays a fixed number of hours.
	///
	/// Use this mode for widgets or previews where you want a consistent height
	/// regardless of container size.
	///
	/// - Parameter hours: The number of hours to display. Values less than 1 are
	///   treated as 1 hour to ensure the timeline remains usable.
	///
	/// ```swift
	/// .fixed(hours: 2)  // Shows a 2-hour window
	/// .fixed(hours: 0)  // Treated as 1 hour
	/// ```
	case fixed(hours: Int)
}

/// A compact timeline view showing a focused window of hours.
///
/// Use `CompactTimelineView` for widgets, previews, or anywhere you need a condensed
/// view of upcoming events. The view automatically centers on the first event or
/// the current time if no events are provided.
///
/// ```swift
/// CompactTimelineView(items: events)
///     .frame(height: 200)
/// ```
///
/// Events are positioned by time, and overlapping events are arranged side-by-side
/// in columns.
///
/// ## Controlling Height
///
/// By default, the view uses ``HeightMode/flexible`` to fill available space.
/// Use ``HeightMode/fixed(hours:)`` for a consistent height:
///
/// ```swift
/// CompactTimelineView(items: events, heightMode: .fixed(hours: 2))
/// ```
public struct CompactTimelineView: View {
	/// The events to display on the timeline.
	public let items: [TimelineItem]

	/// How the view determines its height.
	public var heightMode: HeightMode

	/// Creates a compact timeline view.
	///
	/// - Parameters:
	///   - items: The events to display. Pass an empty array to show just the hour grid.
	///   - heightMode: How the view determines its height. Defaults to ``HeightMode/flexible``.
	public init(items: [TimelineItem], heightMode: HeightMode = .flexible) {
		self.items = items
		self.heightMode = heightMode
	}

	private let hourHeight: CGFloat = 44
	private let labelWidth: CGFloat = 48

	private var baseDate: Date {
		items.first(where: { $0.isPrimary })?.startDate ?? items.first?.startDate ?? Date()
	}

	private func timeRange(visibleHours: Int) -> (start: Int, end: Int) {
		let hours = max(visibleHours, 1)
		let calendar = Calendar.current
		let eventHour = calendar.component(.hour, from: baseDate)
		let start = max(0, eventHour - 1)
		let end = min(24, start + hours + 1)
		return (start, end)
	}

	private func timedItems(range: (start: Int, end: Int)) -> [TimelineItem] {
		items.filter { item in
			guard !item.isAllDay else { return false }
			let calendar = Calendar.current
			let itemHour = calendar.component(.hour, from: item.startDate)
			let itemEndHour = calendar.component(.hour, from: item.endDate)
			return itemHour <= range.end && itemEndHour >= range.start
		}
	}

	public var body: some View {
		switch heightMode {
		case .flexible:
			flexibleBody
		case .fixed(let hours):
			fixedBody(hours: hours)
		}
	}

	private var flexibleBody: some View {
		GeometryReader { geometry in
			let visibleHours = max(1, Int(geometry.size.height / hourHeight) - 1)
			let range = timeRange(visibleHours: visibleHours)
			let hours = Array(range.start...range.end)
			let contentWidth = geometry.size.width - labelWidth - 16

			ZStack(alignment: .topLeading) {
				hourLines(hours: hours, contentWidth: contentWidth)

				ForEach(buildEventLayout(range: range, contentWidth: contentWidth)) { layoutItem in
					compactEventBlock(layoutItem: layoutItem, range: range, contentWidth: contentWidth)
				}
			}
			.padding(.horizontal, 8)
		}
	}

	private func fixedBody(hours visibleHours: Int) -> some View {
		let normalizedHours = max(visibleHours, 1)
		let range = timeRange(visibleHours: normalizedHours)
		let hours = Array(range.start...range.end)

		return GeometryReader { geometry in
			let contentWidth = geometry.size.width - labelWidth - 16

			ZStack(alignment: .topLeading) {
				hourLines(hours: hours, contentWidth: contentWidth)

				ForEach(buildEventLayout(range: range, contentWidth: contentWidth)) { layoutItem in
					compactEventBlock(layoutItem: layoutItem, range: range, contentWidth: contentWidth)
				}
			}
		}
		.padding(.horizontal, 8)
		.frame(height: CGFloat(normalizedHours + 1) * hourHeight)
	}

	private struct LayoutItem: Identifiable {
		let id: UUID
		let item: TimelineItem
		var column: Int = 0
		var totalColumns: Int = 1
	}

	private func buildEventLayout(range: (start: Int, end: Int), contentWidth: CGFloat) -> [LayoutItem] {
		var layoutItems = timedItems(range: range).map { LayoutItem(id: $0.id, item: $0) }
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

	private func compactEventBlock(layoutItem: LayoutItem, range: (start: Int, end: Int), contentWidth: CGFloat)
		-> some View
	{
		let item = layoutItem.item
		let calendar = Calendar.current
		let eventHour = calendar.component(.hour, from: baseDate)
		let hoursSinceBase = item.startDate.timeIntervalSince(baseDate) / 3600.0
		let actualHour = Double(eventHour) + hoursSinceBase
		let hoursFromRangeStart = actualHour - Double(range.start)
		let yOffset = CGFloat(hoursFromRangeStart) * hourHeight

		let duration = item.endDate.timeIntervalSince(item.startDate)
		let durationHours = duration / 3600.0
		let blockHeight = max(CGFloat(durationHours) * hourHeight, 24)

		let availableWidth = contentWidth - 8
		let blockWidth = availableWidth / CGFloat(layoutItem.totalColumns)
		let xOffset = labelWidth + 8 + (blockWidth * CGFloat(layoutItem.column))

		return ZStack(alignment: .topLeading) {
			HStack(spacing: 0) {
				Rectangle()
					.fill(item.color)
					.frame(width: 4)
				Spacer(minLength: 0)
			}
			Text(item.title)
				.font(.caption2.bold())
				.lineLimit(1)
				.padding(.leading, 8)
				.padding(.top, 4)
		}
		.frame(width: blockWidth - 2, height: blockHeight)
		.background(item.isPrimary ? item.color.opacity(0.15) : item.color.opacity(0.2))
		.clipShape(RoundedRectangle(cornerRadius: 4))
		.offset(x: xOffset, y: yOffset)
	}

	private func hourLines(hours: [Int], contentWidth: CGFloat) -> some View {
		VStack(alignment: .leading, spacing: 0) {
			ForEach(hours, id: \.self) { hour in
				HStack(alignment: .top, spacing: 0) {
					Text(formatHour(hour))
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

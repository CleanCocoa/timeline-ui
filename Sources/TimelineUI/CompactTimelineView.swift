import SwiftUI

public enum HeightMode: Sendable {
	case flexible
	case fixed(hours: Int)
}

public struct CompactTimelineView: View {
	public let items: [TimelineItem]
	public var heightMode: HeightMode

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

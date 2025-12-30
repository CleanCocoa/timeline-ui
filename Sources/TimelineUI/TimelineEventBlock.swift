import SwiftUI

struct TimelineEventBlock: View {
	let item: TimelineItem
	let column: Int
	let totalColumns: Int
	let hourHeight: CGFloat
	let rangeStart: Int
	let baseDate: Date
	let labelWidth: CGFloat
	let contentWidth: CGFloat

	private var yOffset: CGFloat {
		let calendar = Calendar.current
		let baseHour = calendar.component(.hour, from: baseDate)
		let hoursSinceBase = item.startDate.timeIntervalSince(baseDate) / 3600.0
		let actualHour = Double(baseHour) + hoursSinceBase
		let hoursFromRangeStart = actualHour - Double(rangeStart)
		return CGFloat(hoursFromRangeStart) * hourHeight
	}

	private var blockHeight: CGFloat {
		let duration = item.endDate.timeIntervalSince(item.startDate)
		let hours = duration / 3600.0
		return max(CGFloat(hours) * hourHeight, 24)
	}

	private var blockWidth: CGFloat {
		let availableWidth = contentWidth - 16
		return availableWidth / CGFloat(totalColumns)
	}

	private var xOffset: CGFloat {
		labelWidth + 8 + (blockWidth * CGFloat(column))
	}

	var body: some View {
		ZStack(alignment: .topLeading) {
			HStack(spacing: 0) {
				Rectangle()
					.fill(item.color)
					.frame(width: 4)
				Spacer(minLength: 0)
			}
			VStack(alignment: .leading, spacing: 0) {
				Text(item.title)
					.font(.caption2.bold())
					.lineLimit(1)
				if let location = item.location, blockHeight > 30 {
					Text(location)
						.font(.caption2)
						.lineLimit(1)
						.foregroundStyle(.secondary)
				}
			}
			.padding(.leading, 8)
			.padding(.top, 4)
		}
		.frame(width: blockWidth - 2, height: blockHeight)
		.background(item.isPrimary ? item.color.opacity(0.15) : item.color.opacity(0.2))
		.clipShape(RoundedRectangle(cornerRadius: 4))
		.offset(x: xOffset, y: yOffset)
	}
}

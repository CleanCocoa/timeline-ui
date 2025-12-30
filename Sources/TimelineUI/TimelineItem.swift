import SwiftUI

public struct TimelineItem: Identifiable, Sendable {
	public let id: UUID
	public let title: String
	public let startDate: Date
	public let endDate: Date
	public let isAllDay: Bool
	public let color: Color
	public let location: String?
	public let isPrimary: Bool

	public init(
		id: UUID = UUID(),
		title: String,
		startDate: Date,
		endDate: Date,
		isAllDay: Bool = false,
		color: Color,
		location: String? = nil,
		isPrimary: Bool = false
	) {
		self.id = id
		self.title = title
		self.startDate = startDate
		self.endDate = endDate
		self.isAllDay = isAllDay
		self.color = color
		self.location = location
		self.isPrimary = isPrimary
	}
}

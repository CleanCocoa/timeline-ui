import EventKit
import SwiftUI
import TimelineUI

extension TimelineItem {
	public init(_ event: EKEvent, isPrimary: Bool = false) {
		self.init(
			title: event.title ?? "Untitled",
			startDate: event.startDate,
			endDate: event.endDate,
			isAllDay: event.isAllDay,
			color: Color(cgColor: event.calendar.cgColor),
			location: event.location,
			isPrimary: isPrimary
		)
	}
}

extension [EKEvent] {
	public func asTimelineItems(primaryEventID: String? = nil) -> [TimelineItem] {
		map { event in
			TimelineItem(event, isPrimary: event.eventIdentifier == primaryEventID)
		}
	}
}

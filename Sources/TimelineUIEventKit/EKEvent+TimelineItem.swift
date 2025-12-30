import EventKit
import SwiftUI
import TimelineUI

extension EKEvent {
	public func asTimelineItem(isPrimary: Bool = false) -> TimelineItem {
		TimelineItem(
			title: title ?? "Untitled",
			startDate: startDate,
			endDate: endDate,
			isAllDay: isAllDay,
			color: Color(cgColor: calendar.cgColor),
			location: location,
			isPrimary: isPrimary
		)
	}
}

extension [EKEvent] {
	public func asTimelineItems(primaryEventID: String? = nil) -> [TimelineItem] {
		map { event in
			event.asTimelineItem(isPrimary: event.eventIdentifier == primaryEventID)
		}
	}
}

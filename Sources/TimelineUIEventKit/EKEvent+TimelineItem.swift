import EventKit
import SwiftUI
import TimelineUI

extension TimelineItem {
	/// Creates a timeline item from an EventKit event.
	///
	/// Use this initializer to convert calendar events for display in a timeline view.
	///
	/// ```swift
	/// let item = TimelineItem(ekEvent)
	/// let primaryItem = TimelineItem(ekEvent, isPrimary: true)
	/// ```
	///
	/// - Parameters:
	///   - event: The EventKit event to convert.
	///   - isPrimary: Whether this event should be visually distinguished as the primary/selected event.
	///     Primary events render with a lighter background. Defaults to `false`.
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

	/// Creates an array of timeline items from EventKit events.
	///
	/// Use this factory when you have an array of `EKEvent` and need `[TimelineItem]` for a timeline view.
	///
	/// ```swift
	/// let items = TimelineItem.items(from: ekEvents)
	/// let items = TimelineItem.items(from: ekEvents, primaryEventID: selectedEvent.eventIdentifier)
	/// ```
	///
	/// - Parameters:
	///   - events: The EventKit events to convert.
	///   - primaryEventID: The `eventIdentifier` of the event to mark as primary.
	///     The matching event renders with a lighter background to distinguish it from others.
	/// - Returns: An array of timeline items ready for display.
	public static func items(from events: [EKEvent], primaryEventID: String? = nil) -> [TimelineItem] {
		events.map { event in
			TimelineItem(event, isPrimary: event.eventIdentifier == primaryEventID)
		}
	}
}

extension [EKEvent] {
	/// Converts an array of EventKit events to timeline items.
	///
	/// Use this convenience method to transform calendar events for display in a timeline view.
	///
	/// ```swift
	/// let items = ekEvents.asTimelineItems()
	/// let items = ekEvents.asTimelineItems(primaryEventID: selectedEvent.eventIdentifier)
	/// ```
	///
	/// - Parameter primaryEventID: The `eventIdentifier` of the event to mark as primary.
	///   The matching event renders with a lighter background to distinguish it from others.
	///   Pass `nil` (the default) to treat all events equally.
	/// - Returns: An array of timeline items ready for display.
	public func asTimelineItems(primaryEventID: String? = nil) -> [TimelineItem] {
		TimelineItem.items(from: self, primaryEventID: primaryEventID)
	}
}

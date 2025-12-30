import SwiftUI

/// A calendar event for display in a timeline view.
///
/// `TimelineItem` is the view model for events displayed in ``DayTimelineView`` and
/// ``CompactTimelineView``. Create items from your calendar data and pass them to
/// the timeline views.
///
/// ```swift
/// let meeting = TimelineItem(
///     title: "Team Meeting",
///     startDate: Date(),
///     endDate: Date().addingTimeInterval(3600),
///     color: .blue,
///     location: "Conference Room A"
/// )
///
/// DayTimelineView(items: [meeting])
/// ```
///
/// ## EventKit Integration
///
/// Import `TimelineUIEventKit` to create items directly from `EKEvent`:
///
/// ```swift
/// import TimelineUIEventKit
///
/// let item = TimelineItem(ekEvent)
/// ```
public struct TimelineItem: Identifiable, Sendable {
	/// A unique identifier for this item.
	public let id: UUID

	/// The event title displayed in the timeline block.
	public let title: String

	/// When the event starts.
	public let startDate: Date

	/// When the event ends.
	public let endDate: Date

	/// Whether this is an all-day event.
	///
	/// All-day events appear in a separate section above the hour grid
	/// in ``DayTimelineView``.
	public let isAllDay: Bool

	/// The accent color for this event's block.
	///
	/// Use distinct colors to differentiate calendar sources or event types.
	public let color: Color

	/// An optional location shown below the title.
	public let location: String?

	/// Whether this event should be visually distinguished as the primary/selected event.
	///
	/// Primary events render with a lighter, more translucent background. Use this
	/// to highlight a newly created event or the currently selected event among
	/// existing calendar events.
	public let isPrimary: Bool

	/// Creates a timeline item.
	///
	/// - Parameters:
	///   - id: A unique identifier. Defaults to a new UUID.
	///   - title: The event title.
	///   - startDate: When the event starts.
	///   - endDate: When the event ends.
	///   - isAllDay: Whether this is an all-day event. Defaults to `false`.
	///   - color: The accent color for the event block.
	///   - location: An optional location string. Defaults to `nil`.
	///   - isPrimary: Whether to highlight this as the primary event. Defaults to `false`.
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

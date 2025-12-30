import SwiftUI

/// Identifier for matched geometry effects in timeline transitions.
public enum TimelineTransitionID: Hashable {
	/// The default identifier for timeline background transitions.
	case background
	/// A custom identifier for additional matched geometry effects.
	case custom(String)
}

/// A view modifier that applies matched geometry effects for smooth timeline expand/collapse animations.
///
/// Apply this modifier to both the compact and expanded timeline views using the same namespace
/// to create a smooth morphing animation between states.
///
/// Use the ``SwiftUICore/View/timelineTransition(id:in:)`` modifier for convenient access:
///
/// ```swift
/// @Namespace private var namespace
///
/// CompactTimelineView(items: items)
///     .timelineTransition(in: namespace)
/// ```
public struct TimelineTransitionModifier: ViewModifier {
	let id: TimelineTransitionID
	let namespace: Namespace.ID

	public init(id: TimelineTransitionID = .background, in namespace: Namespace.ID) {
		self.id = id
		self.namespace = namespace
	}

	public func body(content: Content) -> some View {
		content
			.matchedGeometryEffect(id: id, in: namespace)
	}
}

extension View {
	public func timelineTransition(
		id: TimelineTransitionID = .background,
		in namespace: Namespace.ID
	) -> some View {
		modifier(TimelineTransitionModifier(id: id, in: namespace))
	}
}

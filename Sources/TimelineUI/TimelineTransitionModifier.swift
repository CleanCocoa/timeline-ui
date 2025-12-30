import SwiftUI

public enum TimelineTransitionID: Hashable {
	case background
	case custom(String)
}

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

import SwiftUI

public struct ExpandableTimelineContainer<Header: View>: View {
	@Binding var isExpanded: Bool
	let compactCornerRadius: CGFloat
	let expandedCornerRadius: CGFloat
	let compactContent: (Namespace.ID) -> CompactTimelineView
	let expandedContent: (Namespace.ID) -> ExpandedTimelineContent<Header>

	@Namespace private var namespace

	public init(
		isExpanded: Binding<Bool>,
		compactCornerRadius: CGFloat = 12,
		expandedCornerRadius: CGFloat = 20,
		@ViewBuilder compact: @escaping (Namespace.ID) -> CompactTimelineView,
		@ViewBuilder expanded: @escaping (Namespace.ID) -> ExpandedTimelineContent<Header>
	) {
		self._isExpanded = isExpanded
		self.compactCornerRadius = compactCornerRadius
		self.expandedCornerRadius = expandedCornerRadius
		self.compactContent = compact
		self.expandedContent = expanded
	}

	public var body: some View {
		compactContent(namespace)
			.clipShape(RoundedRectangle(cornerRadius: compactCornerRadius))
			.background(.regularMaterial, in: RoundedRectangle(cornerRadius: compactCornerRadius))
			.timelineTransition(in: namespace)
			.contentShape(Rectangle())
			.onTapGesture {
				withAnimation(.spring(duration: 0.4, bounce: 0.15)) {
					isExpanded = true
				}
			}
	}

	public var expandedOverlay: some View {
		ZStack {
			Color.black.opacity(0.4)
				.ignoresSafeArea()
				.onTapGesture {
					withAnimation(.spring(duration: 0.4, bounce: 0.15)) {
						isExpanded = false
					}
				}

			expandedContent(namespace)
				.background(.regularMaterial, in: RoundedRectangle(cornerRadius: expandedCornerRadius))
				.timelineTransition(in: namespace)
				.padding(.horizontal, 20)
				.padding(.vertical, 60)
		}
		.transition(.opacity)
	}
}

extension ExpandableTimelineContainer {
	public init(
		items: [TimelineItem],
		isExpanded: Binding<Bool>,
		compactHeightMode: HeightMode = .fixed(hours: 2),
		compactCornerRadius: CGFloat = 12,
		expandedCornerRadius: CGFloat = 20,
		@ViewBuilder header: @escaping () -> Header
	) {
		self.init(
			isExpanded: isExpanded,
			compactCornerRadius: compactCornerRadius,
			expandedCornerRadius: expandedCornerRadius,
			compact: { _ in
				CompactTimelineView(items: items, heightMode: compactHeightMode)
			},
			expanded: { _ in
				ExpandedTimelineContent(items: items, header: header)
			}
		)
	}
}

#Preview {
	struct PreviewWrapper: View {
		@State private var isExpanded = false
		@Namespace private var timelineNamespace

		private var items: [TimelineItem] {
			let base = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
			return [
				TimelineItem(
					title: "New Event",
					startDate: base.addingTimeInterval(1800),
					endDate: base.addingTimeInterval(5400),
					color: .accentColor,
					location: "Main Office",
					isPrimary: true
				),
				TimelineItem(
					title: "Existing Meeting",
					startDate: base,
					endDate: base.addingTimeInterval(3600),
					color: .red,
					location: "Room 101",
					isPrimary: false
				),
				TimelineItem(
					title: "Another Meeting",
					startDate: base.addingTimeInterval(3600),
					endDate: base.addingTimeInterval(7200),
					color: .orange,
					isPrimary: false
				),
			]
		}

		var body: some View {
			ScrollView {
				VStack {
					Text("Tap the timeline to expand")
						.font(.caption)
						.foregroundStyle(.secondary)
						.padding(.top, 40)

					CompactTimelineView(items: items, heightMode: .fixed(hours: 2))
						.frame(height: 132)
						.clipShape(RoundedRectangle(cornerRadius: 12))
						.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
						.timelineTransition(in: timelineNamespace)
						.padding(.horizontal)
						.onTapGesture {
							withAnimation(.spring(duration: 0.4, bounce: 0.15)) {
								isExpanded = true
							}
						}

					Spacer(minLength: 400)
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color(white: 0.95))
			.overlay {
				if isExpanded {
					ZStack {
						Color.black.opacity(0.4)
							.ignoresSafeArea()
							.onTapGesture {
								withAnimation(.spring(duration: 0.4, bounce: 0.15)) {
									isExpanded = false
								}
							}

						ExpandedTimelineContent(items: items) {
							VStack(spacing: 4) {
								Text("January 20, 2025")
									.font(.headline)
								Text("3 events")
									.font(.subheadline)
									.foregroundStyle(.secondary)
							}
							.frame(maxWidth: .infinity)
							.padding()
						}
						.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
						.timelineTransition(in: timelineNamespace)
						.padding(.horizontal, 20)
						.padding(.vertical, 60)
					}
					.transition(.opacity)
				}
			}
		}
	}

	return PreviewWrapper()
}

public struct ExpandedTimelineContent<Header: View>: View {
	public typealias Header = Header

	let items: [TimelineItem]
	let header: () -> Header

	public init(
		items: [TimelineItem],
		@ViewBuilder header: @escaping () -> Header
	) {
		self.items = items
		self.header = header
	}

	public var body: some View {
		VStack(spacing: 0) {
			header()
			Divider()
			DayTimelineView(items: items)
				.padding()
		}
	}
}

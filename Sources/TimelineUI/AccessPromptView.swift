import SwiftUI

public struct AccessPromptView: View {
	public enum Style {
		case compact
		case expanded
	}

	let style: Style
	let icon: String
	let title: String
	let message: String
	let buttonLabel: String
	let onRequestAccess: () async -> Void

	public init(
		style: Style = .compact,
		icon: String = "lock.fill",
		title: String = "Access Required",
		message: String = "Grant access to view this content",
		buttonLabel: String = "Grant Access",
		onRequestAccess: @escaping () async -> Void
	) {
		self.style = style
		self.icon = icon
		self.title = title
		self.message = message
		self.buttonLabel = buttonLabel
		self.onRequestAccess = onRequestAccess
	}

	public var body: some View {
		switch style {
		case .compact:
			compactContent
		case .expanded:
			expandedContent
		}
	}

	private var compactContent: some View {
		VStack(spacing: 8) {
			Text(title)
				.font(.subheadline.weight(.medium))
			Text(message)
				.font(.caption)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
			Button {
				Task {
					await onRequestAccess()
				}
			} label: {
				Label(buttonLabel, systemImage: icon)
					.font(.callout)
			}
			.buttonStyle(.bordered)
			.controlSize(.small)
		}
		.padding()
	}

	private var expandedContent: some View {
		VStack(spacing: 16) {
			Spacer()

			Image(systemName: icon)
				.font(.system(size: 48))
				.foregroundStyle(.secondary)

			Text(title)
				.font(.title3.weight(.semibold))

			Text(message)
				.font(.callout)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal)

			Button {
				Task {
					await onRequestAccess()
				}
			} label: {
				Label(buttonLabel, systemImage: icon)
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
			.padding(.horizontal)

			Spacer()
		}
		.padding()
	}
}

extension AccessPromptView {
	public static func calendar(
		style: Style = .compact,
		title: String? = nil,
		message: String? = nil,
		buttonLabel: String? = nil,
		onRequestAccess: @escaping () async -> Void
	) -> AccessPromptView {
		AccessPromptView(
			style: style,
			icon: "calendar.badge.checkmark",
			title: title ?? (style == .compact ? "See your schedule" : "See Your Schedule"),
			message: message ?? "Allow calendar access to show your events",
			buttonLabel: buttonLabel ?? (style == .compact ? "Grant Access" : "Grant Calendar Access"),
			onRequestAccess: onRequestAccess
		)
	}
}

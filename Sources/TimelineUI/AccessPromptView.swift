import SwiftUI

public struct AccessPromptView<Icon: View, ButtonLabel: View>: View {
	public enum Style {
		case compact
		case expanded
	}

	let style: Style
	let icon: Icon
	let title: String
	let message: String
	let buttonLabel: ButtonLabel
	let onRequestAccess: () async -> Void

	public init(
		style: Style = .compact,
		title: String = "Access Required",
		message: String = "Grant access to view this content",
		@ViewBuilder icon: () -> Icon,
		@ViewBuilder buttonLabel: () -> ButtonLabel,
		onRequestAccess: @escaping () async -> Void
	) {
		self.style = style
		self.icon = icon()
		self.title = title
		self.message = message
		self.buttonLabel = buttonLabel()
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
				buttonLabel
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

			icon
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
				buttonLabel
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

extension AccessPromptView where Icon == Image, ButtonLabel == Label<Text, Image> {
	public init(
		style: Style = .compact,
		icon: String = "lock.fill",
		title: String = "Access Required",
		message: String = "Grant access to view this content",
		buttonLabel: String = "Grant Access",
		onRequestAccess: @escaping () async -> Void
	) {
		self.init(
			style: style,
			title: title,
			message: message,
			icon: { Image(systemName: icon) },
			buttonLabel: { Label(buttonLabel, systemImage: icon) },
			onRequestAccess: onRequestAccess
		)
	}

	public static func calendar(
		style: Style = .compact,
		title: String? = nil,
		message: String? = nil,
		buttonLabel: String? = nil,
		onRequestAccess: @escaping () async -> Void
	) -> AccessPromptView {
		let iconName = "calendar.badge.checkmark"
		return AccessPromptView(
			style: style,
			title: title ?? (style == .compact ? "See your schedule" : "See Your Schedule"),
			message: message ?? "Allow calendar access to show your events",
			icon: { Image(systemName: iconName) },
			buttonLabel: {
				Label(
					buttonLabel ?? (style == .compact ? "Grant Access" : "Grant Calendar Access"),
					systemImage: iconName
				)
			},
			onRequestAccess: onRequestAccess
		)
	}
}

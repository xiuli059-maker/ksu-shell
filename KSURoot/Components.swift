import SwiftUI

// MARK: - Large title bar (Material LargeFlexibleTopAppBar equivalent)
struct LargeTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 34, weight: .bold))
            .foregroundColor(Theme.onSurface)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 6)
    }
}

// MARK: - Segmented column (Material SegmentedList equivalent)
struct SegmentedColumn<Content: View>: View {
    var title: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.primary)
                    .padding(.leading, 16)
            }
            VStack(spacing: 0) {
                content()
            }
            .background(Theme.surfaceBright)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

// MARK: - Generic segmented row
struct SegmentedRow: View {
    var icon: String? = nil
    let title: String
    var subtitle: String? = nil
    var trailing: AnyView? = nil
    var action: (() -> Void)? = nil

    private var hasSubtitle: Bool { subtitle?.isEmpty == false }

    var body: some View {
        HStack(spacing: 16) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Theme.onSurfaceVariant)
                    .frame(width: 24)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.onSurface)
                if let subtitle = subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(Theme.onSurfaceVariant)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 8)
            if let trailing = trailing {
                trailing
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, hasSubtitle ? 12 : 14)
        .contentShape(Rectangle())
        .onTapGesture { action?() }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Theme.outline.opacity(0.12))
                .frame(height: 0.5)
                .padding(.leading, icon != nil ? 56 : 16)
        }
    }
}

// MARK: - Switch row
struct SegmentedSwitchRow: View {
    var icon: String? = nil
    let title: String
    var subtitle: String? = nil
    @Binding var isOn: Bool

    var body: some View {
        SegmentedRow(
            icon: icon,
            title: title,
            subtitle: subtitle,
            trailing: AnyView(
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(Theme.primary)
            )
        )
    }
}

// MARK: - Link row (with chevron)
struct SegmentedLinkRow: View {
    var icon: String? = nil
    let title: String
    var subtitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        SegmentedRow(
            icon: icon,
            title: title,
            subtitle: subtitle,
            trailing: AnyView(
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.onSurfaceVariant)
            ),
            action: action
        )
    }
}

// MARK: - Tonal card (Material TonalCard / Card equivalent)
struct TonalCard<Content: View>: View {
    @ViewBuilder let content: () -> Content
    var body: some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.surfaceBright)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Status tag (Material StatusTag equivalent)
struct StatusTag: View {
    let text: String
    var background: Color = Theme.primary
    var foreground: Color = Theme.onPrimary

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .foregroundColor(foreground)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - Section spacing helper
struct SectionGap: View {
    var body: some View { Color.clear.frame(height: 13) }
}
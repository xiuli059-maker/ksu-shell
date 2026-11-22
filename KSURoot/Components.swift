import SwiftUI

// MARK: - Large title bar (Material LargeFlexibleTopAppBar equivalent)
struct LargeTitle: View {
    @EnvironmentObject var theme: ThemeManager
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 34, weight: .bold))
            .foregroundColor(theme.palette.onSurface)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 6)
    }
}

// MARK: - Segmented column (Material SegmentedList equivalent)
struct SegmentedColumn<Content: View>: View {
    @EnvironmentObject var theme: ThemeManager
    var title: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(theme.palette.primary)
                    .padding(.leading, 16)
            }
            VStack(spacing: 0) {
                content()
            }
            .background(theme.palette.surfaceBright)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

// MARK: - Generic segmented row
struct SegmentedRow: View {
    @EnvironmentObject var theme: ThemeManager
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
                    .foregroundColor(theme.palette.onSurfaceVariant)
                    .frame(width: 24)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(theme.palette.onSurface)
                if let subtitle = subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(theme.palette.onSurfaceVariant)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 8)
            if let trailing = trailing { trailing }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, hasSubtitle ? 12 : 14)
        .contentShape(Rectangle())
        .onTapGesture { action?() }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(theme.palette.outline.opacity(0.12))
                .frame(height: 0.5)
                .padding(.leading, icon != nil ? 56 : 16)
        }
    }
}

// MARK: - Switch row
struct SegmentedSwitchRow: View {
    @EnvironmentObject var theme: ThemeManager
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
                    .tint(theme.palette.primary)
            )
        )
    }
}

// MARK: - Link row (with chevron)
struct SegmentedLinkRow: View {
    @EnvironmentObject var theme: ThemeManager
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
                    .foregroundColor(theme.palette.onSurfaceVariant)
            ),
            action: action
        )
    }
}

// MARK: - Tonal card
struct TonalCard<Content: View>: View {
    @EnvironmentObject var theme: ThemeManager
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.palette.surfaceBright)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Status tag
struct StatusTag: View {
    let text: String
    var background: Color = Color(hex: 0xA9D6A3)
    var foreground: Color = Color(hex: 0x0B3A11)

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

// MARK: - Empty state
struct EmptyPlaceholder: View {
    @EnvironmentObject var theme: ThemeManager
    let icon: String
    let text: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 46))
                .foregroundColor(theme.palette.onSurfaceVariant.opacity(0.6))
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(theme.palette.onSurfaceVariant)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
}
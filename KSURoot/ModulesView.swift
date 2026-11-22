import SwiftUI

struct ModuleView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var modules = MockData.modules

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                LargeTitle(text: "模块")
                if modules.isEmpty {
                    EmptyPlaceholder(icon: "puzzlepiece.extension", text: "暂无已安装模块")
                } else {
                    VStack(spacing: 13) {
                        ForEach($modules) { $module in
                            ModuleCard(module: $module)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 110)
                }
            }
        }
        .background(theme.palette.surface.ignoresSafeArea())
    }
}

struct ModuleCard: View {
    @EnvironmentObject var theme: ThemeManager
    @Binding var module: ModuleEntry

    var body: some View {
        TonalCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(module.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(theme.palette.onSurface)
                            .strikethrough(module.markedRemove)
                        Text("版本: \(module.version)")
                            .font(.system(size: 12))
                            .foregroundColor(theme.palette.onSurfaceVariant)
                        Text("作者: \(module.author)")
                            .font(.system(size: 12))
                            .foregroundColor(theme.palette.onSurfaceVariant)
                    }
                    Spacer(minLength: 8)
                    Toggle("", isOn: $module.enabled)
                        .labelsHidden()
                        .tint(theme.palette.primary)
                        .disabled(module.markedRemove)
                }

                if !module.detail.isEmpty {
                    Text(module.detail)
                        .font(.system(size: 14))
                        .foregroundColor(theme.palette.onSurfaceVariant)
                }

                if module.meta {
                    StatusTag(text: "META", background: theme.palette.primary, foreground: theme.palette.onPrimary)
                }

                Divider().overlay(theme.palette.outline.opacity(0.15))

                HStack(spacing: 12) {
                    if module.hasAction {
                        pillButton("play.fill", bg: theme.palette.secondaryContainer, fg: theme.palette.onSecondaryContainer)
                    }
                    if module.hasWebUi {
                        pillButton("chevron.left.forwardslash.chevron.right", bg: theme.palette.secondaryContainer, fg: theme.palette.onSecondaryContainer)
                    }
                    Spacer()
                    if module.hasUpdate {
                        Button { } label: {
                            Label("更新", systemImage: "arrow.down.circle")
                                .font(.system(size: 13))
                                .foregroundColor(theme.palette.primary)
                        }
                    }
                    pillButton(module.markedRemove ? "arrow.uturn.backward" : "trash",
                               bg: theme.palette.surfaceContainerHigh,
                               fg: module.markedRemove ? theme.palette.onSurfaceVariant : theme.palette.error)
                }
            }
            .padding(16)
        }
    }

    private func pillButton(_ systemName: String, bg: Color, fg: Color) -> some View {
        Button { } label: {
            Image(systemName: systemName)
                .font(.system(size: 14))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(bg)
                .foregroundColor(fg)
                .clipShape(Capsule())
        }
    }
}
import SwiftUI

struct ModuleView: View {
    @State private var modules = MockData.modules

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                LargeTitle(text: "模块")
                VStack(spacing: 13) {
                    ForEach($modules) { $module in
                        ModuleCard(module: $module)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Theme.surface.ignoresSafeArea())
    }
}

struct ModuleCard: View {
    @Binding var module: ModuleEntry

    var body: some View {
        TonalCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(module.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.onSurface)
                            .strikethrough(module.markedRemove)
                        Text("版本: \(module.version)")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.onSurfaceVariant)
                        Text("作者: \(module.author)")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.onSurfaceVariant)
                    }
                    Spacer(minLength: 8)
                    Toggle("", isOn: $module.enabled)
                        .labelsHidden()
                        .tint(Theme.primary)
                        .disabled(module.markedRemove)
                }

                if !module.detail.isEmpty {
                    Text(module.detail)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.onSurfaceVariant)
                }

                if module.meta {
                    StatusTag(text: "META")
                }

                Divider().overlay(Theme.outline.opacity(0.15))

                HStack(spacing: 12) {
                    if module.hasAction {
                        pillButton("play.fill", bg: Theme.secondaryContainer, fg: Theme.onSecondaryContainer)
                    }
                    if module.hasWebUi {
                        pillButton("chevron.left.forwardslash.chevron.right", bg: Theme.secondaryContainer, fg: Theme.onSecondaryContainer)
                    }
                    Spacer()
                    if module.hasUpdate {
                        Button { } label: {
                            Label("更新", systemImage: "arrow.down.circle")
                                .font(.system(size: 13))
                                .foregroundColor(Theme.primary)
                        }
                    }
                    pillButton(module.markedRemove ? "arrow.uturn.backward" : "trash",
                               bg: Theme.surfaceContainerHigh,
                               fg: module.markedRemove ? Theme.onSurfaceVariant : Theme.error)
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
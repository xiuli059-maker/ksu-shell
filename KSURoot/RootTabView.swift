import SwiftUI

struct RootView: View {
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var appState: AppState
    @State private var selection = 0

    @ViewBuilder private var pages: some View {
        if theme.enableSwipeDismiss {
            TabView(selection: $selection) {
                HomeView().tag(0)
                SuperUserView().tag(1)
                ModuleView().tag(2)
                SettingsView().tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        } else {
            Group {
                switch selection {
                case 0: HomeView()
                case 1: SuperUserView()
                case 2: ModuleView()
                default: SettingsView()
                }
            }
        }
    }

    var body: some View {
        Group {
            if theme.enableFloatingBar {
                ZStack(alignment: .bottom) {
                    pages
                    GlassBottomBar(selection: $selection, floating: true)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 6)
                }
            } else {
                VStack(spacing: 0) {
                    pages
                    GlassBottomBar(selection: $selection, floating: false)
                }
            }
        }
        .background(theme.palette.surface.ignoresSafeArea())
        .fullScreenCover(item: Binding(get: { appState.route }, set: { appState.route = $0 })) { route in
            ScreenHost(route: route)
                .environmentObject(theme)
                .environmentObject(appState)
        }
    }
}

// BottomBarMiuix / FloatingBottomBar：贴底 NavigationBar(默认, BlurredBar 模糊) 或 悬浮胶囊(FloatingBottomBar)
struct GlassBottomBar: View {
    @EnvironmentObject var theme: ThemeManager
    @Binding var selection: Int
    var floating: Bool = false
    @Namespace private var ns

    private let items: [(title: String, icon: String)] = [
        ("主页", "house.fill"),
        ("超级用户", "shield.fill"),
        ("模块", "puzzlepiece.fill"),
        ("设置", "gearshape.fill")
    ]

    private var useGlass: Bool {
        floating ? (theme.enableBlur && theme.enableFloatingBarBlur) : theme.enableBlur
    }

    var body: some View {
        if floating {
            floatingBar
        } else {
            dockedBar
        }
    }

    private var tabsRow: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) { selection = i }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: items[i].icon)
                            .font(.system(size: 20, weight: .medium))
                        Text(items[i].title)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(selection == i ? theme.palette.primary : theme.palette.onSurfaceVariant)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background {
                        if selection == i {
                            Capsule()
                                .fill(floating && useGlass ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(theme.palette.primary.opacity(floating ? 0.16 : 0.14)))
                                .overlay(Capsule().stroke(Color.white.opacity(floating && useGlass ? 0.22 : 0.0), lineWidth: 0.75))
                                .matchedGeometryEffect(id: "indicator", in: ns)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var floatingBar: some View {
        tabsRow
            .padding(4)
            .background {
                if useGlass {
                    ZStack {
                        Capsule().fill(.ultraThinMaterial)
                        Capsule().fill(theme.palette.surfaceContainer.opacity(0.30))
                    }
                } else {
                    Capsule().fill(theme.palette.surfaceContainer)
                }
            }
            .overlay(Capsule().stroke(Color.white.opacity(useGlass ? 0.16 : 0.06), lineWidth: 0.75))
            .shadow(color: .black.opacity(0.30), radius: 16, y: 8)
    }

    private var dockedBar: some View {
        VStack(spacing: 0) {
            tabsRow
                .padding(.horizontal, 24)
                .padding(.top, 4)
                .padding(.bottom, 2)
        }
        .frame(maxWidth: .infinity)
        .background {
            if useGlass {
                Rectangle().fill(.ultraThinMaterial)
            } else {
                Rectangle().fill(theme.palette.surfaceContainer)
            }
        }
        .overlay(alignment: .top) {
            Rectangle().fill(theme.palette.outline.opacity(0.12)).frame(height: 0.5)
        }
    }
}

struct SearchField: View {
    @EnvironmentObject var theme: ThemeManager
    @Binding var text: String
    var placeholder: String = "搜索"

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.palette.onSurfaceVariant)
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder).foregroundColor(theme.palette.onSurfaceVariant)
                }
                TextField("", text: $text)
                    .foregroundColor(theme.palette.onSurface)
            }
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(theme.palette.onSurfaceVariant)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(theme.palette.surfaceContainerHigh)
        .clipShape(Capsule())
    }
}
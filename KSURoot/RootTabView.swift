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
        ZStack(alignment: .bottom) {
            pages
            if theme.enableFloatingBar {
                GlassBottomBar(selection: $selection, floating: true)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 6)
            } else {
                GlassBottomBar(selection: $selection, floating: false)
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

// 悬浮胶囊 + 液态玻璃：Material 用 .background(_:in:) 正确采样（第一版写法）
struct GlassBottomBar: View {
    @EnvironmentObject var theme: ThemeManager
    @Binding var selection: Int
    var floating: Bool = false

    @State private var barWidth: CGFloat = 0
    @State private var dragProgress: CGFloat = 0
    @State private var dragging = false

    private let items: [(title: String, icon: String)] = [
        ("主页", "house.fill"),
        ("超级用户", "shield.fill"),
        ("模块", "puzzlepiece.fill"),
        ("设置", "gearshape.fill")
    ]

    private var progress: CGFloat { dragging ? dragProgress : CGFloat(selection) }
    private var tabWidth: CGFloat { barWidth > 1 ? barWidth / CGFloat(items.count) : 0 }
    private var activeIndex: Int { min(items.count - 1, max(0, Int(progress.rounded()))) }

    var body: some View {
        if floating { floatingBar } else { dockedBar }
    }

    private var core: some View {
        ZStack(alignment: .leading) {
            if tabWidth > 0 {
                indicator
                    .frame(width: tabWidth, height: 56)
                    .offset(x: progress * tabWidth)
                    .allowsHitTesting(false)
            }
            tabs
        }
        .frame(height: 56)
        .background(GeometryReader { geo in
            Color.clear
                .onAppear { barWidth = geo.size.width }
                .onChange(of: geo.size.width) { w in barWidth = w }
        })
        .contentShape(Rectangle())
        .gesture(dragGesture)
    }

    private var tabs: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { i in
                VStack(spacing: 3) {
                    Image(systemName: items[i].icon).font(.system(size: 20, weight: .medium))
                    Text(items[i].title).font(.system(size: 11, weight: .medium))
                }
                .foregroundColor(i == activeIndex ? theme.palette.primary : theme.palette.onSurfaceVariant)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .contentShape(Rectangle())
            }
        }
    }

    private var indicator: some View {
        Capsule()
            .fill(Color.white.opacity(0.08))
            .overlay(
                Capsule().fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.28), Color.clear],
                        startPoint: .top, endPoint: .center
                    )
                )
            )
            .overlay(
                Capsule().stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.7), Color.white.opacity(0.1)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 0.8
                )
            )
            .padding(.vertical, 3)
            .padding(.horizontal, 2)
    }

    private var floatingBar: some View {
        core
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(
                Capsule()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color.white.opacity(0.30), location: 0.0),
                                .init(color: Color.white.opacity(0.05), location: 0.42),
                                .init(color: Color.clear, location: 0.78)
                            ],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .allowsHitTesting(false)
            )
            .overlay(
                Capsule().stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.75), Color.white.opacity(0.08), Color.black.opacity(0.25)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 1
                )
            )
            .overlay(
                Capsule()
                    .stroke(Color.black.opacity(0.30), lineWidth: 8)
                    .blur(radius: 6)
                    .offset(y: 2)
                    .mask(Capsule())
                    .allowsHitTesting(false)
            )
            .shadow(color: .black.opacity(0.38), radius: 26, y: 10)
    }

    private var dockedBar: some View {
        core
            .background(.ultraThinMaterial)
            .overlay(alignment: .top) {
                Rectangle().fill(Color.white.opacity(0.28)).frame(height: 0.75)
            }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { v in
                guard tabWidth > 1 else { return }
                dragging = true
                let p = v.location.x / tabWidth - 0.5
                dragProgress = min(CGFloat(items.count - 1), max(0, p))
            }
            .onEnded { _ in
                guard tabWidth > 1 else { return }
                let idx = min(items.count - 1, max(0, Int(dragProgress.rounded())))
                dragging = false
                selection = idx
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
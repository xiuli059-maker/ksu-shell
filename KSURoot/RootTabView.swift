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

// FloatingBottomBar：玻璃胶囊指示器连续跟随手指拖动，松手吸附；点击/拖动同一手势
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

    private var useGlass: Bool { floating ? (theme.enableBlur && theme.enableFloatingBarBlur) : theme.enableBlur }
    private var progress: CGFloat { dragging ? dragProgress : CGFloat(selection) }
    private var tabWidth: CGFloat { barWidth > 1 ? barWidth / CGFloat(items.count) : 0 }
    private var activeIndex: Int { min(items.count - 1, max(0, Int(progress.rounded()))) }

    var body: some View {
        ZStack(alignment: .leading) {
            backgroundLayer
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
        .overlay(borderLayer)
        .shadow(color: .black.opacity(floating ? 0.32 : 0), radius: 20, y: 8)
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

    @ViewBuilder private var backgroundLayer: some View {
        if floating {
            if useGlass {
                ZStack {
                    Capsule().fill(.ultraThinMaterial)
                    Capsule().fill(Color.white.opacity(0.10))
                    Capsule().fill(theme.palette.surfaceContainer.opacity(0.18))
                }
            } else {
                Capsule().fill(theme.palette.surfaceContainer)
            }
        } else {
            if useGlass {
                ZStack {
                    Rectangle().fill(.ultraThinMaterial)
                    Rectangle().fill(Color.white.opacity(0.08))
                }
            } else {
                Rectangle().fill(theme.palette.surfaceContainer)
            }
        }
    }

    private var indicator: some View {
        Capsule()
            .fill(.ultraThinMaterial)
            .overlay(Capsule().fill(Color.white.opacity(0.12)))
            .overlay(
                Capsule().stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.60), Color.white.opacity(0.08)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 0.8
                )
            )
            .shadow(color: .black.opacity(0.15), radius: 4, y: 1)
            .padding(.vertical, 3)
            .padding(.horizontal, 2)
    }

    @ViewBuilder private var borderLayer: some View {
        if floating {
            Capsule().stroke(
                LinearGradient(
                    colors: [Color.white.opacity(0.55), Color.white.opacity(0.06)],
                    startPoint: .top, endPoint: .bottom
                ),
                lineWidth: 1
            )
        } else {
            VStack(spacing: 0) {
                Rectangle().fill(Color.white.opacity(useGlass ? 0.28 : 0)).frame(height: 0.75)
                Spacer()
            }
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
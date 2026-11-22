import SwiftUI

struct RootView: View {
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var appState: AppState
    @State private var selection = 0

    private var appBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x101A3A), Color(hex: 0x3A1050), Color(hex: 0x50102E), Color(hex: 0x6A2A10)],
                startPoint: .top, endPoint: .bottom
            )
            Circle().fill(Color(hex: 0x3B6FE0)).frame(width: 400, height: 400).blur(radius: 55).offset(x: -120, y: -200)
            Circle().fill(Color(hex: 0xB03B8C)).frame(width: 360, height: 360).blur(radius: 55).offset(x: 140, y: 100)
            Circle().fill(Color(hex: 0xE0A050)).frame(width: 320, height: 320).blur(radius: 45).offset(x: -60, y: 300)
        }
        .ignoresSafeArea()
    }

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
            appBackground
            pages
            if theme.enableFloatingBar {
                GlassBottomBar(selection: $selection, floating: true)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 6)
            } else {
                GlassBottomBar(selection: $selection, floating: false)
            }
        }
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

    @ViewBuilder private var indicator: some View {
        if #available(iOS 26.0, *) {
            Color.clear
                .glassEffect(.regular.interactive(), in: .capsule)
                .padding(.vertical, 3)
                .padding(.horizontal, 2)
        } else {
            Capsule()
                .fill(Color.white.opacity(0.08))
                .overlay(
                    Capsule().fill(
                        LinearGradient(colors: [Color.white.opacity(0.28), Color.clear], startPoint: .top, endPoint: .center)
                    )
                )
                .overlay(
                    Capsule().stroke(
                        LinearGradient(colors: [Color.white.opacity(0.7), Color.white.opacity(0.1)], startPoint: .top, endPoint: .bottom),
                        lineWidth: 0.8
                    )
                )
                .padding(.vertical, 3)
                .padding(.horizontal, 2)
        }
    }

    @ViewBuilder private var floatingBar: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                core.glassEffect(.regular, in: .capsule)
            }
        } else {
            core
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(
                    Capsule().stroke(
                        LinearGradient(colors: [Color.white.opacity(0.75), Color.white.opacity(0.08), Color.black.opacity(0.25)], startPoint: .top, endPoint: .bottom),
                        lineWidth: 1
                    )
                )
                .shadow(color: .black.opacity(0.38), radius: 26, y: 10)
        }
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
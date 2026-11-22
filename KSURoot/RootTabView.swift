import SwiftUI

struct RootView: View {
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var appState: AppState
    @State private var selection = 0

    var body: some View {
        ZStack {
            appBackground
            tabs
        }
        .fullScreenCover(item: Binding(get: { appState.route }, set: { appState.route = $0 })) { route in
            ScreenHost(route: route)
                .environmentObject(theme)
                .environmentObject(appState)
        }
    }

    @ViewBuilder private var tabs: some View {
        if #available(iOS 18.0, *) {
            TabView(selection: $selection) {
                Tab("主页", systemImage: "house.fill", value: 0) { HomeView() }
                Tab("超级用户", systemImage: "shield.fill", value: 1) { SuperUserView() }
                Tab("模块", systemImage: "puzzlepiece.fill", value: 2) { ModuleView() }
                Tab("设置", systemImage: "gearshape.fill", value: 3) { SettingsView() }
            }
        } else {
            TabView(selection: $selection) {
                HomeView().tabItem { Label("主页", systemImage: "house.fill") }.tag(0)
                SuperUserView().tabItem { Label("超级用户", systemImage: "shield.fill") }.tag(1)
                ModuleView().tabItem { Label("模块", systemImage: "puzzlepiece.fill") }.tag(2)
                SettingsView().tabItem { Label("设置", systemImage: "gearshape.fill") }.tag(3)
            }
        }
    }

    // 系统原生 Liquid Glass tab bar 需要有内容可折射，这里用清晰鲜艳的渐变 + 光斑
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
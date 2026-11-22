import SwiftUI

struct RootView: View {
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var appState: AppState
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem { Label("主页", systemImage: "house.fill") }
                .tag(0)
            SuperUserView()
                .tabItem { Label("超级用户", systemImage: "shield.fill") }
                .tag(1)
            ModuleView()
                .tabItem { Label("模块", systemImage: "puzzlepiece.fill") }
                .tag(2)
            SettingsView()
                .tabItem { Label("设置", systemImage: "gearshape.fill") }
                .tag(3)
        }
        .fullScreenCover(item: Binding(get: { appState.route }, set: { appState.route = $0 })) { route in
            ScreenHost(route: route)
                .environmentObject(theme)
                .environmentObject(appState)
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
import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("主页", systemImage: "house.fill") }
            SuperUserView()
                .tabItem { Label("超级用户", systemImage: "shield.fill") }
            ModulesView()
                .tabItem { Label("模块", systemImage: "puzzlepiece.fill") }
            SettingsView()
                .tabItem { Label("设置", systemImage: "gearshape.fill") }
        }
        .accentColor(.white)
    }
}
import SwiftUI

@main
struct KSURootApp: App {
    @StateObject private var theme = ThemeManager()
    @StateObject private var appState = AppState()
    @StateObject private var mg = MobileGestaltManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(theme)
                .environmentObject(appState)
                .environmentObject(mg)
                .preferredColorScheme(theme.isDark ? .dark : .light)
        }
    }
}
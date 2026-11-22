import SwiftUI

@main
struct KSURootApp: App {
    @StateObject private var theme = ThemeManager()
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(theme)
                .environmentObject(appState)
                .preferredColorScheme(theme.isDark ? .dark : .light)
        }
    }
}
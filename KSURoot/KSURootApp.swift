import SwiftUI

@main
struct KSURootApp: App {
    @StateObject private var theme = ThemeManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(theme)
                .preferredColorScheme(theme.isDark ? .dark : .light)
        }
    }
}
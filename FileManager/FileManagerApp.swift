import SwiftUI

@main
struct FileManagerApp: App {
    var body: some Scene {
        WindowGroup {
            FileBrowserView()
                .preferredColorScheme(.dark)
        }
    }
}
import SwiftUI

struct RootView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            HomeView().tag(0)
            SuperUserView().tag(1)
            ModuleView().tag(2)
            SettingsView().tag(3)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomBar(selection: $selection)
        }
        .background(theme.palette.surface.ignoresSafeArea())
    }
}

struct BottomBar: View {
    @EnvironmentObject var theme: ThemeManager
    @Binding var selection: Int

    private let items: [(title: String, icon: String)] = [
        ("主页", "house.fill"),
        ("超级用户", "shield.fill"),
        ("模块", "puzzlepiece.fill"),
        ("设置", "gearshape.fill")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { i in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selection = i }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: items[i].icon)
                            .font(.system(size: 22))
                        Text(items[i].title)
                            .font(.system(size: 11))
                    }
                    .foregroundColor(selection == i ? theme.palette.onSurface : theme.palette.onSurfaceVariant)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 2)
        .background(theme.palette.surfaceContainer)
        .overlay(alignment: .top) {
            Rectangle().fill(theme.palette.outline.opacity(0.1)).frame(height: 0.5)
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
        .background(theme.palette.surfaceBright)
        .clipShape(Capsule())
    }
}
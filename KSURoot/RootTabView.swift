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
            GlassBottomBar(selection: $selection)
                .padding(.horizontal, 28)
                .padding(.bottom, 4)
                .padding(.top, 2)
        }
        .background(theme.palette.surface.ignoresSafeArea())
    }
}

// 对应 Miuix FloatingBottomBar：悬浮胶囊 + 液态玻璃（毛玻璃 + 白高光描边 + 投影）+ 滑动高光指示器
struct GlassBottomBar: View {
    @EnvironmentObject var theme: ThemeManager
    @Binding var selection: Int
    @Namespace private var ns

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
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                        selection = i
                    }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: items[i].icon)
                            .font(.system(size: 20, weight: .medium))
                        Text(items[i].title)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(selection == i ? theme.palette.primary : theme.palette.onSurfaceVariant)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background {
                        if selection == i {
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule().stroke(Color.white.opacity(0.18), lineWidth: 0.5)
                                )
                                .shadow(color: .black.opacity(0.15), radius: 4, y: 1)
                                .matchedGeometryEffect(id: "indicator", in: ns)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 0.5))
        .shadow(color: .black.opacity(0.28), radius: 14, y: 6)
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
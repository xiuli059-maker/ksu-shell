import SwiftUI

struct SuperUserView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var search = ""

    private var filtered: [AppEntry] {
        if search.isEmpty { return MockData.apps }
        return MockData.apps.filter {
            $0.name.localizedCaseInsensitiveContains(search) ||
            $0.packageName.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LargeTitle(text: "超级用户")

            SearchField(text: $search, placeholder: "搜索应用或包名")
                .padding(.horizontal, 16)
                .padding(.bottom, 10)

            ScrollView {
                if filtered.isEmpty {
                    EmptyPlaceholder(icon: "shield.slash", text: "暂无超级用户授权")
                } else {
                    SegmentedColumn {
                        ForEach(filtered) { app in
                            AppRow(app: app)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 110)
                }
            }
        }
        .background(Color.clear)
    }
}

struct AppRow: View {
    @EnvironmentObject var theme: ThemeManager
    let app: AppEntry

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(theme.palette.surfaceContainerHigh)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(app.name.prefix(1)))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(theme.palette.onSurfaceVariant)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.system(size: 16))
                    .foregroundColor(theme.palette.onSurface)
                Text(app.packageName)
                    .font(.system(size: 12))
                    .foregroundColor(theme.palette.onSurfaceVariant)
            }
            Spacer(minLength: 8)
            Image(systemName: app.allowSu ? "checkmark.shield.fill" : "shield.slash")
                .foregroundColor(app.allowSu ? theme.palette.primary : theme.palette.onSurfaceVariant)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(theme.palette.outline.opacity(0.12))
                .frame(height: 0.5)
                .padding(.leading, 72)
        }
    }
}
import SwiftUI

struct SuperUserView: View {
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
                SegmentedColumn {
                    ForEach(filtered) { app in
                        AppRow(app: app)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Theme.surface.ignoresSafeArea())
    }
}

struct AppRow: View {
    let app: AppEntry

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.surfaceContainerHigh)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(app.name.prefix(1)))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Theme.onSurfaceVariant)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.onSurface)
                Text(app.packageName)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.onSurfaceVariant)
            }
            Spacer(minLength: 8)
            Image(systemName: app.allowSu ? "checkmark.shield.fill" : "shield.slash")
                .foregroundColor(app.allowSu ? Theme.primary : Theme.onSurfaceVariant)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Theme.outline.opacity(0.12))
                .frame(height: 0.5)
                .padding(.leading, 72)
        }
    }
}
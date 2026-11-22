import SwiftUI

// 超级用户页 = 所有可改的 MobileGestalt（CacheExtra）功能项
struct SuperUserView: View {
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var mg: MobileGestaltManager
    @State private var q = ""

    private var filtered: [(key: String, value: String)] {
        if q.isEmpty { return mg.entries }
        return mg.entries.filter { $0.key.localizedCaseInsensitiveContains(q) || $0.value.localizedCaseInsensitiveContains(q) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LargeTitle(text: "超级用户")

            SearchField(text: $q, placeholder: "搜索 MobileGestalt 字段（如 DeviceSupports / Region）")
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

            Text(mg.status)
                .font(.system(size: 12))
                .foregroundColor(theme.palette.onSurfaceVariant)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

            ScrollView {
                if filtered.isEmpty {
                    EmptyPlaceholder(icon: "shield.slash", text: mg.status)
                } else {
                    SegmentedColumn {
                        ForEach(Array(filtered.enumerated()), id: \.offset) { _, e in
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundColor(theme.palette.primary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(e.key)
                                        .font(.system(size: 14))
                                        .foregroundColor(theme.palette.onSurface)
                                    Text(e.value)
                                        .font(.system(size: 12))
                                        .foregroundColor(theme.palette.onSurfaceVariant)
                                        .lineLimit(1)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(16)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 110)
                }
            }
        }
        .background(theme.palette.surface.ignoresSafeArea())
        .onAppear { mg.load() }
    }
}
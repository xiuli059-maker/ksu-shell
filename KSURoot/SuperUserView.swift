import SwiftUI

// 超级用户页 = 所有可改的 MobileGestalt 功能项（按分类），写入前自动备份
struct SuperUserView: View {
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var mg: MobileGestaltManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                LargeTitle(text: "超级用户")

                Text(mg.status)
                    .font(.system(size: 12))
                    .foregroundColor(theme.palette.onSurfaceVariant)
                    .padding(.horizontal, 4)

                ForEach(CapabilityCategory.allCases) { cat in
                    let caps = Capability.all.filter { $0.category == cat }
                    if !caps.isEmpty {
                        SegmentedColumn(title: cat.rawValue) {
                            ForEach(caps) { cap in
                                HStack(spacing: 12) {
                                    Image(systemName: cat.symbol)
                                        .font(.system(size: 18))
                                        .foregroundColor(theme.palette.onSurfaceVariant)
                                        .frame(width: 24)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(cap.title)
                                            .font(.system(size: 16))
                                            .foregroundColor(theme.palette.onSurface)
                                        Text(cap.detail)
                                            .font(.system(size: 12))
                                            .foregroundColor(theme.palette.onSurfaceVariant)
                                            .lineLimit(2)
                                    }
                                    Spacer(minLength: 8)
                                    Toggle("", isOn: Binding(
                                        get: { mg.enabledStates[cap.id] ?? false },
                                        set: { mg.apply(cap, enable: $0) }
                                    ))
                                    .labelsHidden()
                                    .tint(theme.palette.primary)
                                }
                                .padding(16)
                            }
                        }
                    }
                }

                Spacer(minLength: 110)
            }
            .padding(.horizontal, 12)
        }
        .background(theme.palette.surface.ignoresSafeArea())
        .onAppear { mg.load() }
    }
}
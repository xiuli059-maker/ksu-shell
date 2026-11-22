import SwiftUI

// 模块页 = 修改前的 MobileGestalt 备份，可随时还原
struct ModuleView: View {
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var mg: MobileGestaltManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                LargeTitle(text: "模块")

                VStack(spacing: 13) {
                    HStack {
                        Text(mg.status)
                            .font(.system(size: 12))
                            .foregroundColor(theme.palette.onSurfaceVariant)
                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    Button { mg.backUp() } label: {
                        Label("新建备份", systemImage: "square.and.arrow.down")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(theme.palette.primary)
                            .foregroundColor(theme.palette.onPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .padding(.horizontal, 16)

                    if mg.backups.isEmpty {
                        EmptyPlaceholder(icon: "shippingbox", text: "暂无备份")
                    } else {
                        SegmentedColumn {
                            ForEach(mg.backups) { b in
                                HStack(spacing: 12) {
                                    Image(systemName: "shippingbox")
                                        .foregroundColor(theme.palette.onSurfaceVariant)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(b.name)
                                            .font(.system(size: 14))
                                            .foregroundColor(theme.palette.onSurface)
                                        Text(b.date.formatted(date: .abbreviated, time: .standard))
                                            .font(.system(size: 12))
                                            .foregroundColor(theme.palette.onSurfaceVariant)
                                    }
                                    Spacer(minLength: 8)
                                    Button("还原") { mg.restore(b) }
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(theme.palette.primary)
                                }
                                .padding(16)
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.bottom, 110)
            }
        }
        .background(theme.palette.surface.ignoresSafeArea())
        .onAppear { mg.reloadBackups() }
    }
}
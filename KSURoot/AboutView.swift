import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 56))
                    .foregroundColor(Theme.primary)
                    .padding(.top, 40)

                Text("KernelSU")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Theme.onSurface)

                Text("内核级 Root 解决方案 · 娱乐展示版")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.onSurfaceVariant)

                SegmentedColumn {
                    SegmentedRow(icon: "tag", title: "版本", subtitle: "v3.2.5 (32525-2)")
                    SegmentedRow(icon: "person", title: "作者", subtitle: "weishu")
                    SegmentedRow(icon: "chevron.left.forwardslash.chevron.right", title: "GitHub",
                                 subtitle: "github.com/tiann/KernelSU")
                }
                .padding(.horizontal, 16)

                Text("仅作 UI 移植展示，不含任何实际 root / 越狱功能。")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.onSurfaceVariant)
                    .padding(.horizontal, 16)

                Button {
                    dismiss()
                } label: {
                    Text("关闭")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.primary)
                        .foregroundColor(Theme.onPrimary)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 30)
        }
        .background(Theme.surface.ignoresSafeArea())
    }
}
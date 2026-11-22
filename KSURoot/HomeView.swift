import SwiftUI

struct HomeView: View {
    @EnvironmentObject var theme: ThemeManager
    private let info = MockData.systemInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 13) {
                LargeTitle(text: "KernelSU")

                StatusCard()

                SegmentedColumn {
                    SegmentedRow(icon: "tag", title: "管理器版本", subtitle: info.managerVersion)
                    SegmentedRow(icon: "cpu", title: "内核版本", subtitle: info.kernelVersion)
                    SegmentedRow(icon: "iphone", title: "设备型号", subtitle: info.deviceModel)
                    SegmentedRow(icon: "touchid", title: "系统指纹", subtitle: info.fingerprint)
                }

                SegmentedColumn {
                    SegmentedRow(icon: "lock.shield", title: "SELinux 状态", subtitle: info.selinux)
                    SegmentedRow(icon: "line.3.horizontal.decrease", title: "Seccomp 状态", subtitle: info.seccomp)
                }

                SegmentedColumn {
                    SegmentedLinkRow(icon: "heart", title: "支持开发", subtitle: "赞助 KernelSU 的持续开发")
                    SegmentedLinkRow(icon: "book", title: "了解 KernelSU", subtitle: "查看官方文档与说明")
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
        }
        .background(theme.palette.surface.ignoresSafeArea())
    }
}

// 对应 HomeMaterial.kt 的 StatusCard：横向 ListItem（对勾图标 + 工作中 + 版本副文字 + 工作模式标签）
struct StatusCard: View {
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(theme.palette.onSecondaryContainer)

            VStack(alignment: .leading, spacing: 3) {
                Text("工作中")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(theme.palette.onSecondaryContainer)
                Text("版本 32525-2")
                    .font(.system(size: 14))
                    .foregroundColor(theme.palette.onSecondaryContainer.opacity(0.75))
            }

            Spacer(minLength: 8)

            StatusTag(text: "LKM", background: theme.palette.primary, foreground: theme.palette.onPrimary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(theme.palette.secondaryContainer)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
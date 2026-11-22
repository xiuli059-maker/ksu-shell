import SwiftUI

struct HomeView: View {
    @EnvironmentObject var theme: ThemeManager
    private let info = MockData.systemInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
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
            .padding(.horizontal, 12)
        }
        .background(theme.palette.surface.ignoresSafeArea())
    }
}

// 对应 HomeMiuix.kt 的 StatusCard：Card 深墨绿(0xFF1A3825) / 浅绿(0xFFDFFAE4)，对勾 + 工作中 + 版本 + 工作模式标签
struct StatusCard: View {
    @EnvironmentObject var theme: ThemeManager

    private var cardBackground: Color {
        theme.isDark ? Color(hex: 0x1A3825) : Color(hex: 0xDFFAE4)
    }
    private var onCard: Color {
        theme.isDark ? Color(hex: 0xDFFAE4) : Color(hex: 0x0B3A16)
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 26))
                .foregroundColor(theme.isDark ? Color(hex: 0x7EE08A) : Color(hex: 0x1E7B3C))

            VStack(alignment: .leading, spacing: 3) {
                Text("工作中")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(onCard)
                Text("版本 32525-2")
                    .font(.system(size: 13))
                    .foregroundColor(onCard.opacity(0.7))
            }

            Spacer(minLength: 8)

            StatusTag(
                text: "LKM",
                background: theme.isDark ? Color(hex: 0x2C5A30) : Color(hex: 0xBCF0B4),
                foreground: onCard
            )
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var theme: ThemeManager
    private let info = MockData.systemInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("KernelSU")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(theme.palette.onSurface)
                    .padding(.top, 8)

                StatusCard()

                InfoCard(info: info)

                SupportLinks()

                Spacer(minLength: 110)
            }
            .padding(.horizontal, 12)
        }
        .background(theme.palette.surface.ignoresSafeArea())
    }
}

// HomeMiuix.kt StatusCard：深墨绿卡片(0xFF1A3825)，右下 110dp 大对勾(0xFF36D167) offset(27,31)，
// 左上「工作中」22sp SemiBold +「版本 xxx-uapi」15sp，左下工作模式「LKM」16sp Medium
struct StatusCard: View {
    @EnvironmentObject var theme: ThemeManager

    private var cardBg: Color { theme.isDark ? Color(hex: 0x1A3825) : Color(hex: 0xDFFAE4) }
    private var onCard: Color { theme.isDark ? Color(hex: 0xDFFAE4) : Color(hex: 0x0B3A16) }
    private var checkColor: Color { theme.isDark ? Color(hex: 0x36D167) : Color(hex: 0x1E7B3C) }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 110, weight: .bold))
                .foregroundColor(checkColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: 27, y: 31)

            Text("LKM")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(onCard)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.leading, 16)
                .padding(.bottom, 10)

            VStack(alignment: .leading, spacing: 1) {
                Text("工作中")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(onCard)
                Text("版本 32525-2")
                    .font(.system(size: 15))
                    .foregroundColor(onCard)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.leading, 16)
            .padding(.top, 14)
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

// HomeMiuix.kt InfoCard：Card + padding16，每行 icon 24 + 标题 headline1(20sp)Medium + 值 body2(14sp)，行底距 24
struct InfoCard: View {
    @EnvironmentObject var theme: ThemeManager
    let info: SystemInfo

    var body: some View {
        VStack(spacing: 12) {
            card {
                infoRow(icon: "tag", title: "管理器版本", value: info.managerVersion)
                infoRow(icon: "cpu", title: "内核版本", value: info.kernelVersion)
                infoRow(icon: "iphone", title: "设备型号", value: info.deviceModel)
                infoRow(icon: "touchid", title: "系统指纹", value: info.fingerprint, last: true)
            }
            card {
                infoRow(icon: "lock.shield", title: "SELinux 状态", value: info.selinux)
                infoRow(icon: "line.3.horizontal.decrease", title: "Seccomp 状态", value: info.seccomp, last: true)
            }
        }
    }

    private func card<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) { content() }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.palette.surfaceBright)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func infoRow(icon: String, title: String, value: String, last: Bool = false) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(theme.palette.onSurface)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(theme.palette.onSurface)
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(theme.palette.onSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(.bottom, last ? 0 : 24)
    }
}

// HomeMiuix.kt SupportLinks：Card 内两个 ArrowPreference
struct SupportLinks: View {
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        VStack(spacing: 0) {
            supportRow(icon: "heart", title: "支持开发", summary: "赞助 KernelSU 的持续开发")
            Divider().overlay(theme.palette.outline.opacity(0.15)).padding(.leading, 46)
            supportRow(icon: "book", title: "了解 KernelSU", summary: "查看官方文档与说明")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.palette.surfaceBright)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func supportRow(icon: String, title: String, summary: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(theme.palette.onSurface)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(theme.palette.onSurface)
                Text(summary)
                    .font(.system(size: 13))
                    .foregroundColor(theme.palette.onSurfaceVariant)
            }
            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(theme.palette.onSurfaceVariant)
        }
        .padding(.vertical, 12)
    }
}
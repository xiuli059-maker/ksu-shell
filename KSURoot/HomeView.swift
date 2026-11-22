import SwiftUI

struct HomeView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var showLogout = false
    private let info = MockData.systemInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    Text("KernelSU")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(theme.palette.onSurface)
                    Spacer()
                    Button {
                        showLogout = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "person.crop.circle.badge.xmark")
                                .font(.system(size: 20, weight: .medium))
                            Text("注销").font(.system(size: 14))
                        }
                        .foregroundColor(theme.palette.onSurface)
                    }
                }
                .padding(.top, 8)

                StatusCard()

                InfoCard(info: info)

                SupportLinks()

                Spacer(minLength: 60)
            }
            .padding(.horizontal, 12)
        }
        .background(theme.palette.surface.ignoresSafeArea())
        .fullScreenCover(isPresented: $showLogout) { NeoSpringView() }
    }
}

// HomeMiuix.kt StatusCard：深墨绿卡片，右下 110dp 大对勾，工作中 22sp + 版本 15sp + 自定义标签 + LKM 16sp
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
                HStack(spacing: 8) {
                    Text("版本 35833-6")
                        .font(.system(size: 15))
                        .foregroundColor(onCard)
                    StatusTag(
                        text: "自定义",
                        background: theme.isDark ? Color(hex: 0x315D3E) : Color(hex: 0xB8E8C5),
                        foreground: theme.isDark ? Color(hex: 0xB8E8C5) : Color(hex: 0x164A29)
                    )
                }
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

struct InfoCard: View {
    @EnvironmentObject var theme: ThemeManager
    let info: SystemInfo

    var body: some View {
        VStack(spacing: 12) {
            card {
                infoRow(icon: "tag.fill", title: "管理器版本", value: info.managerVersion)
                infoRow(icon: "cpu.fill", title: "内核版本", value: info.kernelVersion)
                infoRow(icon: "iphone", title: "设备型号", value: info.deviceModel)
                infoRow(icon: "touchid", title: "系统指纹", value: info.fingerprint, last: true)
            }
            card {
                infoRow(icon: "checkmark.shield", title: "SELinux 状态", value: info.selinux)
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

struct SupportLinks: View {
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        VStack(spacing: 0) {
            supportRow(icon: "hands.and.sparkles.fill", title: "支持开发", summary: "KernelSU 将保持免费开源，向开发者捐赠以表示支持")
            Divider().overlay(theme.palette.outline.opacity(0.15)).padding(.leading, 46)
            supportRow(icon: "book.fill", title: "了解 KernelSU", summary: "了解如何安装 KernelSU 以及如何开发模块")
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
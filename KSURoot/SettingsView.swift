import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var showAbout = false

    @State private var checkUpdate = true
    @State private var checkModuleUpdate = true
    @State private var kernelUmount = true
    @State private var selinuxHide = false
    @State private var sulog = false
    @State private var adbRoot = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                LargeTitle(text: "设置")

                VStack(spacing: 13) {
                    // 界面与主题（真正可调，对应安卓 KSU 的界面模式 / 主题）
                    SegmentedColumn {
                        SegmentedRow(
                            icon: "display",
                            title: "界面模式",
                            subtitle: theme.uiMode == 0 ? "Material 3" : "Miuix",
                            trailing: AnyView(modeMenu)
                        )
                        SegmentedRow(
                            icon: theme.isDark ? "moon.fill" : "sun.max.fill",
                            title: "深色模式",
                            subtitle: theme.modeName,
                            trailing: AnyView(darkMenu)
                        )
                        SegmentedRow(
                            icon: "paintpalette",
                            title: "主题色",
                            subtitle: (Seed(rawValue: theme.seed) ?? .green).name,
                            trailing: AnyView(seedPicker)
                        )
                    }

                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "arrow.triangle.2.circlepath", title: "检查更新",
                                           subtitle: "启动时检查 KernelSU 管理器更新", isOn: $checkUpdate)
                        SegmentedSwitchRow(icon: "square.and.arrow.down", title: "模块更新检查",
                                           subtitle: "定期检查已安装模块的更新", isOn: $checkModuleUpdate)
                    }

                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "shield.lefthalf.filled", title: "SELinux 隐藏",
                                           subtitle: "对普通应用隐藏 SELinux 状态", isOn: $selinuxHide)
                        SegmentedSwitchRow(icon: "doc.text", title: "su 日志", subtitle: "记录 su 授权日志", isOn: $sulog)
                        SegmentedSwitchRow(icon: "terminal", title: "ADB root", subtitle: "允许 adb 获取 root 权限", isOn: $adbRoot)
                        SegmentedSwitchRow(icon: "externaldrive.badge.xmark", title: "内核级卸载",
                                           subtitle: "内核级模块卸载（umount）", isOn: $kernelUmount)
                    }

                    SegmentedColumn {
                        SegmentedLinkRow(icon: "info.circle", title: "关于", subtitle: "版本、作者与开源地址") {
                            showAbout = true
                        }
                    }

                    Text("本应用仅作 UI 移植展示，不含任何 Root / 越狱 / 系统修改功能。")
                        .font(.system(size: 12))
                        .foregroundColor(theme.palette.onSurfaceVariant)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(theme.palette.surface.ignoresSafeArea())
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }

    private var modeMenu: some View {
        Menu {
            Button("Material 3") { theme.setUiMode(0) }
            Button("Miuix") { theme.setUiMode(1) }
        } label: {
            HStack(spacing: 4) {
                Text(theme.uiMode == 0 ? "Material 3" : "Miuix")
                Image(systemName: "chevron.up.chevron.down").font(.system(size: 11))
            }
            .font(.system(size: 14))
            .foregroundColor(theme.palette.primary)
        }
    }

    private var darkMenu: some View {
        Menu {
            Button("深色") { theme.isDark = true; theme.amoled = false }
            Button("浅色") { theme.isDark = false; theme.amoled = false }
            Button("AMOLED 黑") { theme.isDark = true; theme.amoled = true }
        } label: {
            HStack(spacing: 4) {
                Text(theme.modeName)
                Image(systemName: "chevron.up.chevron.down").font(.system(size: 11))
            }
            .font(.system(size: 14))
            .foregroundColor(theme.palette.primary)
        }
    }

    private var seedPicker: some View {
        HStack(spacing: 8) {
            ForEach(0..<Seed.allCases.count, id: \.self) { i in
                Circle()
                    .fill(Seed(rawValue: i)!.swatch)
                    .frame(width: 22, height: 22)
                    .overlay(
                        Circle()
                            .stroke(theme.palette.onSurface, lineWidth: theme.seed == i ? 2 : 0)
                    )
                    .onTapGesture { theme.seed = i }
            }
        }
    }
}
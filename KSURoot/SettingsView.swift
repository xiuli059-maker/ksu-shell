import SwiftUI

// 对照 SettingsMaterial.kt：完整设置项，每项对应源码 Icons.Filled.*
struct SettingsView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var showAbout = false

    @State private var checkUpdate = true
    @State private var checkModuleUpdate = true
    @State private var profileTemplate = true
    @State private var kernelUmount = true
    @State private var selinuxHide = false
    @State private var sulog = false
    @State private var adbRoot = false
    @State private var shellSuAdbOnly = false
    @State private var softReboot = false
    @State private var defaultUmount = false
    @State private var webDebug = false
    @State private var autoJailbreak = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("设置")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(theme.palette.onSurface)
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    .padding(.bottom, 6)

                VStack(spacing: 13) {
                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "arrow.triangle.2.circlepath", title: "检查更新",
                                           subtitle: "启动时检查 KernelSU 管理器更新", isOn: $checkUpdate)
                        SegmentedSwitchRow(icon: "square.and.arrow.down", title: "模块更新检查",
                                           subtitle: "定期检查已安装模块的更新", isOn: $checkModuleUpdate)
                    }

                    SegmentedColumn {
                        SegmentedRow(icon: "display", title: "界面模式",
                                     subtitle: theme.uiMode == 0 ? "Material 3" : "Miuix",
                                     trailing: AnyView(modeMenu))
                        SegmentedRow(icon: theme.isDark ? "moon.fill" : "sun.max.fill", title: "主题",
                                     subtitle: theme.modeName,
                                     trailing: AnyView(darkMenu))
                        SegmentedRow(icon: "paintpalette", title: "主题色",
                                     subtitle: (Seed(rawValue: theme.seed) ?? .green).name,
                                     trailing: AnyView(seedPicker))
                    }

                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "doc.text", title: "配置模板",
                                           subtitle: "为应用配置 UID / 挂载模板", isOn: $profileTemplate)
                    }

                    SegmentedColumn {
                        SegmentedRow(icon: "shield.lefthalf.filled", title: "su 兼容模式",
                                     subtitle: "默认启用", trailing: AnyView(sucompatMenu))
                        SegmentedSwitchRow(icon: "square.stack.3d.up.slash", title: "内核级卸载",
                                           subtitle: "内核级模块卸载（umount）", isOn: $kernelUmount)
                        SegmentedSwitchRow(icon: "lock.shield", title: "SELinux 隐藏",
                                           subtitle: "对普通应用隐藏 SELinux 状态", isOn: $selinuxHide)
                        SegmentedSwitchRow(icon: "doc.text.magnifyingglass", title: "su 日志",
                                           subtitle: "记录 su 授权日志", isOn: $sulog)
                        SegmentedSwitchRow(icon: "terminal", title: "ADB root",
                                           subtitle: "允许 adb 获取 root 权限", isOn: $adbRoot)
                        SegmentedSwitchRow(icon: "checkmark.shield", title: "shell su 仅限 ADB",
                                           subtitle: "shell 中 su 仅允许来自 adb", isOn: $shellSuAdbOnly)
                        SegmentedSwitchRow(icon: "arrow.clockwise", title: "软重启",
                                           subtitle: "使用软重启替代完整重启", isOn: $softReboot)
                    }

                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "list.bullet", title: "默认卸载模块",
                                           subtitle: "对应用默认卸载 KernelSU 模块", isOn: $defaultUmount)
                        SegmentedSwitchRow(icon: "hammer", title: "启用 web 调试",
                                           subtitle: "允许 Web UI 调试（Chrome inspect）", isOn: $webDebug)
                        SegmentedSwitchRow(icon: "bolt.fill", title: "自动越狱",
                                           subtitle: "在越狱模式下自动进入（需晚加载模式）", isOn: $autoJailbreak)
                    }

                    SegmentedColumn {
                        SegmentedRow(icon: "trash", title: "卸载 KernelSU", action: { })
                    }

                    SegmentedColumn {
                        SegmentedRow(icon: "info.circle", title: "发送日志", action: { })
                        SegmentedRow(icon: "info.circle", title: "关于", action: { showAbout = true })
                    }

                    Text("本应用仅作 UI 移植展示，不含任何 Root / 越狱 / 系统修改功能。")
                        .font(.system(size: 12))
                        .foregroundColor(theme.palette.onSurfaceVariant)
                        .padding(.horizontal, 12)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 110)
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
            menuLabel(theme.uiMode == 0 ? "Material 3" : "Miuix")
        }
    }

    private var darkMenu: some View {
        Menu {
            Button("深色") { theme.isDark = true; theme.amoled = false }
            Button("浅色") { theme.isDark = false; theme.amoled = false }
            Button("AMOLED 黑") { theme.isDark = true; theme.amoled = true }
        } label: {
            menuLabel(theme.modeName)
        }
    }

    private var sucompatMenu: some View {
        Menu {
            Button("默认启用") { }
            Button("重启前禁用") { }
            Button("始终禁用") { }
        } label: {
            menuLabel("默认启用")
        }
    }

    private func menuLabel(_ text: String) -> some View {
        HStack(spacing: 4) {
            Text(text)
            Image(systemName: "chevron.up.chevron.down").font(.system(size: 11))
        }
        .font(.system(size: 14))
        .foregroundColor(theme.palette.primary)
    }

    private var seedPicker: some View {
        HStack(spacing: 8) {
            ForEach(0..<Seed.allCases.count, id: \.self) { i in
                Circle()
                    .fill(Seed(rawValue: i)!.swatch)
                    .frame(width: 22, height: 22)
                    .overlay(Circle().stroke(theme.palette.onSurface, lineWidth: theme.seed == i ? 2 : 0))
                    .onTapGesture { theme.seed = i }
            }
        }
    }
}
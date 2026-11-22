import SwiftUI

// 对照 SettingsMiuix / SettingsUiState + values-zh-rCN 的准确中文文案
struct SettingsView: View {
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var appState: AppState
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
    @State private var sucompat = 0

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
                    // 外观
                    SegmentedColumn {
                        SegmentedRow(icon: "display", title: "界面风格", subtitle: "选择应用的界面风格",
                                     trailing: AnyView(modeMenu))
                        SegmentedLinkRow(icon: "paintpalette", title: "主题设置", subtitle: "自定义更多主题选项") {
                            appState.route = .colorPalette
                        }
                        SegmentedSwitchRow(icon: "circle.lefthalf.filled", title: "模糊",
                                           subtitle: "启用顶栏和底栏的模糊效果", isOn: bind(\.enableBlur))
                        SegmentedSwitchRow(icon: "sparkles", title: "液态玻璃",
                                           subtitle: "启用悬浮底栏的液态玻璃效果", isOn: bind(\.enableFloatingBarBlur))
                        SegmentedSwitchRow(icon: "rectangle.bottomthird.inset.filled", title: "悬浮底栏",
                                           subtitle: "使用 Apple 风格的悬浮底栏", isOn: bind(\.enableFloatingBar))
                        SegmentedSwitchRow(icon: "circle.grid.2x1", title: "导航栏角标",
                                           subtitle: "在导航栏显示已授权应用和已启用模块数量", isOn: bind(\.enableNavBadge))
                        SegmentedRow(icon: "textformat.size", title: "界面缩放", subtitle: "调整全局显示比例 · \(Int(theme.pageScale * 100))%",
                                     trailing: AnyView(Stepper("", value: Binding(
                                        get: { theme.pageScale }, set: { theme.pageScale = min(1.5, max(0.7, $0)) }
                                     ), in: 0.7...1.5, step: 0.05).labelsHidden()))
                        SegmentedRow(icon: "text.alignleft", title: "模块描述最大行数",
                                     subtitle: "超过此行数的模块介绍将自动折叠，点击卡片可展开全文 · \(theme.moduleDescMaxLines)",
                                     trailing: AnyView(Stepper("", value: Binding(
                                        get: { theme.moduleDescMaxLines }, set: { theme.moduleDescMaxLines = min(20, max(1, $0)) }
                                     ), in: 1...20).labelsHidden()))
                    }

                    // 手势
                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "arrow.uturn.backward", title: "预测性返回手势",
                                           subtitle: "启用对预测性返回手势的支持", isOn: bind(\.enablePredictiveBack))
                        SegmentedSwitchRow(icon: "hand.draw", title: "横移返回手势",
                                           subtitle: "从屏幕边缘横移返回上一页", isOn: bind(\.enableSwipeDismiss))
                    }

                    // 更新
                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "arrow.triangle.2.circlepath", title: "检查更新",
                                           subtitle: "在应用启动后自动检查是否有最新版", isOn: $checkUpdate)
                        SegmentedSwitchRow(icon: "square.and.arrow.down", title: "检查模块更新",
                                           subtitle: "在应用启动后自动检查已安装模块是否有最新版", isOn: $checkModuleUpdate)
                    }

                    // 功能
                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "doc.on.doc", title: "App Profile 模板",
                                           subtitle: "管理本地和在线的 App Profile 模板", isOn: $profileTemplate)
                        SegmentedRow(icon: "terminal", title: "传统 SU 命令支持",
                                     subtitle: "允许通过 /system/bin/su 获取 Root 权限",
                                     trailing: AnyView(sucompatMenu))
                        SegmentedSwitchRow(icon: "square.stack.3d.up.slash", title: "卸载模块（内核级）",
                                           subtitle: "在内核给需要的应用卸载模块", isOn: $kernelUmount)
                        SegmentedSwitchRow(icon: "lock.shield", title: "隐藏 SELinux 修改",
                                           subtitle: "阻止应用检测 SELinux 修改", isOn: $selinuxHide)
                        SegmentedSwitchRow(icon: "doc.text.magnifyingglass", title: "SU 日志",
                                           subtitle: "将 Root 相关事件记录到 KernelSU 的 SU 日志文件中", isOn: $sulog)
                        SegmentedSwitchRow(icon: "terminal", title: "ADB root",
                                           subtitle: "以 Root 权限运行 adbd 守护进程", isOn: $adbRoot)
                        SegmentedSwitchRow(icon: "checkmark.shield", title: "限制 Shell 仅可通过 ADB 获取 Root",
                                           subtitle: "仅由 adbd 或 KernelSU Root 进程启动的 shell 可获取 Root", isOn: $shellSuAdbOnly)
                        SegmentedSwitchRow(icon: "arrow.clockwise", title: "使用软重启代替重启",
                                           subtitle: "安装、更新或开关模块时使用软重启代替完整重启", isOn: $softReboot)
                    }

                    // 其他
                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "list.bullet", title: "默认卸载模块",
                                           subtitle: "App Profile 中「卸载模块」的全局默认值", isOn: $defaultUmount)
                        SegmentedSwitchRow(icon: "hammer", title: "启用 web 调试",
                                           subtitle: "允许调试模块的 Web UI（Chrome inspect）", isOn: $webDebug)
                        SegmentedSwitchRow(icon: "bolt.fill", title: "自动越狱",
                                           subtitle: "开机检测到 Permissive SELinux 时自动使用 Magica 提权", isOn: $autoJailbreak)
                    }

                    SegmentedColumn {
                        SegmentedRow(icon: "trash", title: "卸载", subtitle: "永久卸载 / 临时卸载", action: { })
                    }

                    SegmentedColumn {
                        SegmentedRow(icon: "ladybug", title: "发送日志", action: { })
                        SegmentedRow(icon: "info.circle", title: "关于", action: { showAbout = true })
                    }

                    SegmentedColumn(title: "所有页面") {
                        ForEach([AppRoute.install, .flash, .moduleRepo, .scriptRun, .executeModuleAction,
                                 .appProfile, .template, .templateEditor, .sulog, .colorPalette, .about], id: \.self) { r in
                            SegmentedLinkRow(icon: "doc", title: r.title, subtitle: "") { appState.route = r }
                        }
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
        .sheet(isPresented: $showAbout) { AboutView() }
    }

    private func bind(_ keyPath: ReferenceWritableKeyPath<ThemeManager, Bool>) -> Binding<Bool> {
        Binding(get: { theme[keyPath: keyPath] }, set: { theme[keyPath: keyPath] = $0 })
    }

    private var modeMenu: some View {
        Menu {
            Button("Material 3") { theme.setUiMode(0) }
            Button("Miuix") { theme.setUiMode(1) }
        } label: { menuLabel(theme.uiMode == 0 ? "Material 3" : "Miuix") }
    }

    private var sucompatMenu: some View {
        Menu {
            Button("启用（默认）") { }
            Button("禁用直到下次重启") { }
            Button("始终禁用") { }
        } label: { menuLabel("启用（默认）") }
    }

    private func menuLabel(_ text: String) -> some View {
        HStack(spacing: 4) {
            Text(text)
            Image(systemName: "chevron.up.chevron.down").font(.system(size: 11))
        }
        .font(.system(size: 14))
        .foregroundColor(theme.palette.primary)
    }
}
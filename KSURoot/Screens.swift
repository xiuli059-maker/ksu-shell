import SwiftUI

enum AppRoute: String, Identifiable {
    case install, flash, moduleRepo, scriptRun, executeModuleAction
    case appProfile, template, templateEditor, sulog, colorPalette, about
    var id: String { rawValue }
    var title: String {
        switch self {
        case .install: return "安装"
        case .flash: return "刷写"
        case .moduleRepo: return "模块仓库"
        case .scriptRun: return "运行脚本"
        case .executeModuleAction: return "执行动作"
        case .appProfile: return "应用配置"
        case .template: return "配置模板"
        case .templateEditor: return "编辑模板"
        case .sulog: return "su 日志"
        case .colorPalette: return "主题"
        case .about: return "关于"
        }
    }
}

final class AppState: ObservableObject {
    @Published var route: AppRoute?
}

struct SubScreen<Content: View>: View {
    @EnvironmentObject var theme: ThemeManager
    @EnvironmentObject var appState: AppState
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button { appState.route = nil } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(theme.palette.onSurface)
                }
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(theme.palette.onSurface)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Rectangle().fill(theme.palette.outline.opacity(0.12)).frame(height: 0.5)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    content()
                }
                .padding(12)
                .padding(.bottom, 24)
            }
        }
        .background(theme.palette.surface.ignoresSafeArea())
    }
}

struct ScreenHost: View {
    let route: AppRoute
    var body: some View {
        switch route {
        case .install: InstallView()
        case .flash: FlashView()
        case .moduleRepo: ModuleRepoView()
        case .scriptRun: ScriptRunView()
        case .executeModuleAction: ExecuteModuleActionView()
        case .appProfile: AppProfileView()
        case .template: TemplateView()
        case .templateEditor: TemplateEditorView()
        case .sulog: SulogView()
        case .colorPalette: ColorPaletteView()
        case .about: AboutView()
        }
    }
}

// MARK: - Install
struct InstallView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var method = 0
    var body: some View {
        SubScreen(title: "安装") {
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 12) {
                    Text("选择安装方式").font(.system(size: 14)).foregroundColor(theme.palette.onSurfaceVariant)
                    methodRow("doc.badge.plus", "选择安装包", "选择一个压缩包进行安装", 0)
                    methodRow("shippingbox", "LKM 模式", "以可加载内核模块方式安装", 1)
                    methodRow("wrench.and.screwdriver", "修补 boot 镜像", "修补当前设备的 boot 镜像", 2)
                }
                .padding(16)
            }
            SegmentedColumn {
                SegmentedRow(icon: "memorychip", title: "目标分区", subtitle: "boot")
                SegmentedRow(icon: "internaldrive", title: "KMI", subtitle: "android12-5.10")
            }
            Button { } label: {
                Text("开始安装")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(theme.palette.primary).foregroundColor(theme.palette.onPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }
    private func methodRow(_ icon: String, _ title: String, _ sub: String, _ idx: Int) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 20)).foregroundColor(theme.palette.onSurfaceVariant).frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 16)).foregroundColor(theme.palette.onSurface)
                Text(sub).font(.system(size: 13)).foregroundColor(theme.palette.onSurfaceVariant)
            }
            Spacer()
            Image(systemName: method == idx ? "largecircle.fill.circle" : "circle")
                .foregroundColor(method == idx ? theme.palette.primary : theme.palette.onSurfaceVariant)
        }
        .contentShape(Rectangle())
        .onTapGesture { method = idx }
    }
}

// MARK: - Flash
struct FlashView: View {
    @EnvironmentObject var theme: ThemeManager
    var body: some View {
        SubScreen(title: "刷写") {
            SegmentedColumn {
                SegmentedRow(icon: "doc", title: "镜像", subtitle: "boot.img")
                SegmentedRow(icon: "memorychip", title: "分区", subtitle: "boot")
                SegmentedRow(icon: "checkmark.circle", title: "状态", subtitle: "就绪")
            }
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 10) {
                    HStack { Text("刷写进度").font(.system(size: 16)).foregroundColor(theme.palette.onSurface); Spacer(); Text("0%").font(.system(size: 13)).foregroundColor(theme.palette.onSurfaceVariant) }
                    ProgressView(value: 0).tint(theme.palette.primary)
                }
                .padding(16)
            }
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 4) {
                    Text("日志").font(.system(size: 14)).foregroundColor(theme.palette.onSurfaceVariant)
                    Text("$ fastboot flash boot boot.img\n等待开始...")
                        .font(.system(size: 13, design: .monospaced)).foregroundColor(theme.palette.onSurface)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(16)
            }
        }
    }
}

// MARK: - ModuleRepo
struct ModuleRepoView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var q = ""
    private let repos = [
        (name: "Zygisk - LSPosed", sum: "在 Zygisk 下运行的 Xposed 实现", stars: "12.3k"),
        (name: "Turbo Charge", sum: "调整充电电流与温控策略", stars: "860"),
        (name: "Systemless Hosts", sum: "系统级 hosts 支持", stars: "2.1k"),
        (name: "Magisk Mount", sum: "Magisk 模块挂载兼容", stars: "640")
    ]
    var body: some View {
        SubScreen(title: "模块仓库") {
            SearchField(text: $q, placeholder: "搜索仓库")
            SegmentedColumn {
                ForEach(Array(repos.enumerated()), id: \.offset) { _, r in
                    SegmentedRow(icon: "shippingbox", title: r.name, subtitle: r.sum,
                                 trailing: AnyView(HStack(spacing: 4) {
                                     Image(systemName: "star.fill").font(.system(size: 11))
                                     Text(r.stars).font(.system(size: 12))
                                 }.foregroundColor(theme.palette.onSurfaceVariant)))
                }
            }
        }
    }
}

// MARK: - ScriptRun
struct ScriptRunView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var arg = ""
    var body: some View {
        SubScreen(title: "运行脚本") {
            SegmentedColumn {
                SegmentedRow(icon: "doc.text", title: "脚本", subtitle: "service.sh")
                SegmentedRow(icon: "person", title: "作者", subtitle: "unknown")
                VStack(alignment: .leading, spacing: 6) {
                    Text("运行参数").font(.system(size: 13)).foregroundColor(theme.palette.onSurfaceVariant)
                    TextField("", text: $arg).foregroundColor(theme.palette.onSurface)
                }.padding(16)
            }
            Button { } label: {
                Text("运行")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(theme.palette.primary).foregroundColor(theme.palette.onPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }
}

// MARK: - ExecuteModuleAction
struct ExecuteModuleActionView: View {
    @EnvironmentObject var theme: ThemeManager
    var body: some View {
        SubScreen(title: "执行动作") {
            SegmentedColumn {
                SegmentedRow(icon: "play.circle", title: "动作", subtitle: "action.sh")
                SegmentedRow(icon: "checkmark.circle", title: "结果", subtitle: "执行成功")
            }
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 4) {
                    Text("输出").font(.system(size: 14)).foregroundColor(theme.palette.onSurfaceVariant)
                    Text("$ ./action.sh\n执行完成")
                        .font(.system(size: 13, design: .monospaced)).foregroundColor(theme.palette.onSurface)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(16)
            }
        }
    }
}

// MARK: - AppProfile
struct AppProfileView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var allowSu = true
    @State private var umount = false
    @State private var template = 0
    var body: some View {
        SubScreen(title: "应用配置") {
            SegmentedColumn {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 10).fill(theme.palette.surfaceContainerHigh).frame(width: 44, height: 44)
                        .overlay(Text("A").font(.system(size: 18, weight: .semibold)).foregroundColor(theme.palette.onSurfaceVariant))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("示例应用").font(.system(size: 16)).foregroundColor(theme.palette.onSurface)
                        Text("com.example.app").font(.system(size: 12)).foregroundColor(theme.palette.onSurfaceVariant)
                    }
                    Spacer()
                }.padding(16)
            }
            SegmentedColumn {
                SegmentedSwitchRow(icon: "checkmark.shield", title: "授予 su 权限", subtitle: "允许该应用获取 root", isOn: $allowSu)
                SegmentedSwitchRow(icon: "square.stack.3d.up.slash", title: "卸载模块", subtitle: "对该应用卸载 KernelSU 模块", isOn: $umount)
                SegmentedRow(icon: "doc.on.doc", title: "配置模板", subtitle: template == 0 ? "默认模板" : "root 模板")
            }
        }
    }
}

// MARK: - Template
struct TemplateView: View {
    @EnvironmentObject var theme: ThemeManager
    var body: some View {
        SubScreen(title: "配置模板") {
            SegmentedColumn {
                SegmentedLinkRow(icon: "doc.on.doc", title: "默认模板", subtitle: "适用于大多数应用")
                SegmentedLinkRow(icon: "doc.on.doc", title: "root 模板", subtitle: "授予完整 root 权限")
                SegmentedLinkRow(icon: "doc.on.doc", title: "隐私模板", subtitle: "隐藏 root 痕迹")
            }
        }
    }
}

// MARK: - TemplateEditor
struct TemplateEditorView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var text = "uid=0\ngid=0\ngroups=0\ncapabilities=ALL"
    var body: some View {
        SubScreen(title: "编辑模板") {
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 6) {
                    Text("内容").font(.system(size: 13)).foregroundColor(theme.palette.onSurfaceVariant)
                    TextEditor(text: $text)
                        .font(.system(size: 13, design: .monospaced))
                        .frame(height: 220)
                        .foregroundColor(theme.palette.onSurface)
                }.padding(16)
            }
            HStack(spacing: 12) {
                Button { } label: {
                    Text("取消").font(.system(size: 16, weight: .semibold)).frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(theme.palette.surfaceContainerHigh).foregroundColor(theme.palette.onSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                Button { } label: {
                    Text("保存").font(.system(size: 16, weight: .semibold)).frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(theme.palette.primary).foregroundColor(theme.palette.onPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
    }
}

// MARK: - Sulog
struct SulogView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var q = ""
    private let logs = [
        (t: "21:32:10", app: "MT管理器", pkg: "bin.mt.plus", ok: true),
        (t: "21:30:44", app: "Scene", pkg: "com.omarea.vtools", ok: false),
        (t: "21:28:03", app: "LSPosed", pkg: "org.lsposed.manager", ok: true),
        (t: "21:25:51", app: "开山斧", pkg: "com.kaishanfu.pro", ok: true)
    ]
    var body: some View {
        SubScreen(title: "su 日志") {
            SearchField(text: $q, placeholder: "搜索日志")
            SegmentedColumn {
                ForEach(Array(logs.enumerated()), id: \.offset) { _, l in
                    HStack(spacing: 12) {
                        Image(systemName: l.ok ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(l.ok ? theme.palette.primary : theme.palette.error)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(l.app).font(.system(size: 16)).foregroundColor(theme.palette.onSurface)
                            Text(l.pkg).font(.system(size: 12)).foregroundColor(theme.palette.onSurfaceVariant)
                        }
                        Spacer()
                        Text(l.t).font(.system(size: 12)).foregroundColor(theme.palette.onSurfaceVariant)
                    }.padding(16)
                }
            }
        }
    }
}

// MARK: - ColorPalette
struct ColorPaletteView: View {
    @EnvironmentObject var theme: ThemeManager
    var body: some View {
        SubScreen(title: "主题") {
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 12) {
                    Text("主题色").font(.system(size: 14)).foregroundColor(theme.palette.onSurfaceVariant)
                    HStack(spacing: 12) {
                        ForEach(0..<Seed.allCases.count, id: \.self) { i in
                            Circle().fill(Seed(rawValue: i)!.swatch).frame(width: 34, height: 34)
                                .overlay(Circle().stroke(theme.palette.onSurface, lineWidth: theme.seed == i ? 2 : 0))
                                .onTapGesture { theme.seed = i }
                        }
                    }
                }.padding(16)
            }
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 12) {
                    Text("深色模式").font(.system(size: 14)).foregroundColor(theme.palette.onSurfaceVariant)
                    HStack(spacing: 12) {
                        modeChip("深色", theme.isDark && !theme.amoled) { theme.isDark = true; theme.amoled = false }
                        modeChip("浅色", !theme.isDark) { theme.isDark = false; theme.amoled = false }
                        modeChip("AMOLED", theme.amoled) { theme.isDark = true; theme.amoled = true }
                    }
                }.padding(16)
            }
            SegmentedColumn {
                HStack(spacing: 12) {
                    Circle().fill(theme.palette.primary).frame(width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("预览").font(.system(size: 16)).foregroundColor(theme.palette.onSurface)
                        Text("当前主题色预览").font(.system(size: 12)).foregroundColor(theme.palette.onSurfaceVariant)
                    }
                    Spacer()
                    Text("Aa").font(.system(size: 20, weight: .bold)).foregroundColor(theme.palette.primary)
                }.padding(16)
            }
        }
    }
    private func modeChip(_ t: String, _ active: Bool, _ action: @escaping () -> Void) -> some View {
        Text(t).font(.system(size: 14, weight: .medium))
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(active ? theme.palette.primary : theme.palette.surfaceContainerHigh)
            .foregroundColor(active ? theme.palette.onPrimary : theme.palette.onSurface)
            .clipShape(Capsule())
            .onTapGesture { action() }
    }
}
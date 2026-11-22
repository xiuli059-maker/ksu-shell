import SwiftUI

// MARK: - 页面路由（对应 screen/ 下 15 个页面）
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

// MARK: - 子页面容器（顶部返回栏 + 内容）
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

// MARK: - Install（InstallScreenMiuix：选择安装方式）
struct InstallView: View {
    @EnvironmentObject var theme: ThemeManager
    var body: some View {
        SubScreen(title: "安装") {
            SegmentedColumn {
                SegmentedLinkRow(icon: "square.and.arrow.down", title: "选择并安装",
                                 subtitle: "选择一个压缩包 / boot 镜像进行安装")
                SegmentedLinkRow(icon: "shippingbox", title: "LKM 模式",
                                 subtitle: "以 LKM（可加载内核模块）方式安装")
                SegmentedLinkRow(icon: "wrench.and.screwdriver", title: "修补 boot 镜像",
                                 subtitle: "修补当前设备的 boot 镜像")
            }
        }
    }
}

// MARK: - Flash（FlashScreenMiuix：刷写进度）
struct FlashView: View {
    @EnvironmentObject var theme: ThemeManager
    var body: some View {
        SubScreen(title: "刷写") {
            SegmentedColumn {
                SegmentedRow(icon: "doc", title: "镜像", subtitle: "boot.img")
                SegmentedRow(icon: "memorychip", title: "分区", subtitle: "boot")
                SegmentedRow(icon: "checkmark.circle", title: "状态", subtitle: "等待开始")
            }
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 10) {
                    Text("进度").font(.system(size: 16)).foregroundColor(theme.palette.onSurface)
                    ProgressView(value: 0.0).tint(theme.palette.primary)
                }
                .padding(16)
            }
        }
    }
}

// MARK: - ModuleRepo（ModuleRepoScreenMiuix：模块仓库）
struct ModuleRepoView: View {
    @EnvironmentObject var theme: ThemeManager
    private let repos = [
        (name: "Zygisk - LSPosed", sum: "在 Zygisk 下运行的 Xposed 实现", stars: "12.3k"),
        (name: "Turbo Charge", sum: "调整充电电流与温控策略", stars: "860"),
        (name: "Systemless Hosts", sum: "系统级 hosts 支持", stars: "2.1k")
    ]
    var body: some View {
        SubScreen(title: "模块仓库") {
            SearchField(text: .constant(""), placeholder: "搜索仓库")
            SegmentedColumn {
                ForEach(Array(repos.enumerated()), id: \.offset) { _, r in
                    SegmentedRow(icon: "shippingbox",
                                 title: r.name, subtitle: r.sum,
                                 trailing: AnyView(
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill").font(.system(size: 11))
                                        Text(r.stars).font(.system(size: 12))
                                    }.foregroundColor(theme.palette.onSurfaceVariant)
                                 ))
                }
            }
        }
    }
}

// MARK: - ScriptRun（ScriptRunScreenMiuix：脚本参数表单）
struct ScriptRunView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var arg = ""
    var body: some View {
        SubScreen(title: "运行脚本") {
            SegmentedColumn {
                SegmentedRow(icon: "doc.text", title: "脚本", subtitle: "service.sh")
                field("参数", text: $arg)
            }
            Button { } label: {
                Text("运行")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(theme.palette.primary)
                    .foregroundColor(theme.palette.onPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }
    private func field(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.system(size: 13)).foregroundColor(theme.palette.onSurfaceVariant)
            TextField("", text: text)
                .foregroundColor(theme.palette.onSurface)
        }
        .padding(16)
    }
}

// MARK: - ExecuteModuleAction（ExecuteModuleActionScreenMiuix：执行输出）
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
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(theme.palette.onSurface)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            }
        }
    }
}

// MARK: - AppProfile（AppProfileScreenMiuix：应用配置）
struct AppProfileView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var allowSu = true
    @State private var umountModules = false
    var body: some View {
        SubScreen(title: "应用配置") {
            SegmentedColumn {
                SegmentedRow(icon: "app", title: "应用", subtitle: "com.example.app")
                SegmentedRow(icon: "person", title: "UID", subtitle: "10123")
            }
            SegmentedColumn {
                SegmentedSwitchRow(icon: "checkmark.shield", title: "授予 su 权限",
                                   subtitle: "允许该应用获取 root", isOn: $allowSu)
                SegmentedSwitchRow(icon: "square.stack.3d.up.slash", title: "卸载模块",
                                   subtitle: "对该应用卸载 KernelSU 模块", isOn: $umountModules)
            }
        }
    }
}

// MARK: - Template（AppProfileTemplateScreenMiuix：模板列表）
struct TemplateView: View {
    @EnvironmentObject var theme: ThemeManager
    var body: some View {
        SubScreen(title: "配置模板") {
            SegmentedColumn {
                SegmentedLinkRow(icon: "doc.on.doc", title: "默认模板", subtitle: "适用于大多数应用")
                SegmentedLinkRow(icon: "doc.on.doc", title: "root 模板", subtitle: "授予完整 root 权限")
            }
        }
    }
}

// MARK: - TemplateEditor（TemplateEditorScreenMiuix：模板编辑）
struct TemplateEditorView: View {
    @EnvironmentObject var theme: ThemeManager
    @State private var text = "uid=0\ngid=0\ngroups=0"
    var body: some View {
        SubScreen(title: "编辑模板") {
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 6) {
                    Text("内容").font(.system(size: 13)).foregroundColor(theme.palette.onSurfaceVariant)
                    TextEditor(text: $text)
                        .font(.system(size: 13, design: .monospaced))
                        .frame(height: 220)
                        .foregroundColor(theme.palette.onSurface)
                }
                .padding(16)
            }
        }
    }
}

// MARK: - Sulog（SulogScreenMiuix：su 日志）
struct SulogView: View {
    @EnvironmentObject var theme: ThemeManager
    private let logs = [
        (t: "21:32:10", app: "MT管理器", pkg: "bin.mt.plus", ok: true),
        (t: "21:30:44", app: "Scene", pkg: "com.omarea.vtools", ok: false),
        (t: "21:28:03", app: "LSPosed", pkg: "org.lsposed.manager", ok: true)
    ]
    var body: some View {
        SubScreen(title: "su 日志") {
            SearchField(text: .constant(""), placeholder: "搜索日志")
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
                    }
                    .padding(16)
                }
            }
        }
    }
}

// MARK: - ColorPalette（ColorPaletteScreenMiuix：主题色板）
struct ColorPaletteView: View {
    @EnvironmentObject var theme: ThemeManager
    var body: some View {
        SubScreen(title: "主题") {
            SegmentedColumn {
                VStack(alignment: .leading, spacing: 12) {
                    Text("主题色").font(.system(size: 14)).foregroundColor(theme.palette.onSurfaceVariant)
                    HStack(spacing: 12) {
                        ForEach(0..<Seed.allCases.count, id: \.self) { i in
                            Circle().fill(Seed(rawValue: i)!.swatch)
                                .frame(width: 34, height: 34)
                                .overlay(Circle().stroke(theme.palette.onSurface, lineWidth: theme.seed == i ? 2 : 0))
                                .onTapGesture { theme.seed = i }
                        }
                    }
                }
                .padding(16)
            }
            SegmentedColumn {
                HStack(spacing: 12) {
                    Circle().fill(theme.palette.primary).frame(width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("预览").font(.system(size: 16)).foregroundColor(theme.palette.onSurface)
                        Text("主题色预览").font(.system(size: 12)).foregroundColor(theme.palette.onSurfaceVariant)
                    }
                    Spacer()
                    Text("Aa").font(.system(size: 20, weight: .bold)).foregroundColor(theme.palette.primary)
                }
                .padding(16)
            }
        }
    }
}
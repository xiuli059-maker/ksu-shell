import SwiftUI

struct SettingsView: View {
    @State private var showAbout = false

    @State private var checkUpdate = true
    @State private var checkModuleUpdate = true
    @State private var kernelUmount = true
    @State private var selinuxHide = false
    @State private var sulog = false
    @State private var adbRoot = false
    @State private var profileTemplate = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                LargeTitle(text: "设置")

                VStack(spacing: 13) {
                    SegmentedColumn {
                        SegmentedSwitchRow(icon: "arrow.triangle.2.circlepath", title: "检查更新",
                                           subtitle: "启动时检查 KernelSU 管理器更新", isOn: $checkUpdate)
                        SegmentedSwitchRow(icon: "square.and.arrow.down", title: "模块更新检查",
                                           subtitle: "定期检查已安装模块的更新", isOn: $checkModuleUpdate)
                    }

                    SegmentedColumn {
                        SegmentedRow(icon: "display", title: "界面模式", subtitle: "Material 3",
                                     trailing: AnyView(Text("Material").font(.system(size: 14)).foregroundColor(Theme.primary)))
                        SegmentedLinkRow(icon: "paintpalette", title: "主题", subtitle: "深色模式、主题色与调色板")
                        SegmentedSwitchRow(icon: "doc.on.doc", title: "配置模板", subtitle: "为应用配置 UID / 挂载模板", isOn: $profileTemplate)
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
                        .foregroundColor(Theme.onSurfaceVariant)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Theme.surface.ignoresSafeArea())
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}
import Foundation

struct SystemInfo {
    var managerVersion: String
    var kernelVersion: String
    var deviceModel: String
    var fingerprint: String
    var selinux: String
    var seccomp: String
}

struct AppEntry: Identifiable {
    let id = UUID()
    var name: String
    var packageName: String
    var allowSu: Bool
}

struct ModuleEntry: Identifiable {
    let id = UUID()
    var name: String
    var version: String
    var author: String
    var detail: String
    var enabled: Bool
    var hasWebUi: Bool
    var hasAction: Bool
    var hasUpdate: Bool
    var meta: Bool
    var markedRemove: Bool
}

enum MockData {
    static let systemInfo = SystemInfo(
        managerVersion: "v3.2.5 (32525-2)",
        kernelVersion: "5.10.236-android12-9-g4b262e5255ed",
        deviceModel: "荣耀X50",
        fingerprint: "HONOR/ALI-AN00/HNALI-Q:15/HONORALI-AN00/9DLDLD230CNC00E206:user/release-keys",
        selinux: "宽容模式",
        seccomp: "严格模式"
    )

    static let apps: [AppEntry] = [
        AppEntry(name: "MT管理器", packageName: "bin.mt.plus", allowSu: true),
        AppEntry(name: "八门神器", packageName: "com.example.modmenu", allowSu: true),
        AppEntry(name: "开山斧", packageName: "com.kaishanfu.pro", allowSu: false),
        AppEntry(name: "Scene", packageName: "com.omarea.vtools", allowSu: false),
        AppEntry(name: "LSPosed", packageName: "org.lsposed.manager", allowSu: true)
    ]

    static let modules: [ModuleEntry] = [
        ModuleEntry(name: "Zygisk - LSPosed", version: "1.9.2 (7024)", author: "LSPosedDevelopers",
                    detail: "在 Zygisk 框架下运行的 Xposed 实现", enabled: true, hasWebUi: true,
                    hasAction: false, hasUpdate: true, meta: true, markedRemove: false),
        ModuleEntry(name: "Systemless Hosts", version: "1.0", author: "KernelSU",
                    detail: "提供系统级 hosts 支持，无需修改系统分区", enabled: true, hasWebUi: false,
                    hasAction: false, hasUpdate: false, meta: false, markedRemove: false),
        ModuleEntry(name: "Turbo Charge", version: "2.3", author: "acdb",
                    detail: "调整充电电流与温控策略", enabled: false, hasWebUi: true,
                    hasAction: true, hasUpdate: false, meta: false, markedRemove: false)
    ]
}
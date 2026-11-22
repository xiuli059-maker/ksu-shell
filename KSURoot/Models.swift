import Foundation
import UIKit

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

enum DeviceInfo {
    // UTSname machine identifier -> 市场机型名
    static let map: [String: String] = [
        "iPhone12,1": "iPhone 11",
        "iPhone12,3": "iPhone 11 Pro",
        "iPhone12,5": "iPhone 11 Pro Max",
        "iPhone12,8": "iPhone SE (2nd)",
        "iPhone13,1": "iPhone 12 mini",
        "iPhone13,2": "iPhone 12",
        "iPhone13,3": "iPhone 12 Pro",
        "iPhone13,4": "iPhone 12 Pro Max",
        "iPhone14,2": "iPhone 13 Pro",
        "iPhone14,3": "iPhone 13 Pro Max",
        "iPhone14,4": "iPhone 13 mini",
        "iPhone14,5": "iPhone 13",
        "iPhone14,6": "iPhone SE (3rd)",
        "iPhone14,7": "iPhone 14",
        "iPhone14,8": "iPhone 14 Plus",
        "iPhone15,2": "iPhone 14 Pro",
        "iPhone15,3": "iPhone 14 Pro Max",
        "iPhone15,4": "iPhone 15",
        "iPhone15,5": "iPhone 15 Plus",
        "iPhone16,1": "iPhone 15 Pro",
        "iPhone16,2": "iPhone 15 Pro Max",
        "iPhone17,1": "iPhone 16 Pro",
        "iPhone17,2": "iPhone 16 Pro Max",
        "iPhone17,3": "iPhone 16",
        "iPhone17,4": "iPhone 16 Plus",
        "iPhone17,5": "iPhone 16e",
        "iPhone18,1": "iPhone 17 Pro",
        "iPhone18,2": "iPhone 17 Pro Max",
        "iPhone18,3": "iPhone 17"
    ]

    static var modelName: String {
        var sys = utsname()
        uname(&sys)
        let mirror = Mirror(reflecting: sys.machine)
        let identifier = mirror.children.reduce(into: "") { result, element in
            guard let value = element.value as? Int8, value != 0 else { return }
            result += String(UnicodeScalar(UInt8(value)))
        }
        return map[identifier] ?? identifier
    }
}

enum MockData {
    // 内核版本按需求显示为 0；系统指纹显示为三个问号；设备型号取真实机型
    static var systemInfo: SystemInfo {
        SystemInfo(
            managerVersion: "v3.2.5 (32525-2)",
            kernelVersion: "iOS \(UIDevice.current.systemVersion)",
            deviceModel: DeviceInfo.modelName,
            fingerprint: "Apple",
            selinux: "宽容模式",
            seccomp: "严格模式"
        )
    }

    static let apps: [AppEntry] = []
    static let modules: [ModuleEntry] = []
}
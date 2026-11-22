import Foundation
import UIKit

struct BackupItem: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let url: URL
}

// MobileGestalt 编辑器内核：worse_query 获取访问，读写 CacheExtra，套用预设，备份/还原
final class MobileGestaltManager: ObservableObject {
    static let cachesDir = "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches"
    static let plistPath = cachesDir + "/com.apple.MobileGestalt.plist"
    static let appGroup = "group.com.example.ksuroot"

    @Published var status = "未连接"
    @Published var accessGranted = false
    @Published var entries: [(key: String, value: String)] = []
    @Published var enabledStates: [String: Bool] = [:]
    @Published var backups: [BackupItem] = []

    private var handle: Int64 = -1

    init() { reloadBackups() }

    @discardableResult
    func acquire() -> Bool {
        if accessGranted { return true }
        handle = worse_query(MobileGestaltManager.cachesDir, MobileGestaltManager.appGroup, false, false)
        accessGranted = handle > 0
        return accessGranted
    }

    func release() {
        if handle > 0 { worse_query_release(handle); handle = -1; accessGranted = false }
    }

    func load() {
        if !acquire() {
            status = "访问失败（\(handle)）· 需带 App Group 的签名"
            return
        }
        guard let plist = readPlist(), let extra = plist["CacheExtra"] as? [String: Any] else {
            status = "读取 MobileGestalt 失败"
            return
        }
        entries = extra.keys.sorted().map { ($0, "\(extra[$0]!)") }
        refreshStates(extra)
        status = "已加载 \(entries.count) 项"
    }

    private func readPlist() -> [String: Any]? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: MobileGestaltManager.plistPath)) else { return nil }
        return try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]
    }

    private func refreshStates(_ extra: [String: Any]) {
        var s: [String: Bool] = [:]
        for cap in Capability.all {
            let on = cap.keys.allSatisfy { k in
                if let n = extra[k] as? NSNumber { return n.intValue != 0 }
                if let a = extra[k] as? [Int] { return !a.isEmpty }
                return extra[k] != nil && !(extra[k] is NSNull)
            }
            s[cap.id] = on
        }
        enabledStates = s
    }

    func apply(_ cap: Capability, enable: Bool) {
        if !acquire() { status = "需要访问权限（需 App Group 签名）"; return }
        guard var plist = readPlist(), var extra = plist["CacheExtra"] as? [String: Any] else {
            status = "读取失败"
            return
        }
        backUp()
        for key in cap.keys {
            if enable {
                extra[key] = cap.values?[key] ?? cap.enabledValue
            } else {
                extra[key] = 0
            }
        }
        plist["CacheExtra"] = extra
        guard let out = try? PropertyListSerialization.data(fromPropertyList: plist, format: .binary, options: 0) else {
            status = "序列化失败"
            return
        }
        do {
            try out.write(to: URL(fileURLWithPath: MobileGestaltManager.plistPath))
            enabledStates[cap.id] = enable
            status = "\(cap.title)：\(enable ? "已开启" : "已关闭")"
        } catch {
            status = "写入失败：\(error.localizedDescription)"
        }
    }

    private func backupsDir() -> URL {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = base.appendingPathComponent("MobileGestaltBackups", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    func backUp() {
        if !acquire() { status = "备份失败：无访问权限"; return }
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd_HHmmss"
        let name = "MobileGestalt_\(df.string(from: Date())).plist"
        let dst = backupsDir().appendingPathComponent(name)
        do {
            try FileManager.default.copyItem(at: URL(fileURLWithPath: MobileGestaltManager.plistPath), to: dst)
            status = "已备份 \(name)"
        } catch {
            status = "备份失败：\(error.localizedDescription)"
        }
        reloadBackups()
    }

    func restore(_ item: BackupItem) {
        if !acquire() { status = "还原失败：无访问权限"; return }
        do {
            try Data(contentsOf: item.url).write(to: URL(fileURLWithPath: MobileGestaltManager.plistPath))
            status = "已还原 \(item.name)"
        } catch {
            status = "还原失败：\(error.localizedDescription)"
        }
    }

    func reloadBackups() {
        let dir = backupsDir()
        let files = (try? FileManager.default.contentsOfDirectory(
            at: dir, includingPropertiesForKeys: [.contentModificationDateKey]
        )) ?? []
        backups = files
            .filter { $0.pathExtension == "plist" }
            .map { u in
                let date = (try? u.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date()
                return BackupItem(name: u.lastPathComponent, date: date, url: u)
            }
            .sorted { $0.date > $1.date }
    }
}
import Foundation

final class FSManager: ObservableObject {
    struct Item: Identifiable {
        var id: String { path }
        let name: String
        let path: String
        let isDir: Bool
        let size: Int
    }

    @Published var current = ""
    @Published var items: [Item] = []
    @Published var status = ""

    private var handle: Int64 = -1

    static let roots: [(String, String)] = [
        ("App 容器", "/var/mobile/Containers/Data/Application"),
        ("App 组", "/var/mobile/Containers/Shared/AppGroup"),
        ("系统组", "/var/containers/Shared/SystemGroup"),
        ("数据系统(27)", "/var/containers/Data/System"),
        ("MobileGestalt", "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches")
    ]

    private func acquire(_ target: String) {
        if handle > 0 { worse_query_release(handle); handle = -1 }
        var groups = WQSignedAppGroups()
        if groups.isEmpty { groups = ["group.com.example.ksuroot"] }
        for g in groups {
            var h = worse_query(target, g, false, false)
            if h == -4, let root = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: g) {
                try? FileManager.default.createDirectory(at: root.appendingPathComponent("Library/Caches"), withIntermediateDirectories: true)
                h = worse_query(target, g, false, false)
            }
            if h >= 0 { handle = h; return }
        }
    }

    func open(_ path: String) {
        acquire(path)
        current = path
        let fm = FileManager.default
        var out: [Item] = []
        if let names = try? fm.contentsOfDirectory(atPath: path) {
            for n in names.sorted() {
                let full = (path as NSString).appendingPathComponent(n)
                var isDir: ObjCBool = false
                fm.fileExists(atPath: full, isDirectory: &isDir)
                let sz = (try? fm.attributesOfItem(atPath: full))?[.size] as? Int ?? 0
                out.append(Item(name: n, path: full, isDir: isDir.boolValue, size: sz))
            }
        }
        items = out
        status = out.isEmpty ? "无内容 · 或该路径未被授权" : "\(out.count) 项"
    }
}
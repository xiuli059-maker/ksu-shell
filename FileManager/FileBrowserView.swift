import SwiftUI

struct FileBrowserView: View {
    @StateObject private var fs = FSManager()
    @State private var path = FSManager.roots[0].1
    @State private var opened: OpenFile?

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    TextField("路径", text: $path)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Button("转到") { fs.open(path) }
                }
                .padding(12)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(FSManager.roots, id: \.1) { r in
                            Button(r.0) { path = r.1; fs.open(r.1) }
                                .font(.system(size: 13))
                                .padding(.horizontal, 10).padding(.vertical, 6)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 12)
                }

                Text(fs.status)
                    .font(.caption).foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12).padding(.vertical, 4)

                List(fs.items) { item in
                    HStack(spacing: 10) {
                        Image(systemName: item.isDir ? "folder.fill" : "doc.text")
                            .foregroundColor(item.isDir ? .blue : .gray)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name).font(.system(size: 15))
                            if !item.isDir {
                                Text(byteString(item.size)).font(.caption2).foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { tap(item) }
                }
                .listStyle(.plain)
            }
            .navigationTitle("文件管理")
        }
        .onAppear { fs.open(path) }
        .sheet(item: $opened) { f in FileTextView(file: f) }
    }

    private func tap(_ item: FSManager.Item) {
        if item.isDir { path = item.path; fs.open(item.path) }
        else { opened = OpenFile(path: item.path) }
    }

    private func byteString(_ n: Int) -> String {
        if n < 1024 { return "\(n) B" }
        if n < 1024 * 1024 { return String(format: "%.1f KB", Double(n) / 1024) }
        return String(format: "%.1f MB", Double(n) / 1048576)
    }
}

struct OpenFile: Identifiable {
    let id = UUID()
    let path: String
}

struct FileTextView: View {
    let file: OpenFile
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""

    var body: some View {
        NavigationView {
            ScrollView {
                Text(text)
                    .font(.system(size: 13, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .navigationTitle((file.path as NSString).lastPathComponent)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
        }
        .onAppear { load() }
    }

    private func load() {
        let url = URL(fileURLWithPath: file.path)
        guard let data = try? Data(contentsOf: url) else {
            text = "无法读取（无权限或不存在）"
            return
        }
        if let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let xml = try? PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0),
           let s = String(data: xml, encoding: .utf8) {
            text = s
        } else if let s = String(data: data, encoding: .utf8) {
            text = s
        } else {
            text = data.prefix(4096).map { String(format: "%02x", $0) }.joined(separator: " ")
        }
    }
}
import SwiftUI

struct SettingsView: View {
    @AppStorage("darkMode") private var darkMode = false

    var body: some View {
        NavigationView {
            Form {
                Section("外观") {
                    Toggle("深色模式", isOn: $darkMode)
                    Toggle("启动时显示状态", isOn: .constant(true))
                }

                Section("关于") {
                    HStack {
                        Text("应用名称")
                        Spacer()
                        Text("KernelSU（娱乐空壳）").foregroundColor(.secondary)
                    }
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0").foregroundColor(.secondary)
                    }
                }

                Section {
                    Text("本应用仅作娱乐展示，不含任何 Root / 越狱 / 系统修改功能。")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("设置")
        }
    }
}
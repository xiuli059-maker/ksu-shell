import SwiftUI

struct SettingsView: View {
    private let items: [(String, String)] = [
        ("深色模式", "已开启"),
        ("语言", "简体中文"),
        ("应用名称", "KernelSU"),
        ("版本", "v3.2.5 (32525-2)")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text(item.0).foregroundColor(.white)
                            Spacer()
                            Text(item.1).foregroundColor(Color(white: 0.55))
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)

                        if index < items.count - 1 {
                            Divider().background(Color(white: 0.22))
                        }
                    }
                }
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 16)

                Text("本应用仅作娱乐展示，不含任何 Root / 越狱 / 系统修改功能。")
                    .font(.footnote)
                    .foregroundColor(Color(white: 0.55))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)
            }
            .padding(.top, 10)
        }
        .background(Color.black.ignoresSafeArea())
    }
}
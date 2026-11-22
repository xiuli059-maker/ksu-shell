import SwiftUI

struct ModulesView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Image(systemName: "puzzlepiece.extension")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                Text("暂无模块")
                    .foregroundColor(.secondary)
                Text("此版本为娱乐空壳，不支持安装模块")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("模块")
        }
    }
}
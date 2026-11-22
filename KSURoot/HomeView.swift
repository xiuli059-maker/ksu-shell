import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    RootStatusCard()
                    InfoCard()
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("KernelSU")
        }
    }
}

struct RootStatusCard: View {
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 84, height: 84)
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 46))
                    .foregroundColor(.green)
            }
            Text("已获取 Root 权限")
                .font(.title2.bold())
            Text("KernelSU 已激活")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct InfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            InfoRow(label: "内核版本", value: "5.10.xxx-KernelSU")
            Divider().padding(.vertical, 10)
            InfoRow(label: "管理器版本", value: "1.0.0")
            Divider().padding(.vertical, 10)
            InfoRow(label: "工作模式", value: "GKI")
            Divider().padding(.vertical, 10)
            InfoRow(label: "SELinux", value: "Permissive")
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
}
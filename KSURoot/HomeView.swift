import SwiftUI

struct HomeView: View {
    private let info = MockData.systemInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 13) {
                LargeTitle(text: "KernelSU")

                HStack(spacing: 13) {
                    StatusCard()
                    VStack(spacing: 13) {
                        StatCard(title: "超级用户", value: "\(MockData.apps.filter { $0.allowSu }.count)")
                        StatCard(title: "模块", value: "\(MockData.modules.count)")
                    }
                    .frame(width: 116)
                }
                .frame(height: 182)

                SegmentedColumn {
                    SegmentedRow(icon: "tag", title: "管理器版本", subtitle: info.managerVersion)
                    SegmentedRow(icon: "cpu", title: "内核版本", subtitle: info.kernelVersion)
                    SegmentedRow(icon: "iphone", title: "设备型号", subtitle: info.deviceModel)
                    SegmentedRow(icon: "touchid", title: "系统指纹", subtitle: info.fingerprint)
                }

                SegmentedColumn {
                    SegmentedRow(icon: "lock.shield", title: "SELinux 状态", subtitle: info.selinux)
                    SegmentedRow(icon: "line.3.horizontal.decrease", title: "Seccomp 状态", subtitle: info.seccomp)
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
        }
        .background(Theme.surface.ignoresSafeArea())
    }
}

struct StatusCard: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: 0x1B3A20), Color(hex: 0x35633A)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            ZStack {
                Circle()
                    .stroke(Theme.primary.opacity(0.5), lineWidth: 13)
                    .frame(width: 128, height: 128)
                Image(systemName: "checkmark")
                    .font(.system(size: 58, weight: .bold))
                    .foregroundColor(Theme.primary)
            }
            .offset(x: 78, y: 66)

            VStack(alignment: .leading, spacing: 6) {
                Text("工作中 <LKM>")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundColor(.white)
                Text("版本: 32525-null")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.85))
                Spacer()
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Theme.onSurfaceVariant)
            Spacer(minLength: 0)
            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Theme.onSurface)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.surfaceBright)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
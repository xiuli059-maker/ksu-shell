import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 13) {
                Text("KernelSU")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.bottom, 2)

                HStack(spacing: 13) {
                    StatusCard()
                    VStack(spacing: 13) {
                        StatCard(title: "超级用户", value: "0")
                        StatCard(title: "模块", value: "0")
                    }
                    .frame(width: 112)
                }
                .frame(height: 182)

                InfoCard()

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.black.ignoresSafeArea())
    }
}

struct StatusCard: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.26, blue: 0.13),
                            Color(red: 0.30, green: 0.66, blue: 0.30)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            ZStack {
                Circle()
                    .stroke(Color(red: 0.38, green: 0.86, blue: 0.40).opacity(0.55), lineWidth: 13)
                    .frame(width: 128, height: 128)
                Image(systemName: "checkmark")
                    .font(.system(size: 58, weight: .bold))
                    .foregroundColor(Color(red: 0.40, green: 0.90, blue: 0.45))
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
                .foregroundColor(Color(white: 0.60))
            Spacer(minLength: 0)
            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(red: 0.16, green: 0.16, blue: 0.17))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct InfoCard: View {
    private let items: [(String, String)] = [
        ("管理器版本", "v3.2.5 (32525-2)"),
        ("内核版本", "5.10.236-android12-9-g4b262e5255ed"),
        ("设备型号", "荣耀X50"),
        ("系统指纹", "HONOR/ALI-AN00/HNALI-Q:15/HONORALI-AN00/9DLDLD230CNC00E206:user/release-keys"),
        ("SELinux 状态", "宽容模式"),
        ("Seccomp 状态", "严格模式")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.0)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    Text(item.1)
                        .font(.system(size: 15))
                        .foregroundColor(Color(white: 0.55))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 14)

                if index < items.count - 1 {
                    Divider().background(Color(white: 0.22))
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 4)
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
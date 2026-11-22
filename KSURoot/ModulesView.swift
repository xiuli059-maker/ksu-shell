import SwiftUI

struct SuperUserView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "shield.fill")
                .font(.system(size: 48))
                .foregroundColor(Color(white: 0.40))
            Text("暂无超级用户")
                .font(.system(size: 17))
                .foregroundColor(Color(white: 0.55))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

struct ModulesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "puzzlepiece.fill")
                .font(.system(size: 48))
                .foregroundColor(Color(white: 0.40))
            Text("暂无模块")
                .font(.system(size: 17))
                .foregroundColor(Color(white: 0.55))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}
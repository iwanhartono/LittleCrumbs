import SwiftUI

struct SoldOutBadge: View {
    var body: some View {
        Text("Sold Out")
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.red, in: Capsule())
    }
}

#Preview {
    SoldOutBadge()
}

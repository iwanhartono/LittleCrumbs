import SwiftUI

/// Order history/status tracking is a follow-up pass — see LocalOrder /
/// OrderHistoryStore, which already write data this screen will read later.
struct MyOrdersPlaceholderView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Coming Soon",
                systemImage: "bag.badge.clock",
                description: Text("Order tracking is on its way. For now, the bakery will confirm your order directly on WhatsApp or Instagram.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("AppBackground"))
            .navigationTitle("My Orders")
        }
    }
}

#Preview {
    MyOrdersPlaceholderView()
}

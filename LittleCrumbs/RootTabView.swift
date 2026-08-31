import SwiftUI

struct RootTabView: View {
    let repository: LittleCrumbsRepositoryProtocol
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home, menu, myOrders, about
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView(repository: repository) {
                    selectedTab = .menu
                }
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(Tab.home)

            MenuView(repository: repository)
                .tabItem { Label("Menu", systemImage: "list.bullet") }
                .tag(Tab.menu)

            MyOrdersPlaceholderView()
                .tabItem { Label("My Orders", systemImage: "bag.fill") }
                .tag(Tab.myOrders)

            AboutView(repository: repository)
                .tabItem { Label("About", systemImage: "info.circle.fill") }
                .tag(Tab.about)
        }
        .toolbarBackground(Color("AppBackground"), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

//
//  LittleCrumbsApp.swift
//  LittleCrumbs
//
//  Created by Iwan Hartono on 13/08/26.
//

import SwiftUI
import SwiftData

@main
struct LittleCrumbsApp: App {
    private let modelContainer: ModelContainer
    private let repository: LittleCrumbsRepositoryProtocol
    @State private var orderBagStore = OrderBagStore()
    @State private var appIconController = AppIconController(settingsStore: AppSettingsStore())
    @State private var themeController = AppThemeController(settingsStore: AppSettingsStore())

    init() {
        do {
            modelContainer = try ModelContainer(for: LocalOrder.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        let orderHistoryStore = OrderHistoryStore(modelContext: modelContainer.mainContext)
        repository = LittleCrumbsRepository(
            apiClient: MockLittleCrumbsAPIClient(),
            customerInfoStore: CustomerInfoStore(),
            orderHistoryStore: orderHistoryStore
        )
    }

    var body: some Scene {
        WindowGroup {
            RootTabView(repository: repository)
                .environment(orderBagStore)
                .environment(appIconController)
                .environment(themeController)
                .preferredColorScheme(themeController.preference.colorScheme)
        }
        .modelContainer(modelContainer)
    }
}

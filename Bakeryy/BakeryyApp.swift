//
//  BakeryyApp.swift
//  Bakeryy
//
//  Created by Iwan Hartono on 13/08/26.
//

import SwiftUI
import SwiftData

@main
struct BakeryyApp: App {
    private let modelContainer: ModelContainer
    private let repository: BakeryRepositoryProtocol
    @State private var orderBagStore = OrderBagStore()

    init() {
        do {
            modelContainer = try ModelContainer(for: LocalOrder.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        let orderHistoryStore = OrderHistoryStore(modelContext: modelContainer.mainContext)
        repository = BakeryRepository(
            apiClient: MockBakeryAPIClient(),
            customerInfoStore: CustomerInfoStore(),
            orderHistoryStore: orderHistoryStore
        )
    }

    var body: some Scene {
        WindowGroup {
            RootTabView(repository: repository)
                .environment(orderBagStore)
        }
        .modelContainer(modelContainer)
    }
}

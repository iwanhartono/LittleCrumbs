import Foundation

@MainActor
protocol BakeryRepositoryProtocol {
    func fetchConfig() async throws -> BakeryConfig
    func fetchCurrentPreorder() async throws -> Preorder
    func fetchProducts() async throws -> [Product]
    func fetchProduct(id: String) async throws -> Product

    func loadCustomerInfo() -> CustomerInfo
    func saveCustomerInfo(_ info: CustomerInfo)

    func saveOrder(itemsSummary: String, total: Int, customerInfo: CustomerInfo)
}

@MainActor
final class BakeryRepository: BakeryRepositoryProtocol {
    private let apiClient: BakeryAPIClient
    private let customerInfoStore: CustomerInfoStore
    private let orderHistoryStore: OrderHistoryStore

    init(
        apiClient: BakeryAPIClient,
        customerInfoStore: CustomerInfoStore,
        orderHistoryStore: OrderHistoryStore
    ) {
        self.apiClient = apiClient
        self.customerInfoStore = customerInfoStore
        self.orderHistoryStore = orderHistoryStore
    }

    func fetchConfig() async throws -> BakeryConfig {
        try await apiClient.fetchConfig()
    }

    func fetchCurrentPreorder() async throws -> Preorder {
        try await apiClient.fetchCurrentPreorder()
    }

    func fetchProducts() async throws -> [Product] {
        try await apiClient.fetchProducts()
    }

    func fetchProduct(id: String) async throws -> Product {
        try await apiClient.fetchProduct(id: id)
    }

    func loadCustomerInfo() -> CustomerInfo {
        customerInfoStore.load()
    }

    func saveCustomerInfo(_ info: CustomerInfo) {
        customerInfoStore.save(info)
    }

    func saveOrder(itemsSummary: String, total: Int, customerInfo: CustomerInfo) {
        let order = LocalOrder(
            itemsSummary: itemsSummary,
            total: total,
            customerName: customerInfo.name,
            phoneNumber: customerInfo.phoneNumber,
            fulfillmentMethod: customerInfo.fulfillmentMethod
        )
        orderHistoryStore.save(order)
    }
}

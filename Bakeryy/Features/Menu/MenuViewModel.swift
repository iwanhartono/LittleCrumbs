import Foundation
import Observation

@Observable
@MainActor
final class MenuViewModel {
    enum LoadState: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    private let repository: BakeryRepositoryProtocol

    private(set) var loadState: LoadState = .loading
    private(set) var products: [Product] = []
    var selectedCategory: ProductCategory?

    init(repository: BakeryRepositoryProtocol) {
        self.repository = repository
    }

    var filteredProducts: [Product] {
        guard let selectedCategory else { return products }
        return products.filter { $0.category == selectedCategory }
    }

    func load() async {
        loadState = .loading
        do {
            products = try await repository.fetchProducts()
            loadState = .loaded
        } catch {
            loadState = .failed("Couldn't load the menu. Pull to refresh to try again.")
        }
    }
}

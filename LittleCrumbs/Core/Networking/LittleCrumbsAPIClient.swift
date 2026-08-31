import Foundation

enum APIError: Error {
    case notFound
    case decodingFailed
}

/// Mirrors the PRD's documented backend endpoints (GET /bakery/config,
/// GET /preorders/current, GET /products, GET /products/{id}). A real
/// URLSession-backed implementation can conform to this later without any
/// changes to the repository or view models above it.
protocol LittleCrumbsAPIClient {
    func fetchConfig() async throws -> LittleCrumbsConfig
    func fetchCurrentPreorder() async throws -> Preorder
    func fetchProducts() async throws -> [Product]
    func fetchProduct(id: String) async throws -> Product
}

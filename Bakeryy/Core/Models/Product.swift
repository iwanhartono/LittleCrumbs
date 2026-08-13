import Foundation

enum ProductCategory: String, Codable, CaseIterable, Identifiable {
    case bread
    case pastries
    case bundles

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bread: return "Bread"
        case .pastries: return "Pastries"
        case .bundles: return "Bundles"
        }
    }
}

struct ProductVariant: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    /// Added on top of the product's base price.
    let priceDelta: Int
}

struct Product: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let shortDescription: String
    let description: String
    let ingredients: String
    /// Placeholder imagery until real product photography is available.
    let imageSystemName: String
    let category: ProductCategory
    let basePrice: Int
    let isAvailable: Bool
    let variants: [ProductVariant]
}

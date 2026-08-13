import Foundation
import Observation

@Observable
@MainActor
final class ProductDetailViewModel {
    let product: Product
    var selectedVariant: ProductVariant?
    var quantity: Int = 1
    var showFavoritesComingSoon = false

    init(product: Product) {
        self.product = product
        self.selectedVariant = product.variants.first
    }

    var unitPrice: Int {
        product.basePrice + (selectedVariant?.priceDelta ?? 0)
    }

    var totalPrice: Int {
        unitPrice * quantity
    }

    func favoriteTapped() {
        showFavoritesComingSoon = true
    }
}

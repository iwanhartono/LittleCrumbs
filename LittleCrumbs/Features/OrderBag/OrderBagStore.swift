import Foundation
import Observation

/// Single source of truth for the customer's in-progress order, shared
/// across Menu, Product Detail, Order Bag, and Customer Info via the
/// SwiftUI environment.
@Observable
final class OrderBagStore {
    private(set) var items: [OrderLineItem] = []

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var subtotal: Int {
        items.reduce(0) { $0 + $1.subtotal }
    }

    func add(product: Product, variant: ProductVariant?, quantity: Int) {
        guard quantity > 0 else { return }
        let lineId = [product.id, variant?.id ?? "base"].joined(separator: "-")
        if let index = items.firstIndex(where: { $0.id == lineId }) {
            items[index].quantity += quantity
        } else {
            let unitPrice = product.basePrice + (variant?.priceDelta ?? 0)
            items.append(
                OrderLineItem(
                    id: lineId,
                    productId: product.id,
                    productName: product.name,
                    variantId: variant?.id,
                    variantName: variant?.name,
                    quantity: quantity,
                    unitPrice: unitPrice
                )
            )
        }
    }

    func increment(_ item: OrderLineItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity += 1
    }

    func decrement(_ item: OrderLineItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity -= 1
        if items[index].quantity <= 0 {
            items.remove(at: index)
        }
    }

    func remove(_ item: OrderLineItem) {
        items.removeAll { $0.id == item.id }
    }

    func clear() {
        items.removeAll()
    }
}

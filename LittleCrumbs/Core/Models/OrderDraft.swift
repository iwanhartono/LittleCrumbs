import Foundation

struct OrderLineItem: Identifiable, Hashable {
    let id: String
    let productId: String
    let productName: String
    let variantId: String?
    let variantName: String?
    var quantity: Int
    let unitPrice: Int

    var subtotal: Int { unitPrice * quantity }
}

enum FulfillmentMethod: String, CaseIterable, Identifiable {
    case pickup
    case delivery

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pickup: return "Pickup"
        case .delivery: return "Delivery"
        }
    }
}

struct CustomerInfo: Hashable {
    var name: String = ""
    var phoneNumber: String = ""
    var fulfillmentMethod: FulfillmentMethod = .pickup
    var deliveryAddress: String = ""
    var notes: String = ""

    var isValid: Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        if fulfillmentMethod == .delivery {
            return !deliveryAddress.trimmingCharacters(in: .whitespaces).isEmpty
        }
        return true
    }
}

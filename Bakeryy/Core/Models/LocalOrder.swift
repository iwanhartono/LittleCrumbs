import Foundation
import SwiftData

enum OrderStatus: String, Codable {
    case waitingForConfirmation
    case waitingForPayment
    case paymentConfirmed
    case baking
    case readyForPickup
    case completed
    case cancelled

    var displayName: String {
        switch self {
        case .waitingForConfirmation: return "Waiting for Confirmation"
        case .waitingForPayment: return "Waiting for Payment"
        case .paymentConfirmed: return "Payment Confirmed"
        case .baking: return "Baking / Processing"
        case .readyForPickup: return "Ready for Pickup / Delivery"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        }
    }
}

/// Locally persisted record of an order that was handed off to the bakery via
/// WhatsApp/Instagram. The bakery remains the source of truth for real status;
/// this is only what the customer's device remembers about what it sent.
@Model
final class LocalOrder {
    var id: String
    var createdAt: Date
    var itemsSummary: String
    var total: Int
    var customerName: String
    var phoneNumber: String
    var fulfillmentMethodRawValue: String
    var statusRawValue: String

    init(
        id: String = UUID().uuidString,
        createdAt: Date = .now,
        itemsSummary: String,
        total: Int,
        customerName: String,
        phoneNumber: String,
        fulfillmentMethod: FulfillmentMethod,
        status: OrderStatus = .waitingForConfirmation
    ) {
        self.id = id
        self.createdAt = createdAt
        self.itemsSummary = itemsSummary
        self.total = total
        self.customerName = customerName
        self.phoneNumber = phoneNumber
        self.fulfillmentMethodRawValue = fulfillmentMethod.rawValue
        self.statusRawValue = status.rawValue
    }

    var status: OrderStatus {
        OrderStatus(rawValue: statusRawValue) ?? .waitingForConfirmation
    }
}

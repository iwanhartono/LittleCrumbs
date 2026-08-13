import Foundation

/// Remembers the customer's info locally (no account required) so returning
/// customers don't have to re-enter it for every order.
final class CustomerInfoStore {
    private let defaults: UserDefaults
    private let nameKey = "customerInfo.name"
    private let phoneKey = "customerInfo.phoneNumber"
    private let fulfillmentKey = "customerInfo.fulfillmentMethod"
    private let addressKey = "customerInfo.deliveryAddress"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> CustomerInfo {
        var info = CustomerInfo()
        info.name = defaults.string(forKey: nameKey) ?? ""
        info.phoneNumber = defaults.string(forKey: phoneKey) ?? ""
        if let raw = defaults.string(forKey: fulfillmentKey), let method = FulfillmentMethod(rawValue: raw) {
            info.fulfillmentMethod = method
        }
        info.deliveryAddress = defaults.string(forKey: addressKey) ?? ""
        return info
    }

    func save(_ info: CustomerInfo) {
        defaults.set(info.name, forKey: nameKey)
        defaults.set(info.phoneNumber, forKey: phoneKey)
        defaults.set(info.fulfillmentMethod.rawValue, forKey: fulfillmentKey)
        defaults.set(info.deliveryAddress, forKey: addressKey)
    }
}

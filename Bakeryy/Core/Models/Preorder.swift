import Foundation

enum PreorderState: String, Codable {
    case open
    case closed
}

struct Preorder: Codable, Hashable {
    let state: PreorderState
    /// When closed: the next date preorder opens. When open: informational only.
    let nextOpeningDate: Date
    /// When open: the date/time preorder closes.
    let closingDate: Date
    /// Human-readable pickup/delivery window, e.g. "Saturday & Sunday".
    let pickupDeliveryLabel: String
    let notes: String?
}

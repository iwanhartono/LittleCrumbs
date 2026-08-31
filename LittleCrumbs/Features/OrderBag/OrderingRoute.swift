import Foundation

/// Push destinations shared by the Menu tab's NavigationStack, covering the
/// PRD's single continuous ordering journey: Menu -> Product -> Bag -> Customer Info.
enum OrderingRoute: Hashable {
    case product(Product)
    case bag
    case customerInfo
}

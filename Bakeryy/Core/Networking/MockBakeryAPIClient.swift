import Foundation

private struct PreorderScheduleDTO: Codable {
    let state: PreorderState
    let pickupDeliveryLabel: String
    let notes: String?
}

/// Reads bundled JSON that mirrors the PRD's backend response shapes.
/// Swap this out for a URLSession-backed client conforming to the same
/// protocol once a real backend exists.
final class MockBakeryAPIClient: BakeryAPIClient {
    private let decoder = JSONDecoder()
    private let simulatedDelayNanoseconds: UInt64 = 300_000_000

    func fetchConfig() async throws -> BakeryConfig {
        try await simulateDelay()
        return try loadJSON("bakery_config", as: BakeryConfig.self)
    }

    func fetchCurrentPreorder() async throws -> Preorder {
        try await simulateDelay()
        let dto = try loadJSON("preorder", as: PreorderScheduleDTO.self)

        // Dates are computed relative to "now" (rather than stored in JSON)
        // so the demo data never looks stale. Matches the PRD's example
        // schedule: opens every Tuesday 8 PM, pickup/delivery that weekend.
        let calendar = Calendar.current
        let now = Date()
        let nextOpening = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: 20, minute: 0, weekday: 3),
            matchingPolicy: .nextTime
        ) ?? now
        let closing = calendar.date(byAdding: .day, value: 2, to: nextOpening) ?? nextOpening

        return Preorder(
            state: dto.state,
            nextOpeningDate: nextOpening,
            closingDate: closing,
            pickupDeliveryLabel: dto.pickupDeliveryLabel,
            notes: dto.notes
        )
    }

    func fetchProducts() async throws -> [Product] {
        try await simulateDelay()
        return try loadJSON("products", as: [Product].self)
    }

    func fetchProduct(id: String) async throws -> Product {
        let products = try await fetchProducts()
        guard let product = products.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        return product
    }

    private func simulateDelay() async throws {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
    }

    private func loadJSON<T: Decodable>(_ filename: String, as type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw APIError.notFound
        }
        let data = try Data(contentsOf: url)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}

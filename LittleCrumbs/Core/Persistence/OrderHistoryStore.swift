import Foundation
import SwiftData

/// Persists submitted orders locally. Write-only in this phase — the My
/// Orders screen that reads this data is a follow-up pass.
@MainActor
final class OrderHistoryStore {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ order: LocalOrder) {
        modelContext.insert(order)
        try? modelContext.save()
    }
}

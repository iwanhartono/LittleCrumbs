import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    enum LoadState: Equatable {
        case loading
        case loaded
        case failed(String)
    }

    private let repository: BakeryRepositoryProtocol

    private(set) var loadState: LoadState = .loading
    private(set) var config: BakeryConfig?
    private(set) var preorder: Preorder?
    var showNotifyMeComingSoon = false

    init(repository: BakeryRepositoryProtocol) {
        self.repository = repository
    }

    func load() async {
        loadState = .loading
        do {
            async let configResult = repository.fetchConfig()
            async let preorderResult = repository.fetchCurrentPreorder()
            let (config, preorder) = try await (configResult, preorderResult)
            self.config = config
            self.preorder = preorder
            loadState = .loaded
        } catch {
            loadState = .failed("Couldn't load bakery info. Pull to refresh to try again.")
        }
    }

    func notifyMeTapped() {
        showNotifyMeComingSoon = true
    }
}

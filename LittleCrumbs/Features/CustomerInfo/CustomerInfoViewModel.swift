import Foundation
import Observation

@Observable
@MainActor
final class CustomerInfoViewModel {
    private let repository: LittleCrumbsRepositoryProtocol

    var customerInfo: CustomerInfo

    init(repository: LittleCrumbsRepositoryProtocol) {
        self.repository = repository
        self.customerInfo = repository.loadCustomerInfo()
    }

    func persistCustomerInfo() {
        repository.saveCustomerInfo(customerInfo)
    }
}

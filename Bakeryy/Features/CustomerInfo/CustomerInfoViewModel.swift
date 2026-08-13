import Foundation
import Observation

@Observable
@MainActor
final class CustomerInfoViewModel {
    private let repository: BakeryRepositoryProtocol

    var customerInfo: CustomerInfo

    init(repository: BakeryRepositoryProtocol) {
        self.repository = repository
        self.customerInfo = repository.loadCustomerInfo()
    }

    func persistCustomerInfo() {
        repository.saveCustomerInfo(customerInfo)
    }
}

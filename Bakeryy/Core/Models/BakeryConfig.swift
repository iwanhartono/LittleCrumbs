import Foundation

struct PaymentConfig: Codable, Hashable {
    let bankName: String
    let accountNumber: String
    let accountHolder: String
    let instructions: String
}

struct BakeryConfig: Codable, Hashable {
    let bakeryName: String
    let tagline: String
    let whatsappNumber: String
    let instagramHandle: String
    let deliveryFee: Int
    let announcements: [String]
    let payment: PaymentConfig
}

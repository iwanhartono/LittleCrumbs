import Foundation
import UIKit

/// Builds the structured order message the PRD describes and hands it off
/// to WhatsApp or Instagram. The bakery still confirms every order manually
/// — this only prepares and opens the message, it never submits anything to
/// a backend.
enum OrderMessageBuilder {
    enum Channel {
        case whatsApp
        case instagram
    }

    static func buildMessage(items: [OrderLineItem], customerInfo: CustomerInfo, total: Int) -> String {
        var lines: [String] = ["Order"]
        for item in items {
            let variant = item.variantName.map { " (\($0))" } ?? ""
            lines.append("\(item.productName)\(variant) × \(item.quantity)")
        }
        lines.append("Total: \(CurrencyFormatter.format(total))")
        lines.append("Name: \(customerInfo.name)")
        if customerInfo.fulfillmentMethod == .delivery {
            lines.append("Delivery: \(customerInfo.deliveryAddress)")
        } else {
            lines.append("Pickup")
        }
        let notes = customerInfo.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        if !notes.isEmpty {
            lines.append("Notes: \(notes)")
        }
        return lines.joined(separator: "\n")
    }

    /// Attempts to hand the order message off to the given channel.
    /// Returns `true` only if the corresponding app could actually be opened.
    ///
    /// Note: unlike WhatsApp's `text=` query param, Instagram's URL scheme
    /// does not support prefilling DM text. For Instagram this opens the
    /// bakery's profile/DM and copies the message to the clipboard so the
    /// customer can paste it — a real platform limitation, not a bug.
    @MainActor
    static func send(_ message: String, via channel: Channel, config: LittleCrumbsConfig) -> Bool {
        switch channel {
        case .whatsApp:
            guard let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "whatsapp://send?phone=\(config.whatsappNumber)&text=\(encoded)"),
                  UIApplication.shared.canOpenURL(url) else {
                return false
            }
            UIApplication.shared.open(url)
            return true

        case .instagram:
            guard let url = URL(string: "instagram://user?username=\(config.instagramHandle)"),
                  UIApplication.shared.canOpenURL(url) else {
                return false
            }
            UIPasteboard.general.string = message
            UIApplication.shared.open(url)
            return true
        }
    }
}

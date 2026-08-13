import SwiftUI

enum CurrencyFormatter {
    static func format(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = "."
        let numberString = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "Rp\(numberString)"
    }
}

struct PriceText: View {
    let amount: Int
    var font: Font = .body
    var weight: Font.Weight = .regular

    var body: some View {
        Text(CurrencyFormatter.format(amount))
            .font(font)
            .fontWeight(weight)
    }
}

#Preview {
    PriceText(amount: 95000, font: .title3, weight: .bold)
}

import SwiftUI

struct ProductCardView: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 64, height: 64)
                    .overlay {
                        Image(systemName: product.imageSystemName)
                            .font(.title2)
                            .foregroundStyle(.tint)
                    }

                if !product.isAvailable {
                    SoldOutBadge()
                        .scaleEffect(0.75)
                        .offset(x: 10, y: -8)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                Text(product.shortDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                PriceText(amount: product.basePrice, font: .subheadline, weight: .semibold)
            }

            Spacer(minLength: 0)
        }
        .opacity(product.isAvailable ? 1 : 0.55)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

#Preview {
    ProductCardView(
        product: Product(
            id: "milk-bread",
            name: "Milk Bread",
            shortDescription: "Soft and fluffy classic",
            description: "",
            ingredients: "",
            imageSystemName: "takeoutbag.and.cup.and.straw.fill",
            category: .bread,
            basePrice: 28000,
            isAvailable: true,
            variants: []
        )
    )
    .padding()
}

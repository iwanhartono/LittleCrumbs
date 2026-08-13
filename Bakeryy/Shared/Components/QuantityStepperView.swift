import SwiftUI

struct QuantityStepperView: View {
    @Binding var quantity: Int
    var range: ClosedRange<Int> = 1...20

    var body: some View {
        HStack(spacing: 16) {
            Button {
                if quantity > range.lowerBound { quantity -= 1 }
            } label: {
                Image(systemName: "minus.circle.fill")
            }
            .disabled(quantity <= range.lowerBound)

            Text("\(quantity)")
                .font(.headline)
                .frame(minWidth: 24)
                .monospacedDigit()

            Button {
                if quantity < range.upperBound { quantity += 1 }
            } label: {
                Image(systemName: "plus.circle.fill")
            }
            .disabled(quantity >= range.upperBound)
        }
        .font(.title2)
        .foregroundStyle(.tint)
        .buttonStyle(.plain)
    }
}

#Preview {
    QuantityStepperView(quantity: .constant(2))
}

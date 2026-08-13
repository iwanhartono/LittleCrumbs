import SwiftUI

struct OrderBagView: View {
    @Environment(OrderBagStore.self) private var orderBag
    @Binding var path: [OrderingRoute]
    let repository: BakeryRepositoryProtocol

    @State private var deliveryFee: Int = 0

    var body: some View {
        Group {
            if orderBag.items.isEmpty {
                emptyState
                    .background(Color("AppBackground"))
            } else {
                List {
                    Section("Items") {
                        ForEach(orderBag.items) { item in
                            itemRow(item)
                        }
                    }
                    .listRowBackground(Color("CardBackground"))
                    Section {
                        summaryRow(title: "Subtotal", value: orderBag.subtotal)
                        summaryRow(title: "Delivery Fee (if delivery)", value: deliveryFee)
                        summaryRow(title: "Estimated Total", value: orderBag.subtotal + deliveryFee, emphasized: true)
                    }
                    .listRowBackground(Color("CardBackground"))
                }
                .scrollContentBackground(.hidden)
                .background(Color("AppBackground"))
            }
        }
        .navigationTitle("Order Bag")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            deliveryFee = (try? await repository.fetchConfig())?.deliveryFee ?? 0
        }
        .safeAreaInset(edge: .bottom) {
            if !orderBag.items.isEmpty {
                Button {
                    path.append(.customerInfo)
                } label: {
                    Text("Continue Order")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding()
                .background(.bar)
            }
        }
    }

    private func itemRow(_ item: OrderLineItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.productName).font(.subheadline.weight(.semibold))
                if let variantName = item.variantName {
                    Text(variantName).font(.caption).foregroundStyle(.secondary)
                }
                PriceText(amount: item.unitPrice, font: .caption, weight: .regular)
            }
            Spacer()
            HStack(spacing: 12) {
                Button {
                    orderBag.decrement(item)
                } label: {
                    Image(systemName: "minus.circle.fill")
                }
                Text("\(item.quantity)")
                    .frame(minWidth: 20)
                    .monospacedDigit()
                Button {
                    orderBag.increment(item)
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.tint)
            PriceText(amount: item.subtotal, font: .subheadline, weight: .semibold)
                .frame(width: 90, alignment: .trailing)
        }
        .swipeActions {
            Button("Remove", role: .destructive) {
                orderBag.remove(item)
            }
        }
    }

    private func summaryRow(title: String, value: Int, emphasized: Bool = false) -> some View {
        HStack {
            Text(title)
                .fontWeight(emphasized ? .bold : .regular)
            Spacer()
            PriceText(amount: value, weight: emphasized ? .bold : .regular)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "bag")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("Your order bag is empty")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

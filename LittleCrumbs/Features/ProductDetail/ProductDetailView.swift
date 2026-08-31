import SwiftUI

struct ProductDetailView: View {
    @State private var viewModel: ProductDetailViewModel
    @Environment(OrderBagStore.self) private var orderBag
    @Binding var path: [OrderingRoute]
    @State private var showAddedConfirmation = false

    init(product: Product, path: Binding<[OrderingRoute]>) {
        _viewModel = State(initialValue: ProductDetailViewModel(product: product))
        _path = path
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                imageHeader
                titleSection
                if !viewModel.product.variants.isEmpty {
                    variantPicker
                }
                Divider()
                descriptionSection
                Divider()
                ingredientsSection
            }
            .padding()
            .padding(.bottom, 60)
        }
        .background(Color("AppBackground"))
        .safeAreaInset(edge: .bottom) {
            addToOrderBar
        }
        .navigationTitle(viewModel.product.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.favoriteTapped()
                } label: {
                    Image(systemName: "heart")
                }
            }
        }
        .alert("Coming Soon", isPresented: $viewModel.showFavoritesComingSoon) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Favorites aren't available yet — check back soon!")
        }
        .alert("Added to Order", isPresented: $showAddedConfirmation) {
            Button("Keep Browsing", role: .cancel) {}
            Button("View Order Bag") { path.append(.bag) }
        } message: {
            Text("\(viewModel.quantity) x \(viewModel.product.name) added to your order.")
        }
    }

    private var imageHeader: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.accentColor.opacity(0.12))
            .frame(height: 220)
            .frame(maxWidth: .infinity)
            .overlay {
                Image(systemName: viewModel.product.imageSystemName)
                    .font(.system(size: 64))
                    .foregroundStyle(.tint)
            }
            .overlay(alignment: .topTrailing) {
                if !viewModel.product.isAvailable {
                    SoldOutBadge().padding(12)
                }
            }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.product.name)
                .font(.title2.bold())
            Text(viewModel.product.shortDescription)
                .foregroundStyle(.secondary)
            PriceText(amount: viewModel.unitPrice, font: .title3, weight: .semibold)
        }
    }

    private var variantPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Options").font(.headline)
            Picker("Variant", selection: $viewModel.selectedVariant) {
                ForEach(viewModel.product.variants) { variant in
                    Text(variant.name).tag(Optional(variant))
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Description").font(.headline)
            Text(viewModel.product.description)
                .foregroundStyle(.secondary)
        }
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Ingredients").font(.headline)
            Text(viewModel.product.ingredients)
                .foregroundStyle(.secondary)
        }
    }

    private var addToOrderBar: some View {
        HStack {
            QuantityStepperView(quantity: $viewModel.quantity)
            Spacer()
            Button {
                orderBag.add(product: viewModel.product, variant: viewModel.selectedVariant, quantity: viewModel.quantity)
                showAddedConfirmation = true
            } label: {
                Text(viewModel.product.isAvailable ? "Add to Order · \(CurrencyFormatter.format(viewModel.totalPrice))" : "Sold Out")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!viewModel.product.isAvailable)
        }
        .padding()
        .background(.bar)
    }
}

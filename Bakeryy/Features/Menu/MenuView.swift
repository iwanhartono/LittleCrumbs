import SwiftUI

struct MenuView: View {
    @State private var viewModel: MenuViewModel
    @State private var path: [OrderingRoute] = []
    @Environment(OrderBagStore.self) private var orderBag
    private let repository: BakeryRepositoryProtocol

    init(repository: BakeryRepositoryProtocol) {
        self.repository = repository
        _viewModel = State(initialValue: MenuViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationTitle("Our Menu")
                .toolbar { bagToolbarButton }
                .navigationDestination(for: OrderingRoute.self) { route in
                    switch route {
                    case .product(let product):
                        ProductDetailView(product: product, path: $path)
                    case .bag:
                        OrderBagView(path: $path, repository: repository)
                    case .customerInfo:
                        CustomerInfoView(repository: repository, path: $path)
                    }
                }
                .task { await viewModel.load() }
                .refreshable { await viewModel.load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.loadState {
        case .loading:
            ProgressView()
        case .failed(let message):
            errorView(message)
        case .loaded:
            VStack(spacing: 0) {
                categoryFilter
                List {
                    ForEach(viewModel.filteredProducts) { product in
                        NavigationLink(value: OrderingRoute.product(product)) {
                            ProductCardView(product: product)
                        }
                        .listRowBackground(Color("AppBackground"))
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .background(Color("AppBackground"))
        }
    }

    private var bagToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                path.append(.bag)
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bag")
                    if orderBag.itemCount > 0 {
                        Text("\(orderBag.itemCount)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(4)
                            .background(Circle().fill(.red))
                            .offset(x: 10, y: -10)
                    }
                }
            }
        }
    }

    private var categoryFilter: some View {
        HStack {
            categoryChip(title: "All", isSelected: viewModel.selectedCategory == nil) {
                viewModel.selectedCategory = nil
            }
            ForEach(ProductCategory.allCases) { category in
                categoryChip(title: category.displayName, isSelected: viewModel.selectedCategory == category) {
                    viewModel.selectedCategory = category
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func categoryChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.12), in: Capsule())
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Try Again") {
                Task { await viewModel.load() }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

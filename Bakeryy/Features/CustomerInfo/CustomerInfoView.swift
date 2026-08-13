import SwiftUI

struct CustomerInfoView: View {
    @State private var viewModel: CustomerInfoViewModel
    @Environment(OrderBagStore.self) private var orderBag
    @Binding var path: [OrderingRoute]
    private let repository: BakeryRepositoryProtocol

    @State private var config: BakeryConfig?
    @State private var showSendOptions = false
    @State private var showCannotOpenAlert = false
    @State private var cannotOpenAppName = ""
    @State private var showOrderSentConfirmation = false

    init(repository: BakeryRepositoryProtocol, path: Binding<[OrderingRoute]>) {
        self.repository = repository
        _viewModel = State(initialValue: CustomerInfoViewModel(repository: repository))
        _path = path
    }

    var body: some View {
        Form {
            Section("Your Information") {
                TextField("Name", text: $viewModel.customerInfo.name)
                    .textContentType(.name)
                TextField("Phone Number", text: $viewModel.customerInfo.phoneNumber)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
            }

            Section("Fulfillment") {
                Picker("Method", selection: $viewModel.customerInfo.fulfillmentMethod) {
                    ForEach(FulfillmentMethod.allCases) { method in
                        Text(method.displayName).tag(method)
                    }
                }
                .pickerStyle(.segmented)

                if viewModel.customerInfo.fulfillmentMethod == .delivery {
                    TextField("Delivery Address", text: $viewModel.customerInfo.deliveryAddress, axis: .vertical)
                }
            }

            Section("Order Notes (Optional)") {
                TextField("Anything we should know?", text: $viewModel.customerInfo.notes, axis: .vertical)
            }

            Section {
                summaryRow(title: "Subtotal", value: orderBag.subtotal)
                if viewModel.customerInfo.fulfillmentMethod == .delivery {
                    summaryRow(title: "Delivery Fee", value: config?.deliveryFee ?? 0)
                }
                summaryRow(title: "Estimated Total", value: estimatedTotal, emphasized: true)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("AppBackground"))
        .navigationTitle("Your Order")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            config = try? await repository.fetchConfig()
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                showSendOptions = true
            } label: {
                Text("Send Order")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!viewModel.customerInfo.isValid || config == nil)
            .padding()
            .background(.bar)
        }
        .confirmationDialog("Send your order via", isPresented: $showSendOptions, titleVisibility: .visible) {
            Button("Send via WhatsApp") { send(via: .whatsApp) }
            Button("Send via Instagram") { send(via: .instagram) }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Couldn't Open \(cannotOpenAppName)", isPresented: $showCannotOpenAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("\(cannotOpenAppName) doesn't seem to be installed on this device.")
        }
        .alert("Order Sent", isPresented: $showOrderSentConfirmation) {
            Button("Done") { path.removeAll() }
        } message: {
            Text("We've prepared your order message. The bakery will confirm availability and send payment details.")
        }
    }

    private var estimatedTotal: Int {
        var total = orderBag.subtotal
        if viewModel.customerInfo.fulfillmentMethod == .delivery {
            total += config?.deliveryFee ?? 0
        }
        return total
    }

    private func send(via channel: OrderMessageBuilder.Channel) {
        guard let config else { return }

        let message = OrderMessageBuilder.buildMessage(
            items: orderBag.items,
            customerInfo: viewModel.customerInfo,
            total: estimatedTotal
        )

        let opened = OrderMessageBuilder.send(message, via: channel, config: config)

        guard opened else {
            cannotOpenAppName = channel == .whatsApp ? "WhatsApp" : "Instagram"
            showCannotOpenAlert = true
            return
        }

        viewModel.persistCustomerInfo()
        repository.saveOrder(
            itemsSummary: message,
            total: estimatedTotal,
            customerInfo: viewModel.customerInfo
        )
        orderBag.clear()
        showOrderSentConfirmation = true
    }

    private func summaryRow(title: String, value: Int, emphasized: Bool = false) -> some View {
        HStack {
            Text(title).fontWeight(emphasized ? .bold : .regular)
            Spacer()
            PriceText(amount: value, weight: emphasized ? .bold : .regular)
        }
    }
}

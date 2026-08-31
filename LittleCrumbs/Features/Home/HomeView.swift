import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    var onOrderNow: () -> Void

    init(repository: LittleCrumbsRepositoryProtocol, onOrderNow: @escaping () -> Void) {
        _viewModel = State(initialValue: HomeViewModel(repository: repository))
        self.onOrderNow = onOrderNow
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                switch viewModel.loadState {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)
                case .failed(let message):
                    errorView(message)
                case .loaded:
                    tagline
                    preorderCard
                    announcements
                }
            }
            .padding()
        }
        .background(Color("AppBackground"))
        .navigationTitle(viewModel.config?.bakeryName ?? "LittleCrumbs")
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
        .alert("Coming Soon", isPresented: $viewModel.showNotifyMeComingSoon) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Notifications for preorder openings aren't available yet — check back soon!")
        }
    }

    @ViewBuilder
    private var tagline: some View {
        if let tagline = viewModel.config?.tagline {
            Text(tagline)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var preorderCard: some View {
        if let preorder = viewModel.preorder {
            VStack(alignment: .leading, spacing: 12) {
                Label(
                    preorder.state == .open ? "Preorder Open" : "Preorder Closed",
                    systemImage: preorder.state == .open ? "checkmark.circle.fill" : "clock.fill"
                )
                .font(.headline)
                .foregroundStyle(preorder.state == .open ? .green : .secondary)

                if preorder.state == .open {
                    infoRow(title: "Closes on", value: preorder.closingDate.weekdayTimeString)
                    infoRow(title: "Pickup / Delivery", value: preorder.pickupDeliveryLabel)
                } else {
                    infoRow(title: "Next preorder opens", value: preorder.nextOpeningDate.weekdayTimeString)
                }

                if let notes = preorder.notes {
                    Text(notes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Button {
                    if preorder.state == .open {
                        onOrderNow()
                    } else {
                        viewModel.notifyMeTapped()
                    }
                } label: {
                    Text(preorder.state == .open ? "Order Now" : "Notify Me")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
            .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    @ViewBuilder
    private var announcements: some View {
        if let announcements = viewModel.config?.announcements, !announcements.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Announcements")
                    .font(.headline)
                ForEach(announcements, id: \.self) { announcement in
                    Label(announcement, systemImage: "megaphone.fill")
                        .font(.subheadline)
                }
            }
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
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

import SwiftUI

/// Full About/FAQ/privacy content is a follow-up pass; this shows the
/// bakery's basic contact info, which the repository already exposes.
struct AboutView: View {
    let repository: BakeryRepositoryProtocol
    @State private var config: BakeryConfig?

    var body: some View {
        NavigationStack {
            List {
                if let config {
                    Section {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(config.bakeryName)
                                .font(.title2.bold())
                            Text(config.tagline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    Section("Contact") {
                        Label("WhatsApp: \(config.whatsappNumber)", systemImage: "message.fill")
                        Label("Instagram: @\(config.instagramHandle)", systemImage: "camera.fill")
                    }
                }
                Section {
                    ContentUnavailableView(
                        "More Coming Soon",
                        systemImage: "info.circle",
                        description: Text("FAQ and full bakery details are on their way.")
                    )
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("AppBackground"))
            .navigationTitle("About")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .task {
                config = try? await repository.fetchConfig()
            }
        }
    }
}

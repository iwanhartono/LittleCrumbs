import SwiftUI

struct PreferencePickerSection<T: SettingsChoice>: View {
    /// Distinguishes rows when the same option labels appear in more than
    /// one picker on screen (e.g. two "Dark" buttons) — used to build
    /// unique accessibility identifiers for UI testing.
    let id: String
    let selected: T
    let onSelect: (T) -> Void
    let header: String
    let footer: String

    var body: some View {
        Section {
            ForEach(T.allCases) { option in
                Button {
                    onSelect(option)
                } label: {
                    HStack {
                        Text(option.displayName)
                            .foregroundStyle(.primary)
                        Spacer()
                        if option == selected {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("\(id).\(option.id)")
            }
        } header: {
            Text(header)
        } footer: {
            Text(footer)
        }
    }
}

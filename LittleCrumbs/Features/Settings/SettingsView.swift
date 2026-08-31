import SwiftUI

struct SettingsView: View {
    @Environment(AppIconController.self) private var iconController
    @Environment(AppThemeController.self) private var themeController

    var body: some View {
        List {
            PreferencePickerSection(
                id: "theme",
                selected: themeController.preference,
                onSelect: { themeController.selectPreference($0) },
                header: "Appearance",
                footer: "Choose whether LittleCrumbs' screens stay light, stay dark, or automatically follow your device's appearance setting."
            )

            PreferencePickerSection(
                id: "icon",
                selected: iconController.preference,
                onSelect: { iconController.selectPreference($0) },
                header: "App Icon",
                footer: "Choose whether the app icon stays light, stays dark, or automatically follows your device's appearance setting."
            )
        }
        .scrollContentBackground(.hidden)
        .background(Color("AppBackground"))
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Error",
            isPresented: Binding(
                get: { iconController.errorMessage != nil },
                set: { isPresented in
                    if !isPresented { iconController.errorMessage = nil }
                }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(iconController.errorMessage ?? "")
        }
    }
}

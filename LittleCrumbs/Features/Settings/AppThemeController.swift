import Foundation
import Observation

/// Owns the in-app theme preference. Unlike the app icon, overriding
/// SwiftUI's color scheme via `.preferredColorScheme` has no system
/// confirmation dialog and can safely be applied live, so this simply
/// exposes the current preference for the app root to bind to.
@Observable
@MainActor
final class AppThemeController {
    private let settingsStore: AppSettingsStore

    private(set) var preference: AppThemePreference

    init(settingsStore: AppSettingsStore) {
        self.settingsStore = settingsStore
        self.preference = settingsStore.loadThemePreference()
    }

    func selectPreference(_ preference: AppThemePreference) {
        self.preference = preference
        settingsStore.saveThemePreference(preference)
    }
}

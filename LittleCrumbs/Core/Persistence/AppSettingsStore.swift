import Foundation

/// Remembers the user's app-wide preferences: app icon and in-app theme.
final class AppSettingsStore {
    private let defaults: UserDefaults
    private let iconPreferenceKey = "appSettings.iconPreference"
    private let themePreferenceKey = "appSettings.themePreference"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadIconPreference() -> AppIconPreference {
        guard let raw = defaults.string(forKey: iconPreferenceKey),
              let preference = AppIconPreference(rawValue: raw) else {
            return .system
        }
        return preference
    }

    func saveIconPreference(_ preference: AppIconPreference) {
        defaults.set(preference.rawValue, forKey: iconPreferenceKey)
    }

    func loadThemePreference() -> AppThemePreference {
        guard let raw = defaults.string(forKey: themePreferenceKey),
              let preference = AppThemePreference(rawValue: raw) else {
            return .system
        }
        return preference
    }

    func saveThemePreference(_ preference: AppThemePreference) {
        defaults.set(preference.rawValue, forKey: themePreferenceKey)
    }
}

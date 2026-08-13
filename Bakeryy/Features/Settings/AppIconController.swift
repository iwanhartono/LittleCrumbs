import Foundation
import Observation
import UIKit

/// Owns the app icon preference and applies it via `setAlternateIconName`.
///
/// "Follow System" resolves to the fixed Light or Dark alternate icon
/// matching the current system appearance at the moment it's selected,
/// rather than relying on the primary icon's built-in per-appearance
/// asset variants or trying to keep it live-synced afterward.
///
/// The real system appearance is read from `UIScreen`'s trait collection
/// rather than SwiftUI's `colorScheme` environment value — the app's own
/// "Appearance" theme override (`.preferredColorScheme`, see
/// `AppThemeController`) rewrites that environment value for the whole
/// view hierarchy, so reading it here would make the icon follow the
/// in-app theme instead of the actual device setting.
///
/// iOS shows a system confirmation dialog ("You have changed the icon for
/// ...") whenever `setAlternateIconName` actually changes the icon, and
/// that dialog cannot be suppressed. So the icon is only ever touched in
/// direct response to the user picking a preference in Settings — never
/// automatically on launch or in response to the system appearance
/// changing — since an automatic call could show that confirmation
/// unprompted, with no guarantee the user notices or confirms it.
@Observable
@MainActor
final class AppIconController {
    private let settingsStore: AppSettingsStore

    private(set) var preference: AppIconPreference
    var errorMessage: String?

    init(settingsStore: AppSettingsStore) {
        self.settingsStore = settingsStore
        self.preference = settingsStore.loadIconPreference()
    }

    func selectPreference(_ preference: AppIconPreference) {
        self.preference = preference
        settingsStore.saveIconPreference(preference)

        let isDark = Self.systemUserInterfaceStyle == .dark
        let targetIconName: String
        switch preference {
        case .light:
            targetIconName = "AppIcon-Light"
        case .dark:
            targetIconName = "AppIcon-Dark"
        case .system:
            targetIconName = isDark ? "AppIcon-Dark" : "AppIcon-Light"
        }

        guard UIApplication.shared.alternateIconName != targetIconName else { return }

        UIApplication.shared.setAlternateIconName(targetIconName) { [weak self] error in
            Task { @MainActor in
                if let error {
                    self?.errorMessage = "Couldn't change the app icon: \(error.localizedDescription)"
                }
            }
        }
    }

    private static var systemUserInterfaceStyle: UIUserInterfaceStyle {
        let windowScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first
        return windowScene?.screen.traitCollection.userInterfaceStyle ?? .light
    }
}

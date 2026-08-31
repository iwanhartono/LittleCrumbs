import Foundation

/// Common shape for a simple "pick one of a few named options" Settings
/// preference, so the row-list UI can be shared across them.
protocol SettingsChoice: CaseIterable, Identifiable, Hashable where AllCases: RandomAccessCollection {
    var displayName: String { get }
}

extension AppIconPreference: SettingsChoice {}
extension AppThemePreference: SettingsChoice {}

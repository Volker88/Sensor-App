//
//  AppColorScheme.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 25.10.26.
//

import SwiftUI

/// The color theme the user picked in Settings. `system` follows the device's
/// Light/Dark Mode; `light` and `dark` override it for the whole app.
/// Persisted by raw value via `@AppStorage(storageKey)`, so never rename existing cases.
public enum AppColorScheme: String, CaseIterable, Identifiable, Sendable {
    /// `UserDefaults` key shared by the app root and the Settings picker.
    public static let storageKey = "appColorScheme"

    case system
    case light
    case dark

    public var id: Self { self }

    /// Value for `preferredColorScheme(_:)`; `nil` defers to the system setting.
    public var colorScheme: ColorScheme? {
        switch self {
            case .system:
                return nil
            case .light:
                return .light
            case .dark:
                return .dark
        }
    }

    public var localizedString: LocalizedStringKey {
        switch self {
            case .system:
                return LocalizedStringKey("System")
            case .light:
                return LocalizedStringKey("Light")
            case .dark:
                return LocalizedStringKey("Dark")
        }
    }
}

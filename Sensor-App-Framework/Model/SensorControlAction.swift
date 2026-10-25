//
//  SensorControlAction.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 24.10.26.
//

import SwiftUI

/// A sensor control button (start, pause, delete, record), shared by the iOS
/// `CustomControlsView` and the watch `SensorControls` so both use the same
/// SF Symbols and localized strings. Accessibility identifiers and layout stay
/// in each app target, since `UIIdentifiers` is defined per target.
public enum SensorControlAction: String, CaseIterable {
    case start
    case pause
    case delete
    case record

    public var systemImage: String {
        switch self {
            case .start:
                return "play"
            case .pause:
                return "pause"
            case .delete:
                return "trash"
            case .record:
                return "record.circle"
        }
    }

    public var localizedString: LocalizedStringKey {
        switch self {
            case .start:
                return LocalizedStringKey("Start")
            case .pause:
                return LocalizedStringKey("Pause")
            case .delete:
                return LocalizedStringKey("Delete")
            case .record:
                return LocalizedStringKey("Record")
        }
    }

    public var accessibilityHint: LocalizedStringKey {
        switch self {
            case .start:
                return LocalizedStringKey("Tap to start updates")
            case .pause:
                return LocalizedStringKey("Tap to pause updates")
            case .delete:
                return LocalizedStringKey("Tap to delete all values")
            case .record:
                return LocalizedStringKey("Tap to start recording")
        }
    }
}

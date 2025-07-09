//
//  Extension+CustomControlsView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 09.07.25.
//

import SwiftUI

extension CustomControlsView {
    enum ButtonType: String, CaseIterable {
        case start
        case pause
        case delete

        var systemImage: String {
            switch self {
                case .start:
                    return "play"
                case .pause:
                    return "pause"
                case .delete:
                    return "trash"
            }
        }

        var localizedString: LocalizedStringKey {
            switch self {
                case .start:
                    return LocalizedStringKey("Start")
                case .pause:
                    return LocalizedStringKey("Pause")
                case .delete:
                    return LocalizedStringKey("Delete")
            }
        }

        var accessibilityHint: LocalizedStringKey {
            switch self {
                case .start:
                    return LocalizedStringKey("Tap to start updates")
                case .pause:
                    return LocalizedStringKey("Tap to pause updates")
                case .delete:
                    return LocalizedStringKey("Tap to delete all values")
            }
        }

        var accessibilityIdentifier: String {
            switch self {
                case .start:
                    return UIIdentifiers.CustomControlsView.playButton
                case .pause:
                    return UIIdentifiers.CustomControlsView.pauseButton
                case .delete:
                    return UIIdentifiers.CustomControlsView.deleteButton
            }
        }

        func offset(expanded: Bool) -> CGSize {
            guard expanded else {
                return .zero
            }

            switch self {
                case .start:
                    return offset(atIndex: 0, expanded: expanded)
                case .pause:
                    return offset(atIndex: 1, expanded: expanded)
                case .delete:
                    return offset(atIndex: 2, expanded: expanded)
            }
        }

        private func offset(atIndex index: Int, expanded: Bool) -> CGSize {
            let radius: CGFloat = 100
            let startAngleDeg = -180.0
            let step = 90.0 / Double(Self.allCases.count - 1)

            let angleDeg = startAngleDeg + (Double(index) * step)
            let angleRad = angleDeg * .pi / 180

            let x = cos(angleRad) * radius
            let y = sin(angleRad) * radius

            return CGSize(width: x, height: y)
        }
    }
}

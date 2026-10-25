//
//  Extension+SensorControlAction.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 09.07.25.
//

import Sensor_App_Framework
import SwiftUI

extension SensorControlAction {
    var accessibilityIdentifier: String {
        switch self {
            case .start:
                return UIIdentifiers.CustomControlsView.playButton
            case .pause:
                return UIIdentifiers.CustomControlsView.pauseButton
            case .delete:
                return UIIdentifiers.CustomControlsView.deleteButton
            case .record:
                return UIIdentifiers.CustomControlsView.recordButton
        }
    }

    /// Position of the button in `CustomControlsView`'s radial menu.
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
            case .record:
                return offset(atIndex: 3, expanded: expanded)
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

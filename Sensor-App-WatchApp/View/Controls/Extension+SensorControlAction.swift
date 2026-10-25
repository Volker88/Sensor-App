//
//  Extension+SensorControlAction.swift
//  Sensor-App-WatchApp
//
//  Created by Volker Schmitt on 23.10.26.
//

import Sensor_App_Framework

extension SensorControlAction {
    var accessibilityIdentifier: String {
        switch self {
            case .start:
                return UIIdentifiers.SensorControls.playButton
            case .pause:
                return UIIdentifiers.SensorControls.pauseButton
            case .delete:
                return UIIdentifiers.SensorControls.deleteButton
            case .record:
                return UIIdentifiers.SensorControls.recordButton
        }
    }
}

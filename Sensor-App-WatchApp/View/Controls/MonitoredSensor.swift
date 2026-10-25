//
//  MonitoredSensor.swift
//  Sensor-App-WatchApp
//
//  Created by Volker Schmitt on 23.10.26.
//

import Foundation

/// The sensor a watch screen displays, so `SensorControls` knows which updates to toggle.
enum MonitoredSensor {
    case motion
    case altitude
    case location
}

//
//  AppState.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import Foundation

@Observable
class AppState {
    var path: [Route] = []
    var selectedScreen: Screen?
}

enum Screen: Hashable {
    case homeScreen
    case location
    case acceleration
    case gravity
    case gyroscope
    case magnetometer
    case attitude
    case altitude
    case settings
}

enum Route: Hashable {
    case location
    case accelerationList
    case altitudeList
    case attitudeList
    case gravityList
    case gyroscopeList
    case magnetometerList
}

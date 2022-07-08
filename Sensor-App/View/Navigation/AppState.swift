//
//  AppState.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import Foundation

class AppState: ObservableObject {
    @Published var path: [Route] = []
    @Published var selectedScreen: Screen?
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
}

enum Route: Hashable {
    case location
}

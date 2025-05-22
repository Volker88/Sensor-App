//
//  Route.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 22.05.25.
//

import SwiftUI

enum Route: Hashable {
    case location
    case accelerationList
    case altitudeList
    case attitudeList
    case gravityList
    case gyroscopeList
    case magnetometerList
}

extension Route: View {
    var body: some View {
        switch self {
            case .location:
                MapView()
            case .accelerationList:
                AccelerationList()
            case .altitudeList:
                AltitudeList()
            case .attitudeList:
                AttitudeList()
            case .gravityList:
                GravityList()
            case .gyroscopeList:
                GyroscopeList()
            case .magnetometerList:
                MagnetometerList()
        }
    }
}

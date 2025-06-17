//
//  PositionStack.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import SwiftUI

/// Position Routes
enum PositionStack: String, Hashable {
    case location
    case locationMap
    case altitude
    case altitudeLog
}

// MARK: - View Extension
extension PositionStack: View {
    var body: some View {
        switch self {
            case .location:
                LocationScreen()
            case .locationMap:
                MapView()
            case .altitude:
                AltitudeScreen()
            case .altitudeLog:
                AltitudeList()
        }
    }
}

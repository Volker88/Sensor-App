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

    /// The regular-layout tab this entry's screen lives under, regardless of how deep it's nested.
    var rootTab: RootTab {
        switch self {
            case .location, .locationMap:
                .location
            case .altitude, .altitudeLog:
                .altitude
        }
    }
}

// MARK: - View Extension
extension PositionStack: View {
    var body: some View {
        switch self {
            case .location:
                LocationScreen()
            case .locationMap:
                MapScreen()
            case .altitude:
                AltitudeScreen()
            case .altitudeLog:
                AltitudeList()
        }
    }
}

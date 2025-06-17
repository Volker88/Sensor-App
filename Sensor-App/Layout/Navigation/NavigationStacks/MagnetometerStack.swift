//
//  MagnetometerStack.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import SwiftUI

/// Magnetometer Routes
enum MagnetometerStack: String, Hashable {
    case magnetometerLog
}

// MARK: - View Extension
extension MagnetometerStack: View {
    var body: some View {
        switch self {
            case .magnetometerLog:
                MagnetometerList()
        }
    }
}

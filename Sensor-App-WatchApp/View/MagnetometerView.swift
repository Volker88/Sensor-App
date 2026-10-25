//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct MagnetometerView: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        List {
            Group {
                Text("X-Axis: \(motionManager.motion?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT")
                Text("Y-Axis: \(motionManager.motion?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT")
                Text("Z-Axis: \(motionManager.motion?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT")
            }
            .accessibilityAddTraits(.updatesFrequently)
            .accessibilityRemoveTraits(.isStaticText)
        }
        .navigationTitle("Magnetometer")
        .font(.footnote)
        .sensorScreen(.motion)
    }
}

// MARK: - Preview
#Preview("MagnetometerView - English") {
    MagnetometerView()
}

#Preview("MagnetometerView - German") {
    MagnetometerView()
        .previewLocalization(.german)
}

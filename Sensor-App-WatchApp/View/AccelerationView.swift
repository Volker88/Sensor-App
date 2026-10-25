//
//  AccelerationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct AccelerationView: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        List {
            Group {
                Text("X-Axis: \(motionManager.motion?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2")
                Text("Y-Axis: \(motionManager.motion?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2")
                Text("Z-Axis: \(motionManager.motion?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2")
            }
            .accessibilityAddTraits(.updatesFrequently)
            .accessibilityRemoveTraits(.isStaticText)
        }
        .navigationTitle("Acceleration")
        .font(.footnote)
        .sensorScreen(.motion)
    }
}

// MARK: - Preview
#Preview("AccelerationView - English") {
    AccelerationView()
}

#Preview("AccelerationView - German") {
    AccelerationView()
        .previewLocalization(.german)
}

//
//  GyroscopeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct GyroscopeView: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        List {
            Group {
                Text("X-Axis: \(motionManager.motion?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s")
                Text("Y-Axis: \(motionManager.motion?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s")
                Text("Z-Axis: \(motionManager.motion?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s")
            }
            .accessibilityAddTraits(.updatesFrequently)
            .accessibilityRemoveTraits(.isStaticText)
        }
        .navigationTitle("Gyroscope")
        .font(.footnote)
        .sensorScreen(.motion)
    }
}

// MARK: - Preview
#Preview("GyroscopeView - English") {
    GyroscopeView()
}

#Preview("GyroscopeView - German") {
    GyroscopeView()
        .previewLocalization(.german)
}

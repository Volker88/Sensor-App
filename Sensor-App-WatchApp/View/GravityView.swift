//
//  GravityView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct GravityView: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        List {
            Group {
                Text("X-Axis: \(motionManager.motion?.gravityXAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)")
                Text("Y-Axis: \(motionManager.motion?.gravityYAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)")
                Text("Z-Axis: \(motionManager.motion?.gravityZAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)")
            }
            .accessibilityAddTraits(.updatesFrequently)
            .accessibilityRemoveTraits(.isStaticText)
        }
        .navigationTitle("Gravity")
        .font(.footnote)
        .sensorScreen(.motion)
    }
}

// MARK: - Preview
#Preview("GravityView - English") {
    GravityView()
}

#Preview("GravityView - German") {
    GravityView()
        .previewLocalization(.german)
}

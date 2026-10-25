//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct AttitudeView: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        List {
            Group {
                Text("Roll: \((motionManager.motion?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                Text("Pitch: \((motionManager.motion?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                Text("Yaw: \((motionManager.motion?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                Text("Heading: \(motionManager.motion?.attitudeHeading ?? 0.0, specifier: "%.5f")°")
            }
            .accessibilityAddTraits(.updatesFrequently)
            .accessibilityRemoveTraits(.isStaticText)
        }
        .navigationTitle("Attitude")
        .font(.footnote)
        .sensorScreen(.motion)
    }
}

// MARK: - Preview
#Preview("AttitudeView - English") {
    AccelerationView()
}

#Preview("AttitudeView - German") {
    AccelerationView()
        .previewLocalization(.german)
}

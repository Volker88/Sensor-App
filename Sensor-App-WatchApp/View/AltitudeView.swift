//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct AltitudeView: View {

    @Environment(MotionManager.self) private var motionManager

    // MARK: - Body
    var body: some View {
        List {
            Group {
                Text(
                    "Pressure: \(motionManager.altitude?.calculatedPressure ?? 0.0, specifier: "%.5f") \(motionManager.altitude?.pressureUnit ?? "")"
                )
                Text(
                    "Altitude Change: \(motionManager.altitude?.calculatedAltitude ?? 0.0, specifier: "%.5f") \(motionManager.altitude?.altitudeUnit ?? "")"
                )
            }
            .accessibilityAddTraits(.updatesFrequently)
            .accessibilityRemoveTraits(.isStaticText)
        }
        .navigationTitle("Altitude")
        .font(.footnote)
        .sensorScreen(.altitude)
    }
}

// MARK: - Preview
#Preview("AltitudeView - English") {
    AltitudeView()
}

#Preview("AltitudeView - German") {
    AltitudeView()
        .previewLocalization(.german)
}

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

    @Environment(SettingsManager.self) private var settingsManager
    @Environment(MotionManager.self) private var motionManager

    @State private var frequency = 1.0  // Default Frequency

    // MARK: - Body
    var body: some View {
        List {
            Text(
                "X-Axis: \(motionManager.motion?.gravityXAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)",
                comment: "GravityView - X-Axis (watchOS)")
            Text(
                "Y-Axis: \(motionManager.motion?.gravityYAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)",
                comment: "GravityView - Y-Axis (watchOS)")
            Text(
                "Z-Axis: \(motionManager.motion?.gravityZAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)",
                comment: "GravityView - Z-Axis (watchOS)")
        }
        .navigationTitle(Text("Gravity", comment: "NavigationBar Title - Gravity sensor screen"))
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    // MARK: - Methods
    func onAppear() {
        frequency = settingsManager.fetchUserSettings().frequencySetting
        motionManager.sensorUpdateInterval = frequency

        // Start updating motion
        motionManager.sensorUpdateInterval = frequency
        motionManager.startMotionUpdates()
    }

    func onDisappear() {
        motionManager.startMotionUpdates()
        motionManager.resetMotionUpdates()
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

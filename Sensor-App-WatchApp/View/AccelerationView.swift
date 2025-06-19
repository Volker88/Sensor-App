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

    @Environment(SettingsManager.self) private var settingsManager
    @Environment(MotionManager.self) private var motionManager

    @State private var frequency = 1.0  // Default Frequency

    // MARK: - Body
    var body: some View {
        List {
            Text("X-Axis: \(motionManager.motion?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2")
            Text("Y-Axis: \(motionManager.motion?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2")
            Text("Z-Axis: \(motionManager.motion?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2")
        }
        .navigationTitle("Acceleration")
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
        motionManager.stopMotionUpdates()
        motionManager.resetMotionUpdates()
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

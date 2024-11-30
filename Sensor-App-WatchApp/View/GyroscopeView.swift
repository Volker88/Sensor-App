//
//  GyroscopeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct GyroscopeView: View {

    @Environment(SettingsManager.self) private var settingsManager
    @Environment(MotionManager.self) private var motionManager

    @State private var frequency = 1.0  // Default Frequency

    // MARK: - Body
    var body: some View {
        List {
            Text(
                "X-Axis: \(motionManager.motion?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s",
                comment: "GyroscopeView - X-Axis (watchOS)")
            Text(
                "Y-Axis: \(motionManager.motion?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s",
                comment: "GyroscopeView - Y-Axis (watchOS)")
            Text(
                "Z-Axis: \(motionManager.motion?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s",
                comment: "GyroscopeView - Z-Axis (watchOS)")
        }
        .navigationTitle(Text("Gyroscope", comment: "NavigationBar Title - Gyroscope sensor screen"))
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
#Preview("GyroscopeView - English") {
    GyroscopeView()
}

#Preview("GyroscopeView - German") {
    GyroscopeView()
        .previewLocalization(.german)
}

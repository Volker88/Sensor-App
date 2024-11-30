//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct MagnetometerView: View {

    @Environment(SettingsManager.self) private var settingsManager
    @Environment(MotionManager.self) private var motionManager

    @State private var frequency = 1.0  // Default Frequency

    // MARK: - Body
    var body: some View {
        List {
            Text(
                "X-Axis: \(motionManager.motion?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT",
                comment: "MagnetometerView - X-Axis (watchOS)")
            Text(
                "Y-Axis: \(motionManager.motion?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT",
                comment: "MagnetometerView - Y-Axis (watchOS)")
            Text(
                "Z-Axis: \(motionManager.motion?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT",
                comment: "MagnetometerView - Z-Axis (watchOS)")
        }
        .navigationTitle(Text("Magnetometer", comment: "NavigationBar Title - Magnetometer sensor screen"))
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
#Preview("MagnetometerView - English") {
    MagnetometerView()
}

#Preview("MagnetometerView - German") {
    MagnetometerView()
        .previewLocalization(.german)
}

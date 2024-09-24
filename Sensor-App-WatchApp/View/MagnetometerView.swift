//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct MagnetometerView: View {

    @Environment(SettingsManager.self) var settingsManager
    @Environment(MotionManager.self) var motionManager

    @State private var frequency = 1.0 // Default Frequency

    init() {
        frequency = settingsManager.fetchUserSettings().frequencySetting
        motionManager.sensorUpdateInterval = frequency
    }

    var body: some View {
        List {
            Text("X-Axis: \(motionManager.motion?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - X-Axis (watchOS)")
            Text("Y-Axis: \(motionManager.motion?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - Y-Axis (watchOS)")
            Text("Z-Axis: \(motionManager.motion?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - Z-Axis (watchOS)")
        }
        .navigationTitle(NSLocalizedString("Magnetometer", comment: "MagnetometerView - NavigationBar Title (watchOS)"))
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    func onAppear() {
        // Start updating motion
        motionManager.sensorUpdateInterval = frequency
        motionManager.startMotionUpdates()
    }

    func onDisappear() {
        motionManager.stopMotionUpdates()
        motionManager.resetMotionUpdates()
    }
}

struct MagnetometerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MagnetometerView().previewDevice("Apple Watch Series 3 - 38mm")
            MagnetometerView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

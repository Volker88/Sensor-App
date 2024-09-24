//
//  GyroscopeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct GyroscopeView: View {

    @Environment(SettingsManager.self) var settingsManager
    @Environment(CalculationManager.self) var calculationManager
    @Environment(MotionManager.self) var motionManager
    @State private var frequency = 1.0 // Default Frequency

    init() {
        frequency = settingsManager.fetchUserSettings().frequencySetting
        motionManager.sensorUpdateInterval = frequency
    }

    var body: some View {
        List {
            Text("X-Axis: \(motionManager.motion?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - X-Axis (watchOS)")
            Text("Y-Axis: \(motionManager.motion?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - Y-Axis (watchOS)")
            Text("Z-Axis: \(motionManager.motion?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - Z-Axis (watchOS)")
        }
        .navigationTitle(NSLocalizedString("Gyroscope", comment: "GyroscopeView - NavigationBar Title (watchOS)"))
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

struct GyroscopeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GyroscopeView().previewDevice("Apple Watch Series 3 - 38mm")
            GyroscopeView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

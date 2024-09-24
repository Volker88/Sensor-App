//
//  AccelerationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AccelerationView: View {
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
            Text("X-Axis: \(motionManager.motion?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - X-Axis (watchOS)")
            Text("Y-Axis: \(motionManager.motion?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Y-Axis (watchOS)")
            Text("Z-Axis: \(motionManager.motion?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Z-Axis (watchOS)")
        }
        .navigationTitle(NSLocalizedString("Acceleration", comment: "AccelerationView - NavigationBar Title (watchOS)"))
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

struct AccelerationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccelerationView().previewDevice("Apple Watch Series 3 - 38mm")
            AccelerationView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

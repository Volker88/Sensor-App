//
//  GravityView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct GravityView: View {
    @Environment(SettingsManager.self) var settingsManager
    @Environment(MotionManager.self) var motionManager
    @State private var frequency = 1.0 // Default Frequency

    init() {
        frequency = settingsManager.fetchUserSettings().frequencySetting
        motionManager.sensorUpdateInterval = frequency
    }

    var body: some View {
        List {
            Text("X-Axis: \(motionManager.motion?.gravityXAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - X-Axis (watchOS)")
            Text("Y-Axis: \(motionManager.motion?.gravityYAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Y-Axis (watchOS)")
            Text("Z-Axis: \(motionManager.motion?.gravityZAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Z-Axis (watchOS)")
        }
        .navigationTitle(NSLocalizedString("Gravity", comment: "GravityView - NavigationBar Title (watchOS)"))
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
        motionManager.startMotionUpdates()
        motionManager.resetMotionUpdates()
    }
}

struct GravityView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GravityView().previewDevice("Apple Watch Series 3 - 38mm")
            GravityView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

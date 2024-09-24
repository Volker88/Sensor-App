//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AttitudeView: View {

    @Environment(SettingsManager.self) var settingsManager
    @Environment(CalculationManager.self) var calculationManager
    @Environment(MotionManager.self) var motionManager

    @State private var frequency = 1.0 // Default Frequency

    init() {
        frequency = settingsManager.fetchUserSettings().frequencySetting
    }

    var body: some View {
        List {
            Text("Roll: \((motionManager.motion?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Roll (watchOS)")
            Text("Pitch: \((motionManager.motion?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Pitch (watchOS)")
            Text("Yaw: \((motionManager.motion?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Yaw (watchOS)")
            Text("Heading: \(motionManager.motion?.attitudeHeading ?? 0.0, specifier: "%.5f")°", comment: "AttitudeView - Heading (watchOS)")
        }
        .navigationTitle(NSLocalizedString("Attitude", comment: "AttitudeView - NavigationBar Title (watchOS)"))
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    func onAppear() {
        // Start updating motion
        motionManager.startMotionUpdates()
        motionManager.sensorUpdateInterval = frequency
    }

    func onDisappear() {
        motionManager.stopMotionUpdates()
        motionManager.resetMotionUpdates()
    }
}

struct AttitudeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AttitudeView().previewDevice("Apple Watch Series 3 - 38mm")
            AttitudeView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

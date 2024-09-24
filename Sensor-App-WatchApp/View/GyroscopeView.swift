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

    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0 // Default Frequency

    init() {
        frequency = settingsManager.fetchUserSettings().frequencySetting
        motionVM.sensorUpdateInterval = frequency
    }

    var body: some View {
        List {
            Text("X-Axis: \(motionVM.coreMotionArray.last?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - X-Axis (watchOS)")
            Text("Y-Axis: \(motionVM.coreMotionArray.last?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - Y-Axis (watchOS)")
            Text("Z-Axis: \(motionVM.coreMotionArray.last?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - Z-Axis (watchOS)")
        }
        .navigationTitle(NSLocalizedString("Gyroscope", comment: "GyroscopeView - NavigationBar Title (watchOS)"))
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
    }

    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
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

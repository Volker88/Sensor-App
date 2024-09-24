//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AltitudeView: View {
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
            Text("Pressure: \(calculationManager.calculatePressure(pressure: motionManager.altitude?.pressureValue ?? 0.0, to: settingsManager.fetchUserSettings().pressureSetting), specifier: "%.5f") \(settingsManager.fetchUserSettings().pressureSetting)", comment: "AltitudeView - Pressure (watchOS)")
            Text("Altitude change: \(calculationManager.calculateHeight(height: motionManager.altitude?.relativeAltitudeValue ?? 0.0, to: settingsManager.fetchUserSettings().altitudeHeightSetting), specifier: "%.5f") \(settingsManager.fetchUserSettings().altitudeHeightSetting)", comment: "AltitudeView - Altitude Change (watchOS)")
        }
        .navigationTitle(NSLocalizedString("Altitude", comment: "AltitudeView - NavigationBar Title (watchOS)"))
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    func onAppear() {
        // Start updating motion
        motionManager.startAltitudeUpdates()
    }

    func onDisappear() {
        motionManager.stopMotionUpdates()
        motionManager.resetMotionUpdates()
    }
}

struct AltitudeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AltitudeView().previewDevice("Apple Watch Series 3 - 38mm")
            AltitudeView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

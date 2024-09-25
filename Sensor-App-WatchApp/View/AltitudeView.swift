//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AltitudeView: View {

    @Environment(SettingsManager.self) private var settingsManager
    @Environment(CalculationManager.self) private var calculationManager
    @Environment(MotionManager.self) private var motionManager

    @State private var frequency = 1.0 // Default Frequency

    // MARK: - Body
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

    // MARK: - Methods
    func onAppear() {
        frequency = settingsManager.fetchUserSettings().frequencySetting
        motionManager.sensorUpdateInterval = frequency

        // Start updating motion
        motionManager.startAltitudeUpdates()
    }

    func onDisappear() {
        motionManager.stopMotionUpdates()
        motionManager.resetMotionUpdates()
    }
}

// MARK: - Preview
#Preview {
    AltitudeView()
        .previewNavigationStackWrapper()
}

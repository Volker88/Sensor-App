//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AltitudeView: View {
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()

    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0 // Default Frequency

    init() {
        frequency = settings.fetchUserSettings().frequencySetting
        motionVM.sensorUpdateInterval = frequency
    }

    var body: some View {
        List {
            // swiftlint:disable line_length
            Text("Pressure: \(calculationAPI.calculatePressure(pressure: motionVM.altitudeArray.last?.pressureValue ?? 0.0, to: settings.fetchUserSettings().pressureSetting), specifier: "%.5f") \(settings.fetchUserSettings().pressureSetting)", comment: "AltitudeView - Pressure (watchOS)")
            Text("Altitude change: \(calculationAPI.calculateHeight(height: motionVM.altitudeArray.last?.relativeAltitudeValue ?? 0.0, to: settings.fetchUserSettings().altitudeHeightSetting), specifier: "%.5f") \(settings.fetchUserSettings().altitudeHeightSetting)", comment: "AltitudeView - Altitude Change (watchOS)")
            // swiftlint:enable line_length
        }
        .navigationBarTitle("\(NSLocalizedString("Altitude", comment: "AltitudeView - NavigationBar Title (watchOS)"))")
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    func onAppear() {
        // Start updating motion
        motionVM.altitudeUpdateStart()
    }

    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
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

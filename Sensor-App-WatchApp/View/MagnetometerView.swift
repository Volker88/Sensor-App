//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct MagnetometerView: View {
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
            Text("X-Axis: \(motionVM.coreMotionArray.last?.magnetometerXAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - X-Axis (watchOS)")
            Text("Y-Axis: \(motionVM.coreMotionArray.last?.magnetometerYAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - Y-Axis (watchOS)")
            Text("Z-Axis: \(motionVM.coreMotionArray.last?.magnetometerZAxis ?? 0.0, specifier: "%.5f") µT", comment: "MagnetometerView - Z-Axis (watchOS)")
            // swiftlint:enable line_length
        }
        .navigationTitle(NSLocalizedString("Magnetometer", comment: "MagnetometerView - NavigationBar Title (watchOS)"))
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

struct MagnetometerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MagnetometerView().previewDevice("Apple Watch Series 3 - 38mm")
            MagnetometerView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

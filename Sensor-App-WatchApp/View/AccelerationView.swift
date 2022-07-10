//
//  AccelerationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AccelerationView: View {
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
            Text("X-Axis: \(motionVM.coreMotionArray.last?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - X-Axis (watchOS)")
            Text("Y-Axis: \(motionVM.coreMotionArray.last?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Y-Axis (watchOS)")
            Text("Z-Axis: \(motionVM.coreMotionArray.last?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Z-Axis (watchOS)")
            // swiftlint:enable line_length
        }
        .navigationBarTitle("\(NSLocalizedString("Acceleration", comment: "AccelerationView - NavigationBar Title (watchOS)"))") // swiftlint:disable:this line_length
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

struct AccelerationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccelerationView().previewDevice("Apple Watch Series 3 - 38mm")
            AccelerationView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

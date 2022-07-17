//
//  GravityView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct GravityView: View {
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
            Text("X-Axis: \(motionVM.coreMotionArray.last?.gravityXAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - X-Axis (watchOS)")
            Text("Y-Axis: \(motionVM.coreMotionArray.last?.gravityYAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Y-Axis (watchOS)")
            Text("Z-Axis: \(motionVM.coreMotionArray.last?.gravityZAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Z-Axis (watchOS)")
            // swiftlint:enable line_length
        }
        .navigationTitle(NSLocalizedString("Gravity", comment: "GravityView - NavigationBar Title (watchOS)"))
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
    }

    func onDisappear() {
        motionVM.motionUpdateStart()
        motionVM.coreMotionArray.removeAll()
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

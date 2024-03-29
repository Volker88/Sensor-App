//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct AttitudeView: View {
    let settings = SettingsAPI()

    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0 // Default Frequency

    init() {
        frequency = settings.fetchUserSettings().frequencySetting
    }

    var body: some View {
        List {
            // swiftlint:disable line_length
            Text("Roll: \((motionVM.coreMotionArray.last?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Roll (watchOS)")
            Text("Pitch: \((motionVM.coreMotionArray.last?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Pitch (watchOS)")
            Text("Yaw: \((motionVM.coreMotionArray.last?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°", comment: "AttitudeView - Yaw (watchOS)")
            Text("Heading: \(motionVM.coreMotionArray.last?.attitudeHeading ?? 0.0, specifier: "%.5f")°", comment: "AttitudeView - Heading (watchOS)")
            // swiftlint:enable line_length
        }
        .navigationTitle(NSLocalizedString("Attitude", comment: "AttitudeView - NavigationBar Title (watchOS)"))
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
        motionVM.sensorUpdateInterval = frequency
    }

    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
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

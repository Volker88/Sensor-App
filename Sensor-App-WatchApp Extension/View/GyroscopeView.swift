//
//  GyroscopeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import SwiftUI

// MARK: - Struct
struct GyroscopeView: View {

    // MARK: - Initialize Classes
    let settings = SettingsAPI()

    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0 // Default Frequency

    // MARK: - Define Constants / Variables

    // MARK: - Initializer
    init() {
        frequency = settings.fetchUserSettings().frequencySetting
        motionVM.sensorUpdateInterval = frequency
    }

    // MARK: - Methods

    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
    }

    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
    }

    // MARK: - Body - View
    var body: some View {

        // MARK: - Return View
        return List {
            //swiftlint:disable line_length
            Text("X-Axis: \(motionVM.coreMotionArray.last?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - X-Axis (watchOS)")
            Text("Y-Axis: \(motionVM.coreMotionArray.last?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - Y-Axis (watchOS)")
            Text("Z-Axis: \(motionVM.coreMotionArray.last?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyroscopeView - Z-Axis (watchOS)")
            //swiftlint:enable line_length
        }
        .navigationBarTitle("\(NSLocalizedString("Gyroscope", comment: "GyroscopeView - NavigationBar Title (watchOS)"))") //swiftlint:disable:this line_length
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
}

// MARK: - Preview
struct GyroscopeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GyroscopeView().previewDevice("Apple Watch Series 3 - 38mm")
            GyroscopeView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

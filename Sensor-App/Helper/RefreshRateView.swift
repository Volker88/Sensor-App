//
//  RefreshRateView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct RefreshRateView: View {
    @ObservedObject var motionVM: CoreMotionViewModel

    let settings = SettingsAPI()
    let show: String

    var body: some View {
        if show == "header" {
            HStack {
                Text("\(NSLocalizedString("Frequency:", comment: "RefreshRateView - Frequency")) \(Double(motionVM.sensorUpdateInterval), specifier: "%.1f") Hz", comment: "RefreshRateView - Refresh Rate") // swiftlint:disable:this line_length
                Stepper("", value: $motionVM.sensorUpdateInterval, in: 1...10, step: 0.1)
            }
        } else if show == "slider" {
            HStack {
                Text("1", comment: "RefreshRateView - Label 1")

                Slider(value: $motionVM.sensorUpdateInterval, in: 1...10, step: 0.1) { _ in
                    updateSlider()
                }
                .accessibility(label: Text("Refresh Rate", comment: "RefreshRateView - Slider"))
                .accessibility(value: Text("\(motionVM.sensorUpdateInterval, specifier: "%.1f") per Second", comment: "RefreshRateView - Value")) // swiftlint:disable:this line_length
                .accessibility(identifier: "Frequency Slider")
                Text("10", comment: "RefreshRateView - Label 10")
            }
        }
    }

    func updateSlider() {
        var userSettings = settings.fetchUserSettings()
        userSettings.frequencySetting = motionVM.sensorUpdateInterval
        settings.saveUserSettings(userSettings: userSettings)
    }
}

struct RefreshRateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RefreshRateView(motionVM: CoreMotionViewModel(), show: "header")
            RefreshRateView(motionVM: CoreMotionViewModel(), show: "slider")
        }
        .previewLayout(.sizeThatFits)
    }
}

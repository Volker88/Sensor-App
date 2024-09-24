//
//  RefreshRateView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct RefreshRateView: View {
    @Environment(SettingsManager.self) var settingsManager

    @ObservedObject var motionVM: CoreMotionViewModel

    let show: String

    var body: some View {
        if show == "header" {
            HStack {
                Text("\(NSLocalizedString("Frequency:", comment: "RefreshRateView - Frequency")) \(Double(motionVM.sensorUpdateInterval), specifier: "%.1f") Hz", comment: "RefreshRateView - Refresh Rate")
                Stepper("", value: $motionVM.sensorUpdateInterval, in: 0.1...5, step: 0.1, onEditingChanged: { _ in
                    updateSlider()
                })
            }
        } else if show == "slider" {
            HStack {
                Text("0.1", comment: "RefreshRateView - Label 1")

                Slider(value: $motionVM.sensorUpdateInterval, in: 0.1...5, step: 0.1) { _ in
                    updateSlider()
                }
                .accessibility(label: Text("Refresh Rate", comment: "RefreshRateView - Slider"))
                .accessibility(value: Text("\(motionVM.sensorUpdateInterval, specifier: "%.1f") per Second", comment: "RefreshRateView - Value"))
                .accessibility(identifier: "Frequency Slider")
                Text("5", comment: "RefreshRateView - Label 10")
            }
        }

    }

    func updateSlider() {
        var userSettings = settingsManager.fetchUserSettings()
        userSettings.frequencySetting = motionVM.sensorUpdateInterval
        settingsManager.saveUserSettings(userSettings: userSettings)
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

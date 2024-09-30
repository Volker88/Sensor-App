//
//  RefreshRateView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct RefreshRateView: View {

    @Environment(SettingsManager.self) private var settingsManager
    @Environment(MotionManager.self) private var motionManager

    let show: String

    // MARK: - Body
    var body: some View {
        Group {
            if show == "header" {
                HStack {
                    Text("\(NSLocalizedString("Frequency:", comment: "RefreshRateView - Frequency")) \(Double(motionManager.sensorUpdateInterval), specifier: "%.1f") Hz", comment: "RefreshRateView - Refresh Rate")
                    Stepper("", value: Bindable(motionManager).sensorUpdateInterval, in: 0.1...50, step: 0.1,
                            onEditingChanged: { _ in
                        updateSlider()
                    })
                }
            } else if show == "slider" {
                HStack {
                    Text("0.1", comment: "RefreshRateView - Label 1")

                    Slider(value: Bindable(motionManager).sensorUpdateInterval, in: 0.1...50.01, step: 0.1) { _ in
                        updateSlider()
                    }
                    .accessibility(label: Text("Refresh Rate", comment: "RefreshRateView - Slider"))
                    .accessibility(value: Text("\(motionManager.sensorUpdateInterval, specifier: "%.1f") per Second", comment: "RefreshRateView - Value"))
                    .accessibility(identifier: "Frequency Slider")
                    Text("50", comment: "RefreshRateView - Label 50")
                }
            }
        }
        .onAppear {
            motionManager.sensorUpdateInterval = settingsManager.fetchUserSettings().frequencySetting
        }
    }

    // MARK: - Methods
    func updateSlider() {
        var userSettings = settingsManager.fetchUserSettings()
        userSettings.frequencySetting = motionManager.sensorUpdateInterval
        settingsManager.saveUserSettings(userSettings: userSettings)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        RefreshRateView(show: "header")
        RefreshRateView(show: "slider")
    }
}

//
//  RefreshRateView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
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
                    Stepper(value: Bindable(motionManager).sensorUpdateInterval) { _ in
                        updateSlider()
                    } label: {
                        Text(
                            "Frequency: \(Double(motionManager.sensorUpdateInterval), specifier: "%.0f") Hz",
                            comment: "Frequency of Sensor Updates in Herz")
                    }
                }
            } else if show == "slider" {
                HStack {
                    Text("1")

                    Slider(value: Bindable(motionManager).sensorUpdateInterval, in: 1...50, step: 1) { _ in
                        updateSlider()
                    }
                    .accessibilityIdentifier(UIIdentifiers.RefreshRateView.refreshRateSlider)
                    .accessibilityLabel(
                        Text(
                            "Refresh Rate",
                            comment: "Slider to adjust Frequency of Sensor Updates in Herz")
                    )
                    .accessibilityLabel(
                        Text(
                            "\(motionManager.sensorUpdateInterval, specifier: "%.0f") per Second",
                            comment: "RefreshRateView - Value"))

                    Text("50")
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

#Preview(traits: .sizeThatFitsLayout, .navEmbedded) {
    Group {
        RefreshRateView(show: "header")
        RefreshRateView(show: "slider")
    }
}

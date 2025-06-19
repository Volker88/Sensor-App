//
//  SettingsView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct SettingsView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(SettingsManager.self) private var settingsManager

    @State private var refreshRate: Double = 1
    @State private var speedSetting = 0
    @State private var accuracySetting = 0
    @State private var pressureSetting = 0
    @State private var heightSetting = 0

    // MARK: - Body
    var body: some View {
        Form {
            Section(
                header:
                    Text("Location")
            ) {
                Picker("Speed Setting", selection: $speedSetting) {
                    ForEach(0..<settingsManager.GPSSpeedSettings.count, id: \.self) {
                        Text(settingsManager.GPSSpeedSettings[$0]).tag($0)
                    }
                }
                Picker("Accuracy", selection: $accuracySetting) {
                    ForEach(0..<settingsManager.GPSAccuracyOptions.count, id: \.self) {
                        Text(settingsManager.GPSAccuracyOptions[$0]).tag($0)
                    }
                }
            }
            Section(
                header:
                    Text("Altitude")
            ) {
                Picker("Pressure", selection: $pressureSetting) {
                    ForEach(0..<settingsManager.altitudePressure.count, id: \.self) {
                        Text(settingsManager.altitudePressure[$0]).tag($0)
                    }
                }
                Picker("Height", selection: $heightSetting) {
                    ForEach(0..<settingsManager.altitudeHeight.count, id: \.self) {
                        Text(settingsManager.altitudeHeight[$0]).tag($0)
                    }
                }
            }
            Section(
                header:
                    Text("Refresh Rate")
            ) {
                Text("Frequency: \(Int(refreshRate)) Hz")

                Slider(value: $refreshRate, in: 1...10, step: 1) { _ in

                }
            }
            Section {
                Button(action: {
                    discardChanges(dismiss: true)
                }) {
                    Text("Discard")
                }

                Button(action: {
                    saveSettings()
                }) {
                    Text("Save")
                }
            }
        }
        .navigationTitle("Settings")
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    // MARK: - Methods
    func saveSettings() {
        var userSettings = settingsManager.fetchUserSettings()
        userSettings.GPSSpeedSetting = settingsManager.GPSSpeedSettings[speedSetting]
        userSettings.GPSAccuracySetting = settingsManager.GPSAccuracyOptions[accuracySetting]
        userSettings.pressureSetting = settingsManager.altitudePressure[pressureSetting]
        userSettings.altitudeHeightSetting = settingsManager.altitudeHeight[heightSetting]
        userSettings.frequencySetting = refreshRate
        settingsManager.saveUserSettings(userSettings: userSettings)

        dismiss()
    }

    func discardChanges(dismiss: Bool) {
        speedSetting =
            settingsManager.GPSSpeedSettings.firstIndex(of: settingsManager.fetchUserSettings().GPSSpeedSetting) ?? 0
        accuracySetting =
            settingsManager.GPSAccuracyOptions.firstIndex(of: settingsManager.fetchUserSettings().GPSAccuracySetting)
            ?? 0
        pressureSetting =
            settingsManager.altitudePressure.firstIndex(of: settingsManager.fetchUserSettings().pressureSetting) ?? 0
        heightSetting =
            settingsManager.altitudeHeight.firstIndex(of: settingsManager.fetchUserSettings().altitudeHeightSetting)
            ?? 0
        refreshRate = settingsManager.fetchUserSettings().frequencySetting

        if dismiss == true {
            self.dismiss()
        }
    }

    func onAppear() {
        discardChanges(dismiss: false)
    }

    func onDisappear() {
        discardChanges(dismiss: false)
    }
}

// MARK: - Preview
#Preview("SettingsView - English") {
    SettingsView()
}

#Preview("SettingsView - German") {
    SettingsView()
        .previewLocalization(.german)
}

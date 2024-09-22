//
//  SettingsView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

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
            Section(header:
                        Text("Location", comment: "SettingsView - Location Section (watchOS)")
            ) {
                Picker(
                    selection: $speedSetting,
                    label: Text("Speed Setting", comment: "SettingsView - Speed Setting (watchOS)")
                ) {
                    ForEach(0 ..< settingsManager.GPSSpeedSettings.count, id: \.self) {
                        Text(settingsManager.GPSSpeedSettings[$0]).tag($0)
                    }
                }
                Picker(
                    selection: $accuracySetting,
                    label: Text("Accuracy", comment: "SettingsView - Accuracy (watchOS)")
                ) {
                    ForEach(0 ..< settingsManager.GPSAccuracyOptions.count, id: \.self) {
                        Text(settingsManager.GPSAccuracyOptions[$0]).tag($0)
                    }
                }
            }
            Section(header:
                        Text("Altitude", comment: "SettingsView - Altitude Section (watchOS)")
            ) {
                Picker(
                    selection: $pressureSetting,
                    label: Text("Pressure", comment: "SettingsView - Pressure (watchOS)")
                ) {
                    ForEach(0 ..< settingsManager.altitudePressure.count, id: \.self) {
                        Text(settingsManager.altitudePressure[$0]).tag($0)
                    }
                }
                Picker(
                    selection: $heightSetting,
                    label: Text("Height", comment: "SettingsView - Height (watchOS)")
                ) {
                    ForEach(0 ..< settingsManager.altitudeHeight.count, id: \.self) {
                        Text(settingsManager.altitudeHeight[$0]).tag($0)
                    }
                }
            }
            Section(header:
                        Text("Refresh Rate", comment: "SettingsView - Refresh Rate Section (watchOS)")
            ) {
                Text("Frequenz: \(Int(refreshRate)) Hz")

                Slider(value: $refreshRate, in: 1...10, step: 1) { _ in

                }
            }
            Section {
                Button(action: {
                    discardChanges(dismiss: true)
                }) {
                    Text("Discard", comment: "SettingsView - Discard (watchOS)")
                }

                Button(action: {
                    saveSettings()
                }) {
                    Text("Save", comment: "SettingsView - Save (watchOS)")
                }
            }
        }
        .navigationTitle(NSLocalizedString("Settings", comment: "SettingsView - NavigationBar Title (watchOS)"))
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
        // swiftlint:disable line_length
        speedSetting = settingsManager.GPSSpeedSettings.firstIndex(of: settingsManager.fetchUserSettings().GPSSpeedSetting) ?? 0
        accuracySetting = settingsManager.GPSAccuracyOptions.firstIndex(of: settingsManager.fetchUserSettings().GPSAccuracySetting) ?? 0
        pressureSetting = settingsManager.altitudePressure.firstIndex(of: settingsManager.fetchUserSettings().pressureSetting) ?? 0
        heightSetting = settingsManager.altitudeHeight.firstIndex(of: settingsManager.fetchUserSettings().altitudeHeightSetting) ?? 0
        refreshRate = settingsManager.fetchUserSettings().frequencySetting
        // swiftlint:enable line_length

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
#Preview {
    SettingsView()
        .previewNavigationStackWrapper()
}

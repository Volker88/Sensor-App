//
//  SettingsView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(SettingsManager.self) var settingsManager

    @State private var showingDiscardAlert = false
    @State private var showingSaveAlert = false
    @State var refreshRate: Double = 1
    @State var speedSetting = 0
    @State var accuracySetting = 0
    @State var pressureSetting = 0
    @State var heightSetting = 0

    init() {
        refreshRate = settingsManager.fetchUserSettings().frequencySetting
        speedSetting = settingsManager.GPSSpeedSettings.firstIndex(of: settingsManager.fetchUserSettings().GPSSpeedSetting) ?? 0
        accuracySetting = settingsManager.GPSAccuracyOptions.firstIndex(of: settingsManager.fetchUserSettings().GPSAccuracySetting) ?? 0 // swiftlint:disable:this line_length
        pressureSetting = settingsManager.altitudePressure.firstIndex(of: settingsManager.fetchUserSettings().pressureSetting) ?? 0
        heightSetting = settingsManager.altitudeHeight.firstIndex(of: settingsManager.fetchUserSettings().altitudeHeightSetting) ?? 0
    }

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
                Text("\(NSLocalizedString("Frequency:", comment: "SettingsView - Frequency (watchOS)")) \(Int(refreshRate)) Hz", comment: "SettingsView - Frequency (watchOS)")
                Slider(value: $refreshRate, in: 1...10, step: 1) { _ in

                }
            }
            Section {
                Button(action: {
                    discardChanges(showNotification: true)
                }) {
                    Text("Discard", comment: "SettingsView - Save (watchOS)")
                }
                .alert(isPresented: $showingDiscardAlert) {
                    Alert(title: Text("Discarded Changes", comment: "SettingsView - Discarded Changes (watchOS)"))
                }
                Button(action: {
                    saveSettings()
                }) {
                    Text("Save")
                }.alert(isPresented: $showingSaveAlert) {
                    Alert(title: Text("Saved Changes", comment: "SettingsView - Saved Changes (watchOS)"))
                }
            }
        }
        .navigationTitle(NSLocalizedString("Settings", comment: "SettingsView - NavigationBar Title (watchOS)"))
        .font(.footnote)
        .onAppear(perform: onDisappear)
    }

    func saveSettings() {
        var userSettings = settingsManager.fetchUserSettings()
        userSettings.GPSSpeedSetting = settingsManager.GPSSpeedSettings[speedSetting]
        userSettings.GPSAccuracySetting = settingsManager.GPSAccuracyOptions[accuracySetting]
        userSettings.pressureSetting = settingsManager.altitudePressure[pressureSetting]
        userSettings.altitudeHeightSetting = settingsManager.altitudeHeight[heightSetting]
        userSettings.frequencySetting = refreshRate
        settingsManager.saveUserSettings(userSettings: userSettings)

        showingSaveAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            showingSaveAlert = false
        })
    }

    func discardChanges(showNotification: Bool) {
        speedSetting = settingsManager.GPSSpeedSettings.firstIndex(of: settingsManager.fetchUserSettings().GPSSpeedSetting) ?? 0
        accuracySetting = settingsManager.GPSAccuracyOptions.firstIndex(of: settingsManager.fetchUserSettings().GPSAccuracySetting) ?? 0 // swiftlint:disable:this line_length
        pressureSetting = settingsManager.altitudePressure.firstIndex(of: settingsManager.fetchUserSettings().pressureSetting) ?? 0
        heightSetting = settingsManager.altitudeHeight.firstIndex(of: settingsManager.fetchUserSettings().altitudeHeightSetting) ?? 0
        refreshRate = settingsManager.fetchUserSettings().frequencySetting

        if showNotification == true {
            showingDiscardAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                showingDiscardAlert = false
            })
        }
    }

    func onDisappear() {
        discardChanges(showNotification: false)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView().previewDevice("Apple Watch Series 3 - 38mm")
            SettingsView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

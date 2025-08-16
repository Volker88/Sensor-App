//
//  SettingsScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct SettingsScreen: View {

    @Environment(\.showNotification) var showNotification
    @Environment(SettingsManager.self) private var settingsManager

    @AppStorage("showReleaseNotes") private var showReleaseNotes = true

    // MARK: - Body
    var body: some View {
        Form {
            Section("General") {
                Toggle("Show Release Notes", isOn: $showReleaseNotes)
            }

            Section(
                header:
                    Text("App Icon")
            ) {
                HStack {
                    Spacer()

                    ForEach(0..<settingsManager.iconNames.count, id: \.self) { index in
                        Image(uiImage: UIImage(named: "\(settingsManager.iconNames[index])") ?? UIImage())
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .conditionalOverlay(visible: settingsManager.currentAppIconIndex == index)
                            .onTapGesture {
                                settingsManager.changeIcon(value: index)
                            }
                    }

                    Spacer()
                }
            }
            Section(
                header:
                    Text("Location")
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.locationHeader)
            ) {
                Picker("Speed Setting", selection: Bindable(settingsManager).speedSetting) {
                    ForEach(0..<settingsManager.GPSSpeedSettings.count, id: \.self) {
                        Text(settingsManager.GPSSpeedSettings[$0]).tag($0)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.speedPicker)

                Picker("Accuracy", selection: Bindable(settingsManager).accuracySetting) {
                    ForEach(0..<settingsManager.GPSAccuracyOptions.count, id: \.self) {
                        Text(settingsManager.GPSAccuracyOptions[$0]).tag($0)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.accuracyPicker)
            }

            Section(
                header:
                    Text("Altitude")
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.altitudeHeader)
            ) {
                Picker("Pressure", selection: Bindable(settingsManager).pressureSetting) {
                    ForEach(0..<settingsManager.altitudePressure.count, id: \.self) {
                        Text(settingsManager.altitudePressure[$0]).tag($0)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.pressurePicker)

                Picker("Height", selection: Bindable(settingsManager).heightSetting) {
                    ForEach(0..<settingsManager.altitudeHeight.count, id: \.self) {
                        Text(settingsManager.altitudeHeight[$0]).tag($0)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.altitudePicker)
            }

            Section(
                header:
                    Text("Graph")
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.graphHeader)
            ) {
                Stepper(value: Bindable(settingsManager).userSettings.graphMaxPoints, in: 1...1000, step: 1) {
                    Text("Max Points: \(settingsManager.userSettings.graphMaxPoints, specifier: "%.0f")")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.maxPointsStepper)

                HStack {
                    Text("1")

                    Slider(
                        value: Bindable(settingsManager).userSettings.graphMaxPoints,
                        in: 1...1000,
                        step: 1
                    )
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.maxPointsSlider)

                    Text("1000")
                }
            }

            Section {
                Button(action: {
                    saveSettings()
                }) {
                    Text("Save")
                        .accessibilityIdentifier(UIIdentifiers.SettingScreen.saveButton)
                }

                Button(action: {
                    discardChanges(showNotification: true)
                }) {
                    Text("Discard")
                        .accessibilityIdentifier(UIIdentifiers.SettingScreen.discardButton)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .accessibilityIdentifier(UIIdentifiers.SettingScreen.collectionView)
        .navigationTitle("Settings")
        .onAppear {
            discardChanges(showNotification: false)
            settingsManager.fetchCurrentAppIcon()
        }
    }

    // MARK: - Methods
    func saveSettings() {
        settingsManager.saveSettings()

        showNotification("Successfully Saved")
    }

    func discardChanges(showNotification: Bool) {
        settingsManager.discardChanges()

        // Show Notification
        if showNotification == true {
            self.showNotification("Changes Discarded")
        }
    }
}

// MARK: - Preview
#Preview("SettingsScreen - English", traits: .navEmbedded) {
    SettingsScreen()
}

#Preview("SettingsScreen - German", traits: .navEmbedded) {
    SettingsScreen()
        .previewLocalization(.german)
}

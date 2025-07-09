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
                header: Text("Map")
                    .accessibilityLabel(UIIdentifiers.SettingScreen.mapHeader)
            ) {
                Picker("Type", selection: Bindable(settingsManager).mapSettings.mapType) {
                    ForEach(MapType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.mapTypePicker)

                Toggle("Compass", isOn: Bindable(settingsManager).mapSettings.showsCompass)
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.compassToggle)

                Toggle("Scale", isOn: Bindable(settingsManager).mapSettings.showsScale)
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.scaleToggle)

                Toggle("Buildings", isOn: Bindable(settingsManager).mapSettings.showsBuildings)
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.buildingsToggle)

                Toggle("Traffic", isOn: Bindable(settingsManager).mapSettings.showsTraffic)
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.trafficToggle)

                Toggle("Rotation", isOn: Bindable(settingsManager).mapSettings.isRotateEnabled)
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.rotateToggle)

                Toggle("Pitch", isOn: Bindable(settingsManager).mapSettings.isPitchEnabled)
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.pitchToggle)

                Toggle("Scroll", isOn: Bindable(settingsManager).mapSettings.isScrollEnabled)
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.scrollToggle)

                Stepper(value: Bindable(settingsManager).mapSettings.zoom, in: 100...100000, step: 100) {
                    Text("Zoom: \(settingsManager.mapSettings.zoom / 1000, specifier: "%.1f") km")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.zoomStepper)

                HStack {
                    Text("0.1 km")
                    Slider(value: Bindable(settingsManager).mapSettings.zoom, in: 100...100000, step: 100)
                        .accessibilityIdentifier(UIIdentifiers.SettingScreen.zoomSlider)
                    Text("100 km")
                }
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

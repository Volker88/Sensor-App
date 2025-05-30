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
            Section(
                header:
                    Text("General", comment: "SettingsScreen - General Section")
            ) {
                Toggle(
                    isOn: $showReleaseNotes,
                    label: {
                        Text("Show Release Notes", comment: "SettingsScreen - Show Release Notes")
                    })
            }
            Section(
                header:
                    Text("App Icon", comment: "Section header - Icon of the App")
            ) {
                HStack {
                    ForEach(0..<settingsManager.iconNames.count, id: \.self) { index in
                        Image(uiImage: UIImage(named: "\(settingsManager.iconNames[index])") ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .conditionalOverlay(visible: settingsManager.currentAppIconIndex == index)
                            .onTapGesture {
                                settingsManager.currentAppIconIndex = index
                                settingsManager.changeIcon(value: index)
                            }
                    }
                }
            }

            Section(
                header:
                    Text("Location", comment: "SettingsScreen - Location Section")
            ) {
                Picker(
                    selection: Bindable(settingsManager).speedSetting,
                    label: Text(
                        "Speed Setting",
                        comment: "SettingsScreen - Speed Setting")
                ) {
                    ForEach(0..<settingsManager.GPSSpeedSettings.count, id: \.self) {
                        Text(settingsManager.GPSSpeedSettings[$0]).tag($0)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.speedPicker)

                Picker(
                    selection: Bindable(settingsManager).accuracySetting,
                    label: Text("Accuracy", comment: "SettingsScreen - Accuracy")
                ) {
                    ForEach(0..<settingsManager.GPSAccuracyOptions.count, id: \.self) {
                        Text(settingsManager.GPSAccuracyOptions[$0]).tag($0)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.accuracyPicker)
            }

            Section(
                header:
                    Text("Map", comment: "SettingsScreen - Map Section")
            ) {
                Picker(
                    selection: Bindable(settingsManager).mapSettings.mapType,
                    label:
                        Text("Type", comment: "SettingsScreen - Type")
                ) {
                    ForEach(MapType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.mapTypePicker)

                Toggle(isOn: Bindable(settingsManager).mapSettings.showsCompass) {
                    Text("Compass", comment: "SettingsScreen - Compass")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.compassToggle)

                Toggle(isOn: Bindable(settingsManager).mapSettings.showsScale) {
                    Text("Scale", comment: "SettingsScreen - Scale")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.scaleToggle)

                Toggle(isOn: Bindable(settingsManager).mapSettings.showsBuildings) {
                    Text("Buildings", comment: "SettingsScreen - Buildings")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.buildingsToggle)

                Toggle(isOn: Bindable(settingsManager).mapSettings.showsTraffic) {
                    Text("Traffic", comment: "SettingsScreen - Traffic")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.trafficToggle)

                Toggle(isOn: Bindable(settingsManager).mapSettings.isRotateEnabled) {
                    Text("Rotation", comment: "SettingsScreen - Rotation")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.rotateToggle)

                Toggle(isOn: Bindable(settingsManager).mapSettings.isPitchEnabled) {
                    Text("Pitch", comment: "SettingsScreen - Pitch")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.pitchToggle)

                Toggle(isOn: Bindable(settingsManager).mapSettings.isScrollEnabled) {
                    Text("Scroll", comment: "SettingsScreen - Scroll")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.scrollToggle)

                Stepper(value: Bindable(settingsManager).mapSettings.zoom, in: 100...100000, step: 100) {
                    Text(
                        "Zoom: \(settingsManager.mapSettings.zoom / 1000, specifier: "%.1f") km",
                        comment: "SettingsScreen - Zoom")
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
                    Text("Altitude", comment: "SettingsScreen - Altitude Section")
            ) {
                Picker(
                    selection: Bindable(settingsManager).pressureSetting,
                    label: Text("Pressure", comment: "SettingsScreen - Pressure")
                ) {
                    ForEach(0..<settingsManager.altitudePressure.count, id: \.self) {
                        Text(settingsManager.altitudePressure[$0]).tag($0)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.pressurePicker)

                Picker(
                    selection: Bindable(settingsManager).heightSetting,
                    label: Text("Height", comment: "SettingsScreen - Height")
                ) {
                    ForEach(0..<settingsManager.altitudeHeight.count, id: \.self) {
                        Text(settingsManager.altitudeHeight[$0]).tag($0)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.altitudePicker)
            }

            Section(
                header:
                    Text("Graph", comment: "SettingsScreen - Graph Section")
            ) {
                Stepper(value: Bindable(settingsManager).userSettings.graphMaxPoints, in: 1...1000, step: 1) {
                    Text(
                        "Max Points: \(settingsManager.userSettings.graphMaxPoints, specifier: "%.0f")",
                        comment: "SettingsScreen - Max Points")
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
                    Text("Save", comment: "NagvigationBarButton - Save")
                        .accessibilityIdentifier(UIIdentifiers.SettingScreen.saveButton)
                }

                Button(action: {
                    discardChanges(showNotification: true)
                }) {
                    Text("Discard", comment: "NagvigationBarButton - Discard Changes")
                        .accessibilityIdentifier(UIIdentifiers.SettingScreen.discardButton)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .accessibilityIdentifier(UIIdentifiers.SettingScreen.collectionView)
        .navigationTitle(Text("Settings", comment: "NavigationBar Title - Settings screen"))
        .onAppear {
            discardChanges(showNotification: false)
        }
    }

    // MARK: - Methods
    func saveSettings() {
        settingsManager.saveSettings()

        showNotification("Saved successfully")
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

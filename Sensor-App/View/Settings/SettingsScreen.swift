//
//  SettingsScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct SettingsScreen: View {

    @Environment(\.showNotification) var showNotification
    @Environment(SettingsManager.self) private var settingsManager

    // MARK: - Body
    var body: some View {
        Form {
            Section(header:
                        Text("General", comment: "SettingsScreen - General Section")
            ) {
                Toggle(isOn: Bindable(settingsManager).userSettings.showReleaseNotes, label: {
                    Text("Show Release Notes", comment: "SettingsScreen - Show Release Notes")
                })
            }
            Section(header:
                        Text("App Icon", comment: "SettingsScreen - App Icon")
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

            Section(header:
                        Text("Location", comment: "SettingsScreen - Location Section")
            ) {
                Picker(
                    selection: Bindable(settingsManager).speedSetting,
                    label: Text("Speed Setting",
                                comment: "SettingsScreen - Speed Setting")
                ) {
                    ForEach(0 ..< settingsManager.GPSSpeedSettings.count, id: \.self) {
                        Text(settingsManager.GPSSpeedSettings[$0]).tag($0)
                    }
                }
                .accessibility(identifier: "Speed Settings")
                Picker(
                    selection: Bindable(settingsManager).accuracySetting,
                    label: Text("Accuracy", comment: "SettingsScreen - Accuracy")
                ) {
                    ForEach(0 ..< settingsManager.GPSAccuracyOptions.count, id: \.self) {
                        Text(settingsManager.GPSAccuracyOptions[$0]).tag($0)
                    }
                }
                .accessibility(identifier: "GPS Accuracy Settings")
            }

            Section(header:
                        Text("Map", comment: "SettingsScreen - Map Section")
                .accessibility(identifier: "Map")
            ) {
                Picker(selection: Bindable(settingsManager).mapSettings.mapType, label:
                        Text("Type", comment: "SettingsScreen - Type")) {
                    ForEach(MapType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                        .accessibility(identifier: "MapType Picker")

                Toggle(isOn: Bindable(settingsManager).mapSettings.showsCompass) {
                    Text("Compass", comment: "SettingsScreen - Compass")
                }.accessibility(identifier: "Compass Toggle")

                Toggle(isOn: Bindable(settingsManager).mapSettings.showsScale) {
                    Text("Scale", comment: "SettingsScreen - Scale")
                }.accessibility(identifier: "Scale Toggle")

                Toggle(isOn: Bindable(settingsManager).mapSettings.showsBuildings) {
                    Text("Buildings", comment: "SettingsScreen - Buildings")
                }.accessibility(identifier: "Buildings Toggle")

                Toggle(isOn: Bindable(settingsManager).mapSettings.showsTraffic) {
                    Text("Traffic", comment: "SettingsScreen - Traffic")
                }.accessibility(identifier: "Traffic Toggle")

                Toggle(isOn: Bindable(settingsManager).mapSettings.isRotateEnabled) {
                    Text("Rotation", comment: "SettingsScreen - Rotation")
                }.accessibility(identifier: "Rotate Toggle")

                Toggle(isOn: Bindable(settingsManager).mapSettings.isPitchEnabled) {
                    Text("Pitch", comment: "SettingsScreen - Pitch")
                }.accessibility(identifier: "Pitch Toggle")

                Toggle(isOn: Bindable(settingsManager).mapSettings.isScrollEnabled) {
                    Text("Scroll", comment: "SettingsScreen - Scroll")
                }.accessibility(identifier: "Scroll Toggle")

                Stepper(value: Bindable(settingsManager).mapSettings.zoom, in: 100...100000, step: 100) {
                    Text("Zoom: \(settingsManager.mapSettings.zoom / 1000, specifier: "%.1f") km",
                         comment: "SettingsScreen - Zoom")
                }.accessibility(identifier: "Zoom Stepper")

                HStack {
                    Text("0.1 km", comment: "SettingsScreen - 0.1km")
                    Slider(value: Bindable(settingsManager).mapSettings.zoom, in: 100...100000, step: 100)
                        .accessibility(identifier: "Zoom Slider")
                        .accessibility(label: Text("Zoom:", comment: "SettingsScreen - ZoomSlider"))
                        .accessibility(value: Text("\(settingsManager.mapSettings.zoom, specifier: "%.1f") km", comment: "SettingsScreen - ZoomSlider"))
                    Text("100 km", comment: "SettingsScreen - 100km")
                }
            }

            Section(header:
                        Text("Altitude", comment: "SettingsScreen - Altitude Section")
            ) {
                Picker(
                    selection: Bindable(settingsManager).pressureSetting,
                    label: Text("Pressure", comment: "SettingsScreen - Pressure")
                ) {
                    ForEach(0 ..< settingsManager.altitudePressure.count, id: \.self) {
                        Text(settingsManager.altitudePressure[$0]).tag($0)
                    }
                }
                .accessibility(identifier: "Pressure Settings")
                Picker(selection: Bindable(settingsManager).heightSetting, label: Text("Height",
                                                                                       comment: "SettingsScreen - Height")
                ) {
                    ForEach(0 ..< settingsManager.altitudeHeight.count, id: \.self) {
                        Text(settingsManager.altitudeHeight[$0]).tag($0)
                    }
                }
                .accessibility(identifier: "Height Settings")
            }

            Section(header:
                        Text("Graph", comment: "SettingsScreen - Graph Section")
            ) {
                Stepper(value: Bindable(settingsManager).userSettings.graphMaxPoints, in: 1...1000, step: 1) {
                    Text("Max Points: \(settingsManager.userSettings.graphMaxPoints, specifier: "%.0f")",
                         comment: "SettingsScreen - Max Points")
                }.accessibility(identifier: "Max Points Stepper")
                HStack {
                    Text("1", comment: "SettingsScreen - 1")
                    Slider(
                        value: Bindable(settingsManager).userSettings.graphMaxPoints,
                        in: 1...1000,
                        step: 1
                    )
                    .accessibility(identifier: "Max Points Slider")
                    .accessibility(label: Text("Maximum Points:", comment: "SettingsScreen - Max Points Slider"))
                    .accessibility(value: Text("\(settingsManager.userSettings.graphMaxPoints, specifier: "%.0f")", comment: "SettingsScreen - Max Points Slider"))
                    Text("1000", comment: "SettingsScreen - 1000")
                }
            }

            Section {
                Button(action: {
                    saveSettings()
                }) {
                    Text("Save", comment: "NagvigationBarButton - Save")
                        .accessibility(label: Text("Save", comment: "NagvigationBarButton - Save"))
                        .accessibility(identifier: "Save")
                }

                Button(action: {
                    discardChanges(showNotification: true)
                }) {
                    Text("Discard", comment: "NagvigationBarButton - Discard Changes")
                        .accessibility(label: Text("Discard", comment: "NagvigationBarButton - Discard Changes"))
                        .accessibility(identifier: "Discard")
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .navigationTitle(NSLocalizedString("Settings", comment: "NavigationBar Title - Settings"))
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
#Preview {
    SettingsScreen()
        .previewNavigationStackWrapper()
}

//
//  SettingsScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.dismiss) var dismiss

    let settings = SettingsAPI()
    let notificationAPI = NotificationAPI()

    @StateObject var settingsVM = SettingsViewModel()
    @State private var notificationMessage = ""
    @State private var showNotification = false

    let notificationSettings: NotificationAnimationModel

    init() {
        notificationSettings = notificationAPI.fetchNotificationAnimationSettings()
    }

    var closeButton: some View {
        Button(action: {
            discardView()
        }) {
            Image(systemName: "xmark.circle")
                .accessibility(identifier: "Close")
                .accessibilityIdentifier("Close")
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header:
                                Text("General", comment: "SettingsScreen - General Section")
                    ) {
                        Toggle(isOn: $settingsVM.userSettings.showReleaseNotes, label: {
                            Text("Show Release Notes", comment: "SettingsScreen - Show Release Notes")
                        })
                    }
                    Section(header:
                                Text("App Icon", comment: "SettingsScreen - App Icon")
                    ) {
                        HStack {
                            ForEach(0..<settingsVM.iconNames.count, id: \.self) { index in
                                Image(uiImage: UIImage(named: "\(settingsVM.iconNames[index])") ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .conditionalOverlay(visible: settingsVM.currentAppIconIndex == index)
                                    .onTapGesture {
                                        settingsVM.currentAppIconIndex = index
                                        settingsVM.changeIcon(value: index)
                                    }
                            }
                        }
                    }

                    Section(header:
                                Text("Location", comment: "SettingsScreen - Location Section")
                    ) {
                        Picker(
                            selection: $settingsVM.speedSetting,
                            label: Text("Speed Setting",
                                        comment: "SettingsScreen - Speed Setting")
                        ) {
                            ForEach(0 ..< settings.GPSSpeedSettings.count, id: \.self) {
                                Text(settings.GPSSpeedSettings[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "Speed Settings")
                        Picker(
                            selection: $settingsVM.accuracySetting,
                            label: Text("Accuracy", comment: "SettingsScreen - Accuracy")
                        ) {
                            ForEach(0 ..< settings.GPSAccuracyOptions.count, id: \.self) {
                                Text(settings.GPSAccuracyOptions[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "GPS Accuracy Settings")
                    }

                    Section(header:
                                Text("Map", comment: "SettingsScreen - Map Section")
                    ) {
                        Picker(selection: $settingsVM.mapSettings.mapType, label:
                                Text("Type", comment: "SettingsScreen - Type")) {
                            ForEach(MapType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                                .accessibility(identifier: "MapType Picker")

                        Toggle(isOn: $settingsVM.mapSettings.showsCompass) {
                            Text("Compass", comment: "SettingsScreen - Compass")
                        }.accessibility(identifier: "Compass Toggle")

                        Toggle(isOn: $settingsVM.mapSettings.showsScale) {
                            Text("Scale", comment: "SettingsScreen - Scale")
                        }.accessibility(identifier: "Scale Toggle")

                        Toggle(isOn: $settingsVM.mapSettings.showsBuildings) {
                            Text("Buildings", comment: "SettingsScreen - Buildings")
                        }.accessibility(identifier: "Buildings Toggle")

                        Toggle(isOn: $settingsVM.mapSettings.showsTraffic) {
                            Text("Traffic", comment: "SettingsScreen - Traffic")
                        }.accessibility(identifier: "Traffic Toggle")

                        Toggle(isOn: $settingsVM.mapSettings.isRotateEnabled) {
                            Text("Rotation", comment: "SettingsScreen - Rotation")
                        }.accessibility(identifier: "Rotate Toggle")

                        Toggle(isOn: $settingsVM.mapSettings.isPitchEnabled) {
                            Text("Pitch", comment: "SettingsScreen - Pitch")
                        }.accessibility(identifier: "Pitch Toggle")

                        Toggle(isOn: $settingsVM.mapSettings.isScrollEnabled) {
                            Text("Scroll", comment: "SettingsScreen - Scroll")
                        }.accessibility(identifier: "Scroll Toggle")

                        Stepper(value: $settingsVM.mapSettings.zoom, in: 100...100000, step: 100) {
                            Text("Zoom: \(settingsVM.mapSettings.zoom / 1000, specifier: "%.1f") km",
                                 comment: "SettingsScreen - Zoom")
                        }.accessibility(identifier: "Zoom Stepper")

                        HStack {
                            Text("0.1 km", comment: "SettingsScreen - 0.1km")
                            Slider(value: $settingsVM.mapSettings.zoom, in: 100...100000, step: 100)
                                .accessibility(identifier: "Zoom Slider")
                                .accessibility(label: Text("Zoom:", comment: "SettingsScreen - ZoomSlider"))
                                .accessibility(value: Text("\(settingsVM.mapSettings.zoom, specifier: "%.1f") km", comment: "SettingsScreen - ZoomSlider")) // swiftlint:disable:this line_length
                            Text("100 km", comment: "SettingsScreen - 100km")
                        }
                    }

                    Section(header:
                                Text("Altitude", comment: "SettingsScreen - Altitude Section")
                    ) {
                        Picker(
                            selection: $settingsVM.pressureSetting,
                            label: Text("Pressure", comment: "SettingsScreen - Pressure")
                        ) {
                            ForEach(0 ..< settings.altitudePressure.count, id: \.self) {
                                Text(settings.altitudePressure[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "Pressure Settings")
                        Picker(selection: $settingsVM.heightSetting, label: Text("Height",
                                                                                 comment: "SettingsScreen - Height")) {
                            ForEach(0 ..< settings.altitudeHeight.count, id: \.self) {
                                Text(settings.altitudeHeight[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "Height Settings")
                    }

                    Section(header:
                                Text("Graph", comment: "SettingsScreen - Graph Section")
                    ) {
                        Stepper(value: $settingsVM.userSettings.graphMaxPoints, in: 1...1000, step: 1) {
                            Text("Max Points: \(settingsVM.userSettings.graphMaxPoints, specifier: "%.0f")",
                                 comment: "SettingsScreen - Max Points")
                        }.accessibility(identifier: "Max Points Stepper")
                        HStack {
                            Text("1", comment: "SettingsScreen - 1")
                            Slider(
                                value: $settingsVM.userSettings.graphMaxPoints,
                                in: 1...1000,
                                step: 1
                            )
                            .accessibility(identifier: "Max Points Slider")
                            .accessibility(label: Text("Maximum Points:", comment: "SettingsScreen - Max Points Slider")) // swiftlint:disable:this line_length
                            .accessibility(value: Text("\(settingsVM.userSettings.graphMaxPoints, specifier: "%.0f")", comment: "SettingsScreen - Max Points Slider")) // swiftlint:disable:this line_length
                            Text("1000", comment: "SettingsScreen - 1000")
                        }
                    }

                    Section {
                        Button(action: {
                            saveSettings()
                        }) {
                            Text("Save", comment: "NagvigationBarButton - Save")
                                .accessibility(label: Text("Save", comment: "NagvigationBarButton - Save"))
                                .navigationBarItemModifier(accessibility: "Save Settings")
                        }

                        Button(action: {
                            discardChanges(showNotification: true)
                        }) {
                            Text("Discard", comment: "NagvigationBarButton - Discard Changes")
                                .accessibility(
                                    label: Text("Discard", comment: "NagvigationBarButton - Discard Changes")
                                )
                                .navigationBarItemModifier(accessibility: "Reset Settings")
                        }
                    }
                }
                .navigationTitle(NSLocalizedString("Settings", comment: "NavigationBar Title - Settings"))

                NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
            }
            .navigationBarItems(leading: closeButton)
        }
        .onAppear {
            discardChanges(showNotification: false)
        }
    }

    func saveSettings() {
        settingsVM.saveSettings()

        // Show Notification
        notificationAPI.toggleNotification(type: .saved, duration: nil) { (message, show) in
            notificationMessage = message
            showNotification = show
        }
    }

    func discardChanges(showNotification: Bool) {
        settingsVM.discardChanges()

        // Show Notification
        if showNotification == true {
            notificationAPI.toggleNotification(type: .discarded, duration: nil) { (message, show) in
                notificationMessage = message
                self.showNotification = show
            }
        }
    }

    func discardView() {
        discardChanges(showNotification: false)
        dismiss()
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}

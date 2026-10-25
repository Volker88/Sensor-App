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

    @State private var showSignalBoard = false

    // MARK: - Body
    var body: some View {
        Form {
            Section("General") {
                Toggle("Show Release Notes", isOn: $showReleaseNotes)
                    .accessibilityRemoveTraits(.isButton)
            }

            Section(
                header:
                    Text("App Icon")
            ) {
                HStack {
                    Spacer()

                    ForEach(0..<settingsManager.appIcons.count, id: \.self) { index in
                        let iconName = settingsManager.appIcons[index].iconName
                        let accessibilityName = settingsManager.appIcons[index].accessibilityName

                        Button {
                            settingsManager.changeIcon(value: index)
                        } label: {
                            Image(uiImage: UIImage(named: iconName) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                // Visual selection ring
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: settingsManager.currentAppIconIndex == index ? 4 : 0)
                                )
                                // Checkmark overlay (hidden from VoiceOver)
                                .overlay(alignment: .topTrailing) {
                                    if settingsManager.currentAppIconIndex == index {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title)
                                            .padding(6)
                                            .background(.ultraThinMaterial, in: Circle())
                                            .accessibilityHidden(true)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                        // Combine image + overlays into a single accessible control
                        .accessibilityLabel(Text("App icon \(accessibilityName)"))
                        .accessibilityAddTraits(settingsManager.currentAppIconIndex == index ? .isSelected : [])
                        .accessibilityRemoveTraits(.isButton)
                        .accessibilityHint(
                            "Tap to set as App Icon",
                            isEnabled: settingsManager.currentAppIconIndex != index
                        )
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

                Picker("Accuracy Unit", selection: Bindable(settingsManager).locationAccuracySetting) {
                    ForEach(0..<settingsManager.altitudeHeight.count, id: \.self) {
                        Text(settingsManager.altitudeHeight[$0]).tag($0)
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.locationAccuracyPicker)
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
                        .accessibilityLabel("Maximum points of data to show in graphs")
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.maxPointsStepper)

                HStack {
                    Text("1")
                        .accessibilityHint("Minimum points of data to show in graphs")

                    Slider(
                        value: Bindable(settingsManager).userSettings.graphMaxPoints,
                        in: 1...1000,
                        step: 1
                    )
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.maxPointsSlider)

                    Text("1000")
                        .accessibilityHint("Maximum points of data to show in graphs")
                }
            }

            Section {
                Toggle(
                    "Keep Screen On While Recording",
                    isOn: Bindable(settingsManager).userSettings.keepScreenOnWhileRecording
                )
                .accessibilityRemoveTraits(.isButton)
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.keepScreenOnToggle)
            } header: {
                Text("Recording")
                    .accessibilityIdentifier(UIIdentifiers.SettingScreen.recordingHeader)
            } footer: {
                Text(
                    "Prevents auto-lock so sensor data keeps being captured. Locking the device manually or leaving the app still pauses the recording. Keeping the display on increases battery usage." // swiftlint:disable:this line_length
                )
            }

            Section {
                Button("Feature Requests", systemImage: "lightbulb") {
                    showSignalBoard = true
                }
            } header: {
                Text("Feedback")
            } footer: {
                Text("Suggest new features and vote on ideas from other users.")
            }

            #if DEBUG
                Section("Developer") {
                    NavigationLink("Diagnostics") {
                        DiagnosticsScreen()
                    }
                }
            #endif
        }
        .accessibilityIdentifier(UIIdentifiers.SettingScreen.collectionView)
        .navigationTitle(RootTab.settings.localizedString)
        .sheet(isPresented: $showSignalBoard) {
            SignalBoardScreen(showSignalBoard: $showSignalBoard)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", systemImage: "checkmark") {
                    saveSettings()
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.saveButton)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Discard", systemImage: "xmark") {
                    discardChanges(showNotification: true)
                }
                .accessibilityIdentifier(UIIdentifiers.SettingScreen.discardButton)
            }
        }
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

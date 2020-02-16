//
//  SettingsView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct SettingsView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State / @ObservedObject
    @State private var showingDiscardAlert = false
    @State private var showingSaveAlert = false
    @State var refreshRate : Double = SettingsAPI.shared.fetchUserSettings().frequencySetting
    
    
    // MARK: - Variables / Constants
    @State var speedSetting = SettingsAPI.shared.GPSSpeedSettings.firstIndex(of: SettingsAPI.shared.fetchUserSettings().GPSSpeedSetting)!
    @State var accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.fetchUserSettings().GPSAccuracySetting)!
    @State var pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.fetchUserSettings().pressureSetting)!
    @State var heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.fetchUserSettings().altitudeHeightSetting)!
    
    
    // MARK: - Methods
    func saveSettings() {
        var settings = SettingsAPI.shared.fetchUserSettings()
        settings.GPSSpeedSetting = SettingsAPI.shared.GPSSpeedSettings[self.speedSetting]
        settings.GPSAccuracySetting = SettingsAPI.shared.GPSAccuracyOptions[self.accuracySetting]
        settings.pressureSetting = SettingsAPI.shared.altitudePressure[self.pressureSetting]
        settings.altitudeHeightSetting = SettingsAPI.shared.altitudeHeight[self.heightSetting]
        settings.frequencySetting = self.refreshRate
        SettingsAPI.shared.saveUserSettings(userSettings: settings)
        
        self.showingSaveAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.showingSaveAlert = false
        })
    }
    
    func discardChanges(showNotification: Bool) {
        self.speedSetting = SettingsAPI.shared.GPSSpeedSettings.firstIndex(of: SettingsAPI.shared.fetchUserSettings().GPSSpeedSetting)!
        self.accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.fetchUserSettings().GPSAccuracySetting)!
        self.pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.fetchUserSettings().pressureSetting)!
        self.heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.fetchUserSettings().altitudeHeightSetting)!
        self.refreshRate = SettingsAPI.shared.fetchUserSettings().frequencySetting
        
        if showNotification == true {
            self.showingDiscardAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.showingDiscardAlert = false
            })
        }
    }
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        
    }
    
    func onDisappear() {
        discardChanges(showNotification: false)
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return Form {
            Section(header:
                Text("Location")
            ) {
                Picker(selection: self.$speedSetting, label: Text("Speed Setting")) {
                    ForEach(0 ..< SettingsAPI.shared.GPSSpeedSettings.count, id: \.self) {
                        Text(SettingsAPI.shared.GPSSpeedSettings[$0]).tag($0)
                    }
                }
                Picker(selection: self.$accuracySetting, label: Text("Accuracy")) {
                    ForEach(0 ..< SettingsAPI.shared.GPSAccuracyOptions.count, id: \.self) {
                        Text(SettingsAPI.shared.GPSAccuracyOptions[$0]).tag($0)
                    }
                }
            }
            Section(header:
                Text("Altitude")
            ) {
                Picker(selection: self.$pressureSetting, label: Text("Pressure")) {
                    ForEach(0 ..< SettingsAPI.shared.altitudePressure.count, id: \.self) {
                        Text(SettingsAPI.shared.altitudePressure[$0]).tag($0)
                    }
                }
                Picker(selection: self.$heightSetting, label: Text("Height")) {
                    ForEach(0 ..< SettingsAPI.shared.altitudeHeight.count, id: \.self) {
                        Text(SettingsAPI.shared.altitudeHeight[$0]).tag($0)
                    }
                }
            }
            Section(header:
                Text("Refresh Rate")
            ) {
                Text("Frequency: \(Int(self.refreshRate)) Hz")
                Slider(value: self.$refreshRate, in: 1...50, step: 1) { refresh in
                    
                }
            }
            Section {
                Button(action: {
                    self.discardChanges(showNotification: true)
                }) {
                    Text("Discard")
                }
                .alert(isPresented: $showingDiscardAlert) {
                    Alert(title: Text("Discarded Changes"))
                }
                Button(action: {
                    self.saveSettings()
                }) {
                    Text("Save")
                }.alert(isPresented: $showingSaveAlert) {
                    Alert(title: Text("Saved Changes"))
                }
            }
            
        }
        .navigationBarTitle("Settings")
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
}


// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView().previewDevice("Apple Watch Series 3 - 38mm")
            SettingsView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}

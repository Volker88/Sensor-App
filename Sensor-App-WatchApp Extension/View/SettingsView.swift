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
    let settings = SettingsAPI()
    
    // MARK: - @State / @ObservedObject
    @State private var showingDiscardAlert = false
    @State private var showingSaveAlert = false
    @State var refreshRate : Double = 1
    
    
    // MARK: - Variables / Constants
    @State var speedSetting = 0
    @State var accuracySetting = 0
    @State var pressureSetting = 0
    @State var heightSetting = 0
    
    
    // MARK: - Initializer
    init() {
        refreshRate = settings.fetchUserSettings().frequencySetting
        speedSetting = settings.GPSSpeedSettings.firstIndex(of: settings.fetchUserSettings().GPSSpeedSetting)!
        accuracySetting = settings.GPSAccuracyOptions.firstIndex(of: settings.fetchUserSettings().GPSAccuracySetting)!
        pressureSetting = settings.altitudePressure.firstIndex(of: settings.fetchUserSettings().pressureSetting)!
        heightSetting = settings.altitudeHeight.firstIndex(of: settings.fetchUserSettings().altitudeHeightSetting)!
    }
    
    
    // MARK: - Methods
    func saveSettings() {
        var userSettings = settings.fetchUserSettings()
        userSettings.GPSSpeedSetting = settings.GPSSpeedSettings[self.speedSetting]
        userSettings.GPSAccuracySetting = settings.GPSAccuracyOptions[self.accuracySetting]
        userSettings.pressureSetting = settings.altitudePressure[self.pressureSetting]
        userSettings.altitudeHeightSetting = settings.altitudeHeight[self.heightSetting]
        userSettings.frequencySetting = self.refreshRate
        settings.saveUserSettings(userSettings: userSettings)
        
        self.showingSaveAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.showingSaveAlert = false
        })
    }
    
    func discardChanges(showNotification: Bool) {
        self.speedSetting = settings.GPSSpeedSettings.firstIndex(of: settings.fetchUserSettings().GPSSpeedSetting)!
        self.accuracySetting = settings.GPSAccuracyOptions.firstIndex(of: settings.fetchUserSettings().GPSAccuracySetting)!
        self.pressureSetting = settings.altitudePressure.firstIndex(of: settings.fetchUserSettings().pressureSetting)!
        self.heightSetting = settings.altitudeHeight.firstIndex(of: settings.fetchUserSettings().altitudeHeightSetting)!
        self.refreshRate = settings.fetchUserSettings().frequencySetting
        
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
                    ForEach(0 ..< settings.GPSSpeedSettings.count, id: \.self) {
                        Text(self.settings.GPSSpeedSettings[$0]).tag($0)
                    }
                }
                Picker(selection: self.$accuracySetting, label: Text("Accuracy")) {
                    ForEach(0 ..< settings.GPSAccuracyOptions.count, id: \.self) {
                        Text(self.settings.GPSAccuracyOptions[$0]).tag($0)
                    }
                }
            }
            Section(header:
                Text("Altitude")
            ) {
                Picker(selection: self.$pressureSetting, label: Text("Pressure")) {
                    ForEach(0 ..< settings.altitudePressure.count, id: \.self) {
                        Text(self.settings.altitudePressure[$0]).tag($0)
                    }
                }
                Picker(selection: self.$heightSetting, label: Text("Height")) {
                    ForEach(0 ..< settings.altitudeHeight.count, id: \.self) {
                        Text(self.settings.altitudeHeight[$0]).tag($0)
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

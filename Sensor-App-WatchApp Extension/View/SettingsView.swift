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
    @State var refreshRate : Double = Double(SettingsAPI.shared.fetchFrequency())
    
    
    // MARK: - Variables / Constants
    @State var speedSetting = SettingsAPI.shared.GPSSpeedSettings.firstIndex(of: SettingsAPI.shared.fetchSpeedSetting())!
    @State var accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.fetchGPSAccuracySetting())!
    @State var pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.fetchPressureSetting())!
    @State var heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.fetchHeightSetting())!
    
    
    // MARK: - Methods
    func saveSettings() {
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.GPSSpeedSettings[self.speedSetting], setting: SettingsForUserDefaults.GPSSpeedSetting)
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.GPSAccuracyOptions[self.accuracySetting], setting: SettingsForUserDefaults.GPSAccuracySetting)
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.altitudePressure[self.pressureSetting], setting: SettingsForUserDefaults.pressureSetting)
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.altitudeHeight[self.heightSetting], setting: SettingsForUserDefaults.altitudeHeightSetting)
        updateSlider()
        
        self.showingSaveAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.showingSaveAlert = false
        })
    }
    
    func discardChanges(showNotification: Bool) {
        self.speedSetting = SettingsAPI.shared.GPSSpeedSettings.firstIndex(of: SettingsAPI.shared.fetchSpeedSetting())!
        self.accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.fetchGPSAccuracySetting())!
        self.pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.fetchPressureSetting())!
        self.heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.fetchHeightSetting())!
        self.refreshRate = Double(SettingsAPI.shared.fetchFrequency())
        
        if showNotification == true {
            self.showingDiscardAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.showingDiscardAlert = false
            })
        }
    }
    
    func updateSlider() {
        // Save Sensor Settings
        SettingsAPI.shared.saveFrequency(frequency: Float(self.refreshRate))
        
        // Update Sensor Interval
        CoreMotionAPI.shared.sensorUpdateInterval = self.refreshRate
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

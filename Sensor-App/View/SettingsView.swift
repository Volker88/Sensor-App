//
//  SettingsView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct SettingsView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - Variables / Constants
    @State var speedSetting = SettingsAPI.shared.GPSspeedSettings.firstIndex(of: SettingsAPI.shared.readSpeedSetting())!
    @State var accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.readGPSAccuracySetting())!
    @State var pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.readPressureSetting())!
    @State var heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.readHeightSetting())!
    
    
    // MARK: - Methods
    func saveSettings() {
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.GPSspeedSettings[self.speedSetting], setting: SettingsForUserDefaults.GPSSpeedSetting)
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.GPSAccuracyOptions[self.accuracySetting], setting: SettingsForUserDefaults.GPSAccuracySetting)
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.altitudePressure[self.pressureSetting], setting: SettingsForUserDefaults.pressureSetting)
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.altitudeHeight[self.heightSetting], setting: SettingsForUserDefaults.altitudeHeightSetting)
    }
    
    func discardChanges() {
        self.speedSetting = SettingsAPI.shared.GPSspeedSettings.firstIndex(of: SettingsAPI.shared.readSpeedSetting())!
        self.accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.readGPSAccuracySetting())!
        self.pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.readPressureSetting())!
        self.heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.readHeightSetting())!
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        return NavigationView {
            Form {
                Section(header:
                    Text("Location")
                        .font(.largeTitle)
                ) {
                    Picker(selection: self.$speedSetting, label: Text("Speed Setting")) {
                        ForEach(0 ..< SettingsAPI.shared.GPSspeedSettings.count) {
                            Text(SettingsAPI.shared.GPSspeedSettings[$0]).tag($0)
                        }
                    }
                    
                    Picker(selection: self.$accuracySetting, label: Text("Accuracy")) {
                        ForEach(0 ..< SettingsAPI.shared.GPSAccuracyOptions.count) {
                            Text(SettingsAPI.shared.GPSAccuracyOptions[$0]).tag($0)
                        }
                    }
                }
                Section(header:
                    Text("Altitude")
                        .font(.largeTitle)
                ) {
                    Picker(selection: self.$pressureSetting, label: Text("Pressure")) {
                        ForEach(0 ..< SettingsAPI.shared.altitudePressure.count) {
                            Text(SettingsAPI.shared.altitudePressure[$0]).tag($0)
                        }
                    }

                    Picker(selection: self.$heightSetting, label: Text("Height")) {
                        ForEach(0 ..< SettingsAPI.shared.altitudeHeight.count) {
                            Text(SettingsAPI.shared.altitudeHeight[$0]).tag($0)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .navigationBarHidden(true)
            .background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
                
        }.navigationBarTitle(Text("Settings"), displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    self.discardChanges()
                }) {
                    Image("UndoButton")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                Button(action: {
                    self.saveSettings()
                }) {
                    Image("SaveButton")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
        })
    }
}


// MARK: - Preview
#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif

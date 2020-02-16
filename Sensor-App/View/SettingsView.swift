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
    
    // MARK: - Environment Objects
    @Environment(\.presentationMode) var presentationMode
    
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State Variables
    @State var notificationMessage = ""
    @State var showNotification = false
    
    
    // MARK: - Variables / Constants
    @State var speedSetting = SettingsAPI.shared.GPSSpeedSettings.firstIndex(of: SettingsAPI.shared.fetchUserSettings().GPSSpeedSetting)!
    @State var accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.fetchUserSettings().GPSAccuracySetting)!
    @State var pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.fetchUserSettings().pressureSetting)!
    @State var heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.fetchUserSettings().altitudeHeightSetting)!
    let notificationSettings = NotificationAPI.shared.fetchNotificationAnimationSettings()
    
    
    // MARK: - Methods
    func saveSettings() {
        var settings = SettingsAPI.shared.fetchUserSettings()
        settings.GPSSpeedSetting = SettingsAPI.shared.GPSSpeedSettings[self.speedSetting]
        settings.GPSAccuracySetting = SettingsAPI.shared.GPSAccuracyOptions[self.accuracySetting]
        settings.pressureSetting = SettingsAPI.shared.altitudePressure[self.pressureSetting]
        settings.altitudeHeightSetting = SettingsAPI.shared.altitudeHeight[self.heightSetting]
        SettingsAPI.shared.saveUserSettings(userSettings: settings)
        
        NotificationAPI.shared.toggleNotification(type: .saved, duration: nil) { (message, show) in
            self.notificationMessage = message
            self.showNotification = show
        }
    }
    
    func discardChanges(showNotification: Bool) {
        self.speedSetting = SettingsAPI.shared.GPSSpeedSettings.firstIndex(of: SettingsAPI.shared.fetchUserSettings().GPSSpeedSetting)!
        self.accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.fetchUserSettings().GPSAccuracySetting)!
        self.pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.fetchUserSettings().pressureSetting)!
        self.heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.fetchUserSettings().altitudeHeightSetting)!
        if showNotification == true {
            NotificationAPI.shared.toggleNotification(type: .discarded, duration: nil) { (message, show) in
                self.notificationMessage = message
                self.showNotification = show
            }
        }
    }
    
    func discardView() {
        self.discardChanges(showNotification: false)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        
    }
    
    func onDisappear() {
        
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        return ZStack {
            NavigationView {
                Form {
                    Section(header:
                        Text("Location")
                            .font(.largeTitle)
                    ) {
                        Picker(selection: self.$speedSetting, label: Text("Speed Setting")) {
                            ForEach(0 ..< SettingsAPI.shared.GPSSpeedSettings.count, id: \.self) {
                                Text(SettingsAPI.shared.GPSSpeedSettings[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "Speed Settings")
                        Picker(selection: self.$accuracySetting, label: Text("Accuracy")) {
                            ForEach(0 ..< SettingsAPI.shared.GPSAccuracyOptions.count, id: \.self) {
                                Text(SettingsAPI.shared.GPSAccuracyOptions[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "GPS Accuracy Settings")
                    }
                    Section(header:
                        Text("Altitude")
                            .font(.largeTitle)
                    ) {
                        Picker(selection: self.$pressureSetting, label: Text("Pressure")) {
                            ForEach(0 ..< SettingsAPI.shared.altitudePressure.count, id: \.self) {
                                Text(SettingsAPI.shared.altitudePressure[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "Pressure Settings")
                        Picker(selection: self.$heightSetting, label: Text("Height")) {
                            ForEach(0 ..< SettingsAPI.shared.altitudeHeight.count, id: \.self) {
                                Text(SettingsAPI.shared.altitudeHeight[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "Height Settings")
                    }
                }
                .navigationBarTitle(Text("Settings"), displayMode: .inline)
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarItems(leading:
                    Button(action: {
                        self.discardView()
                    }) {
                        Image(systemName: "clear")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .accessibility(identifier: "Close Button"), trailing:
                    HStack {
                        Button(action: {
                            self.discardChanges(showNotification: true)
                        }) {
                            Image(systemName: "gobackward")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .accessibility(identifier: "Reset Settings")
                        Button(action: {
                            self.saveSettings()
                        }) {
                            Image("SaveButton")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .accessibility(identifier: "Save Settings")
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
    }
}


// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            SettingsView()
                .colorScheme(scheme)
        }
    }
}

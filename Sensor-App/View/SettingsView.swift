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
    let settings = SettingsAPI()
    let notificationAPI = NotificationAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @State private var notificationMessage = ""
    @State private var showNotification = false
    @State private var speedSetting = 0
    @State private var accuracySetting = 0
    @State private var pressureSetting = 0
    @State private var heightSetting = 0
    @State private var graphMaxPoints = 0.0
    
    
    // MARK: - Define Constants / Variables
    let notificationSettings: NotificationAnimationModel
    
    
    // MARK: - Initializer
    init() {
        notificationSettings = notificationAPI.fetchNotificationAnimationSettings()
    }
    
    
    // MARK: - Methods
    func saveSettings() {
        var userSettings = settings.fetchUserSettings()
        userSettings.GPSSpeedSetting = settings.GPSSpeedSettings[self.speedSetting]
        userSettings.GPSAccuracySetting = settings.GPSAccuracyOptions[self.accuracySetting]
        userSettings.pressureSetting = settings.altitudePressure[self.pressureSetting]
        userSettings.altitudeHeightSetting = settings.altitudeHeight[self.heightSetting]
        userSettings.graphMaxPoints = Int(self.graphMaxPoints)
        
        settings.saveUserSettings(userSettings: userSettings)
        
        notificationAPI.toggleNotification(type: .saved, duration: nil) { (message, show) in
            self.notificationMessage = message
            self.showNotification = show
        }
    }
    
    func discardChanges(showNotification: Bool) {
        self.speedSetting = settings.GPSSpeedSettings.firstIndex(of: settings.fetchUserSettings().GPSSpeedSetting)!
        self.accuracySetting = settings.GPSAccuracyOptions.firstIndex(of: settings.fetchUserSettings().GPSAccuracySetting)!
        self.pressureSetting = settings.altitudePressure.firstIndex(of: settings.fetchUserSettings().pressureSetting)!
        self.heightSetting = settings.altitudeHeight.firstIndex(of: settings.fetchUserSettings().altitudeHeightSetting)!
        self.graphMaxPoints = Double(settings.fetchUserSettings().graphMaxPoints)
        
        if showNotification == true {
            notificationAPI.toggleNotification(type: .discarded, duration: nil) { (message, show) in
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
        self.discardChanges(showNotification: false)
    }
    
    func onDisappear() {
        
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return view
        return ZStack {
            NavigationView {
                Form {
                    Section(header:
                        Text("Location")
                            .font(.title)
                    ) {
                        Picker(selection: self.$speedSetting, label: Text("Speed Setting")) {
                            ForEach(0 ..< settings.GPSSpeedSettings.count, id: \.self) {
                                Text(self.settings.GPSSpeedSettings[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "Speed Settings")
                        Picker(selection: self.$accuracySetting, label: Text("Accuracy")) {
                            ForEach(0 ..< settings.GPSAccuracyOptions.count, id: \.self) {
                                Text(self.settings.GPSAccuracyOptions[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "GPS Accuracy Settings")
                        
                        
                        
                        
                    }
                    Section(header:
                        Text("Altitude")
                            .font(.title)
                    ) {
                        Picker(selection: self.$pressureSetting, label: Text("Pressure")) {
                            ForEach(0 ..< settings.altitudePressure.count, id: \.self) {
                                Text(self.settings.altitudePressure[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "Pressure Settings")
                        Picker(selection: self.$heightSetting, label: Text("Height")) {
                            ForEach(0 ..< settings.altitudeHeight.count, id: \.self) {
                                Text(self.settings.altitudeHeight[$0]).tag($0)
                            }
                        }
                        .accessibility(identifier: "Height Settings")
                    }
                    
                    Section(header:
                        Text("Graph")
                            .font(.title)
                    ) {
                        Text("Max Points: \(Int(self.graphMaxPoints))")
                        HStack {
                            Text("1")
                            Slider(value: self.$graphMaxPoints, in: 1...1000, step: 1)
                                .accessibility(identifier: "Max Points Slider")
                            Text("1000")
                        }
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

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
    
    // Location
    @State private var speedSetting = 0
    @State private var accuracySetting = 0
    
    // Map
    @State private var selectedMapType = 0
    @State private var showsCompass = false
    @State private var showsScale = false
    @State private var showsBuildings = false
    @State private var showsTraffic = false
    @State private var isRotateEnabled = false
    @State private var isScrollEnabled = false
    @State private var zoom = 0.0
    
    
    // Altitude
    @State private var pressureSetting = 0
    @State private var heightSetting = 0
    
    // Chart
    @State private var graphMaxPoints = 0.0
    
    
    // MARK: - Define Constants / Variables
    let notificationSettings: NotificationAnimationModel
    
    
    // MARK: - Initializer
    init() {
        notificationSettings = notificationAPI.fetchNotificationAnimationSettings()
    }
    
    
    // MARK: - Methods
    func saveSettings() {
        // User Settings
        var userSettings = settings.fetchUserSettings()
        userSettings.GPSSpeedSetting = settings.GPSSpeedSettings[self.speedSetting]
        userSettings.GPSAccuracySetting = settings.GPSAccuracyOptions[self.accuracySetting]
        userSettings.pressureSetting = settings.altitudePressure[self.pressureSetting]
        userSettings.altitudeHeightSetting = settings.altitudeHeight[self.heightSetting]
        userSettings.graphMaxPoints = Int(self.graphMaxPoints)
        
        settings.saveUserSettings(userSettings: userSettings)
        
        // MapKit Settings
        var mapKitSettings = settings.fetchMapKitSettings()
        mapKitSettings.mapType = MapType.allCases[selectedMapType]
        mapKitSettings.showsCompass = self.showsCompass
        mapKitSettings.showsScale = self.showsScale
        mapKitSettings.showsBuildings = self.showsBuildings
        mapKitSettings.showsTraffic = self.showsTraffic
        mapKitSettings.isRotateEnabled = self.isRotateEnabled
        mapKitSettings.isScrollEnabled = self.isScrollEnabled
        mapKitSettings.zoom = self.zoom
        
        settings.saveMapKitSettings(mapKitSettings: mapKitSettings)
        
        // Show Notification
        notificationAPI.toggleNotification(type: .saved, duration: nil) { (message, show) in
            self.notificationMessage = message
            self.showNotification = show
        }
    }
    
    func discardChanges(showNotification: Bool) {
        // User Settings
        self.speedSetting = settings.GPSSpeedSettings.firstIndex(of: settings.fetchUserSettings().GPSSpeedSetting)!
        self.accuracySetting = settings.GPSAccuracyOptions.firstIndex(of: settings.fetchUserSettings().GPSAccuracySetting)!
        self.pressureSetting = settings.altitudePressure.firstIndex(of: settings.fetchUserSettings().pressureSetting)!
        self.heightSetting = settings.altitudeHeight.firstIndex(of: settings.fetchUserSettings().altitudeHeightSetting)!
        self.graphMaxPoints = Double(settings.fetchUserSettings().graphMaxPoints)
        
        // MapKit Settings
        let mapKitSettings = settings.fetchMapKitSettings()
        self.selectedMapType = MapType.allCases.firstIndex(of: settings.fetchMapKitSettings().mapType)!
        self.showsCompass = mapKitSettings.showsCompass
        self.showsScale = mapKitSettings.showsScale
        self.showsBuildings = mapKitSettings.showsBuildings
        self.showsTraffic = mapKitSettings.showsTraffic
        self.isRotateEnabled = mapKitSettings.isRotateEnabled
        self.isScrollEnabled = mapKitSettings.isScrollEnabled
        self.zoom = mapKitSettings.zoom
        
        
        // Show Notification
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
                            .font(.headline)
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
                    Text("Map")
                        .font(.headline)
                    ) {
                        Picker(selection: self.$selectedMapType, label: Text("Type")) {
                            ForEach(0 ..< MapType.allCases.count, id: \.self) {
                                Text(MapType.allCases[$0].rawValue).tag($0)
                            }
                        }
                        .accessibility(identifier: "MapType Picker")
                        
                        Toggle(isOn: self.$showsCompass) {
                            Text("Compass")
                        }.accessibility(identifier: "Compass Toggle")
                        
                        Toggle(isOn: self.$showsScale) {
                            Text("Scale")
                        }.accessibility(identifier: "Scale Toggle")
                        
                        Toggle(isOn: self.$showsBuildings) {
                            Text("Buildings")
                        }.accessibility(identifier: "Buildings Toggle")
                        
                        Toggle(isOn: self.$showsTraffic) {
                            Text("Traffic")
                        }.accessibility(identifier: "Traffic Toggle")
                        
                        Toggle(isOn: self.$isRotateEnabled) {
                            Text("Rotation")
                        }.accessibility(identifier: "Rotate Toggle")
                        
                        Toggle(isOn: self.$isScrollEnabled) {
                            Text("Scroll")
                        }.accessibility(identifier: "Scroll Toggle")
                        
                        Stepper(value: self.$zoom, in: 100...100000, step: 100) {
                            Text("Zoom: \(self.zoom / 1000, specifier: "%.1f") km")
                        }.accessibility(identifier: "Zoom Stepper")
                        HStack {
                            Text("0.1 km")
                            Slider(value: self.$zoom, in: 100...100000, step: 100)
                                .accessibility(identifier: "Zoom Slider")
                            Text("100 km")
                        }
                    }
                    
                    Section(header:
                        Text("Altitude")
                            .font(.headline)
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
                            .font(.headline)
                    ) {
                        Stepper(value: self.$graphMaxPoints, in: 1...1000, step: 1) {
                            Text("Max Points: \(Int(self.graphMaxPoints))")
                        }.accessibility(identifier: "Max Points Stepper")
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
                        Image(systemName: "xmark.circle")
                            .font(.headline)
                    }
                    .accessibility(identifier: "Close Button"), trailing:
                    HStack(spacing: 20) {
                        Button(action: {
                            self.discardChanges(showNotification: true)
                        }) {
                            Image(systemName: "gobackward")
                                .font(.headline)
                        }
                        .accessibility(identifier: "Reset Settings")
                        Button(action: {
                            self.saveSettings()
                        }) {
                            Image(systemName: "return")
                                .font(.headline)
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

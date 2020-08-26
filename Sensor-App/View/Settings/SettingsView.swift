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
        userSettings.GPSSpeedSetting = settings.GPSSpeedSettings[speedSetting]
        userSettings.GPSAccuracySetting = settings.GPSAccuracyOptions[accuracySetting]
        userSettings.pressureSetting = settings.altitudePressure[pressureSetting]
        userSettings.altitudeHeightSetting = settings.altitudeHeight[heightSetting]
        userSettings.graphMaxPoints = Int(graphMaxPoints)
        
        settings.saveUserSettings(userSettings: userSettings)
        
        // MapKit Settings
        var mapKitSettings = settings.fetchMapKitSettings()
        mapKitSettings.mapType = MapType.allCases[selectedMapType]
        mapKitSettings.showsCompass = showsCompass
        mapKitSettings.showsScale = showsScale
        mapKitSettings.showsBuildings = showsBuildings
        mapKitSettings.showsTraffic = showsTraffic
        mapKitSettings.isRotateEnabled = isRotateEnabled
        mapKitSettings.isScrollEnabled = isScrollEnabled
        mapKitSettings.zoom = zoom
        
        settings.saveMapKitSettings(mapKitSettings: mapKitSettings)
        
        // Show Notification
        notificationAPI.toggleNotification(type: .saved, duration: nil) { (message, show) in
            notificationMessage = message
            showNotification = show
        }
    }
    
    func discardChanges(_showNotification: Bool) {
        // User Settings
        speedSetting = settings.GPSSpeedSettings.firstIndex(of: settings.fetchUserSettings().GPSSpeedSetting)!
        accuracySetting = settings.GPSAccuracyOptions.firstIndex(of: settings.fetchUserSettings().GPSAccuracySetting)!
        pressureSetting = settings.altitudePressure.firstIndex(of: settings.fetchUserSettings().pressureSetting)!
        heightSetting = settings.altitudeHeight.firstIndex(of: settings.fetchUserSettings().altitudeHeightSetting)!
        graphMaxPoints = Double(settings.fetchUserSettings().graphMaxPoints)
        
        // MapKit Settings
        let mapKitSettings = settings.fetchMapKitSettings()
        selectedMapType = MapType.allCases.firstIndex(of: settings.fetchMapKitSettings().mapType)!
        showsCompass = mapKitSettings.showsCompass
        showsScale = mapKitSettings.showsScale
        showsBuildings = mapKitSettings.showsBuildings
        showsTraffic = mapKitSettings.showsTraffic
        isRotateEnabled = mapKitSettings.isRotateEnabled
        isScrollEnabled = mapKitSettings.isScrollEnabled
        zoom = mapKitSettings.zoom
        
        
        // Show Notification
        if _showNotification == true {
            notificationAPI.toggleNotification(type: .discarded, duration: nil) { (message, show) in
                notificationMessage = message
                showNotification = show
            }
        }
    }
    
    func discardView() {
        discardChanges(_showNotification: false)
        presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        discardChanges(_showNotification: false)
    }
    
    func onDisappear() {
        
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return view
        return ZStack {
            Form {
                Section(header:
                            Text("Location", comment: "SettingsView - Location Section")
                            .font(.headline)
                ) {
                    Picker(selection: $speedSetting, label: Text("Speed Setting", comment: "SettingsView - Speed Setting")) {
                        ForEach(0 ..< settings.GPSSpeedSettings.count, id: \.self) {
                            Text(settings.GPSSpeedSettings[$0]).tag($0)
                        }
                    }
                    .accessibility(identifier: "Speed Settings")
                    Picker(selection: $accuracySetting, label: Text("Accuracy", comment: "SettingsView - Accuracy")) {
                        ForEach(0 ..< settings.GPSAccuracyOptions.count, id: \.self) {
                            Text(settings.GPSAccuracyOptions[$0]).tag($0)
                        }
                    }
                    .accessibility(identifier: "GPS Accuracy Settings")
                }
                
                Section(header:
                            Text("Map", comment: "SettingsView - Map Section")
                            .font(.headline)
                ) {
                    Picker(selection: $selectedMapType, label: Text("Type", comment: "SettingsView - Type")) {
                        ForEach(0 ..< MapType.allCases.count, id: \.self) {
                            Text(MapType.allCases[$0].rawValue).tag($0)
                        }
                    }
                    .accessibility(identifier: "MapType Picker")
                    
                    Toggle(isOn: $showsCompass) {
                        Text("Compass", comment: "SettingsView - Compass") // FIXME: - Not Working
                    }.accessibility(identifier: "Compass Toggle")
                    
                    Toggle(isOn: $showsScale) {
                        Text("Scale", comment: "SettingsView - Scale")
                    }.accessibility(identifier: "Scale Toggle")
                    
                    Toggle(isOn: $showsBuildings) {
                        Text("Buildings", comment: "SettingsView - Buildings")
                    }.accessibility(identifier: "Buildings Toggle")
                    
                    Toggle(isOn: $showsTraffic) {
                        Text("Traffic", comment: "SettingsView - Traffic")
                    }.accessibility(identifier: "Traffic Toggle")
                    
                    Toggle(isOn: $isRotateEnabled) {
                        Text("Rotation", comment: "SettingsView - Rotation") // FIXME: - Not Working
                    }.accessibility(identifier: "Rotate Toggle")
                    
                    Toggle(isOn: $isScrollEnabled) {
                        Text("Scroll", comment: "SettingsView - Scroll")  // FIXME: - Not Working
                    }.accessibility(identifier: "Scroll Toggle")
                    
                    Stepper(value: $zoom, in: 100...100000, step: 100) {
                        Text("Zoom: \(zoom / 1000, specifier: "%.1f") km", comment: "SettingsView - Zoom")
                    }.accessibility(identifier: "Zoom Stepper")
                    
                    HStack {
                        Text("0.1 km" , comment: "SettingsView - 0.1km")
                        Slider(value: $zoom, in: 100...100000, step: 100)
                            .accessibility(identifier: "Zoom Slider")
                            .accessibility(label: Text("Zoom:", comment: "SettingsView - ZoomSlider"))
                            .accessibility(value: Text("\(zoom, specifier: "%.1f") km", comment: "SettingsView - ZoomSlider"))
                        Text("100 km", comment: "SettingsView - 100km")
                    }
                }
                
                Section(header:
                            Text("Altitude", comment: "SettingsView - Altitude Section")
                            .font(.headline)
                ) {
                    Picker(selection: $pressureSetting, label: Text("Pressure", comment: "SettingsView - Pressure")) {
                        ForEach(0 ..< settings.altitudePressure.count, id: \.self) {
                            Text(settings.altitudePressure[$0]).tag($0)
                        }
                    }
                    .accessibility(identifier: "Pressure Settings")
                    Picker(selection: $heightSetting, label: Text("Height", comment: "SettingsView - Height")) {
                        ForEach(0 ..< settings.altitudeHeight.count, id: \.self) {
                            Text(settings.altitudeHeight[$0]).tag($0)
                        }
                    }
                    .accessibility(identifier: "Height Settings")
                }
                
                Section(header:
                            Text("Graph", comment: "SettingsView - Graph Section")
                            .font(.headline)
                ) {
                    Stepper(value: $graphMaxPoints, in: 1...1000, step: 1) {
                        Text("Max Points: \(Int(graphMaxPoints))", comment: "SettingsView - Max Points")
                    }.accessibility(identifier: "Max Points Stepper")
                    HStack {
                        Text("1", comment: "SettingsView - 1")
                        Slider(value: $graphMaxPoints, in: 1...1000, step: 1)
                            .accessibility(identifier: "Max Points Slider")
                            .accessibility(label: Text("Maximum Points:", comment: "SettingsView - Max Points Slider"))
                            .accessibility(value: Text("\(graphMaxPoints, specifier: "%.0f")", comment: "SettingsView - Max Points Slider"))
                        Text("1000", comment: "SettingsView - 1000")
                    }
                }
            }
            .navigationBarTitle("\(NSLocalizedString("Settings", comment: "NavigationBar Title - Settings"))", displayMode: .inline)
            .navigationBarItems(trailing:
                                        HStack(spacing: 20) {
                                            Button(action: {
                                                discardChanges(_showNotification: true)
                                            }) {
                                                Image(systemName: "gobackward")
                                                    .accessibility(label: Text("Discard Changes", comment: "NagvigationBarButton - Discard Changes"))
                                                    .navigationBarItemModifier(accessibility: "Reset Settings")
                                            }
                                            Button(action: {
                                                saveSettings()
                                            }) {
                                                Image(systemName: "return")
                                                    .accessibility(label: Text("Save", comment: "NagvigationBarButton - Save"))
                                                    .navigationBarItemModifier(accessibility: "Save Settings")
                                            }
                                        })
            
            
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
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

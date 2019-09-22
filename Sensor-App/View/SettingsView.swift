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
    
    
    // MARK: - @State Variables
    @State var notificationMessage = ""
    @State var showNotification = false
    
    
    // MARK: - Initialize Classes
    
    
    // MARK: - Variables / Constants
    @State var speedSetting = SettingsAPI.shared.GPSSpeedSettings.firstIndex(of: SettingsAPI.shared.fetchSpeedSetting())!
    @State var accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.fetchGPSAccuracySetting())!
    @State var pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.fetchPressureSetting())!
    @State var heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.fetchHeightSetting())!
    let notificationSettings = NotificationAPI.shared.fetchNotificationAnimationSettings()
    
    
    // MARK: - Methods
    func saveSettings() {
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.GPSSpeedSettings[self.speedSetting], setting: SettingsForUserDefaults.GPSSpeedSetting)
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.GPSAccuracyOptions[self.accuracySetting], setting: SettingsForUserDefaults.GPSAccuracySetting)
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.altitudePressure[self.pressureSetting], setting: SettingsForUserDefaults.pressureSetting)
        SettingsAPI.shared.saveUserDefaultsString(input: SettingsAPI.shared.altitudeHeight[self.heightSetting], setting: SettingsForUserDefaults.altitudeHeightSetting)
        NotificationAPI.shared.toggleNotification(type: .saved, duration: nil) { (message, show) in
            self.notificationMessage = message
            self.showNotification = show
        }
    }
    
    func discardChanges(showNotification: Bool) {
        self.speedSetting = SettingsAPI.shared.GPSSpeedSettings.firstIndex(of: SettingsAPI.shared.fetchSpeedSetting())!
        self.accuracySetting = SettingsAPI.shared.GPSAccuracyOptions.firstIndex(of: SettingsAPI.shared.fetchGPSAccuracySetting())!
        self.pressureSetting = SettingsAPI.shared.altitudePressure.firstIndex(of: SettingsAPI.shared.fetchPressureSetting())!
        self.heightSetting = SettingsAPI.shared.altitudeHeight.firstIndex(of: SettingsAPI.shared.fetchHeightSetting())!
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
                        Picker(selection: self.$accuracySetting, label: Text("Accuracy")) {
                            ForEach(0 ..< SettingsAPI.shared.GPSAccuracyOptions.count, id: \.self) {
                                Text(SettingsAPI.shared.GPSAccuracyOptions[$0]).tag($0)
                            }
                        }
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
                        Picker(selection: self.$heightSetting, label: Text("Height")) {
                            ForEach(0 ..< SettingsAPI.shared.altitudeHeight.count, id: \.self) {
                                Text(SettingsAPI.shared.altitudeHeight[$0]).tag($0)
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("Settings"), displayMode: .inline)
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarItems(leading:
                    Button(action: {
                        self.discardView()
                    }) {
                        Image(systemName: "clear")//Image("CancelButton")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }, trailing:
                    HStack {
                        Button(action: {
                            self.discardChanges(showNotification: true)
                        }) {
                            Image(systemName: "gobackward")//Image("UndoButton")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        Button(action: {
                            self.saveSettings()
                        }) {
                            Image("SaveButton")//Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            
            
            // MARK: - NotificationViewModel()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
    }
}


// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView().previewDevice("iPhone 11 Pro")
            SettingsView().previewDevice("iPhone 11 Pro")
                .environment(\.colorScheme, .dark)
            //SettingsView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //SettingsView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}

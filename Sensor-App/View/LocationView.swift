//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct LocationView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State / @ObservedObject
    @ObservedObject var locationVM = CoreLocationViewModel()
    
    // Show Graph
    @State private var showLatitude = false
    @State private var showLongitude = false
    @State private var showAltitude = false
    @State private var showDirection = false
    @State private var showSpeed = false
    
    // Notification Variables
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = NotificationAPI.shared.fetchNotificationAnimationSettings().duration
    
    
    // MARK: - Define Constants / Variables
    let notificationSettings = NotificationAPI.shared.fetchNotificationAnimationSettings()
    
    
    // MARK: - Methods
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating location
        locationVM.locationUpdateStart()
    }
    
    func onDisappear() {
        CoreLocationAPI.shared.stopUpdatingGPS()
        locationVM.coreLocationArray.removeAll()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return ZStack {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: SettingsAPI.shared.backgroundColor), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    GeometryReader { g in
                        VStack {
                            ScrollView {
                                Spacer()
                                Group{
                                    Text("Latitude: \(self.locationVM.coreLocationArray.last?.latitude ?? 0.0, specifier: "%.6f")° ± \(self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showLatitude.toggle() }) {
                                            Image("GraphButton")
                                                .foregroundColor(.white)
                                                .offset(x: -10)
                                        }.accessibility(identifier: "Toggle Latitude Graph"), alignment: .trailing)
                                    
                                    if self.showLatitude == true {
                                        Spacer()
                                        LineGraphSubView(locationVM: self.locationVM, showGraph: .latitude)
                                            .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                        Spacer()
                                    }
                                    
                                    Text("Longitude: \(self.locationVM.coreLocationArray.last?.longitude ?? 0.0, specifier: "%.6f")° ± \(self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showLongitude.toggle() }) {
                                            Image("GraphButton")
                                                .foregroundColor(.white)
                                                .offset(x: -10)
                                        }.accessibility(identifier: "Toggle Longitude Graph"), alignment: .trailing)
                                    
                                    if self.showLongitude == true {
                                        Spacer()
                                        LineGraphSubView(locationVM: self.locationVM, showGraph: .longitude)
                                            .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                        Spacer()
                                    }
                                    
                                    Text("Altitude: \(self.locationVM.coreLocationArray.last?.altitude ?? 0.0, specifier: "%.2f") ± \(self.locationVM.coreLocationArray.last?.verticalAccuracy ?? 0.0, specifier: "%.2f")m")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showAltitude.toggle() }) {
                                            Image("GraphButton")
                                                .foregroundColor(.white)
                                                .offset(x: -10)
                                        }.accessibility(identifier: "Toggle Altitude Graph"), alignment: .trailing)
                                    
                                    if self.showAltitude == true {
                                        Spacer()
                                        LineGraphSubView(locationVM: self.locationVM, showGraph: .altitude)
                                            .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                        Spacer()
                                    }
                                    
                                    Text("Direction: \(self.locationVM.coreLocationArray.last?.course ?? 0.0, specifier: "%.2f")°")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showDirection.toggle() }) {
                                            Image("GraphButton")
                                                .foregroundColor(.white)
                                                .offset(x: -10)
                                        }.accessibility(identifier: "Toggle Direction Graph"), alignment: .trailing)
                                    
                                    if self.showDirection == true {
                                        Spacer()
                                        LineGraphSubView(locationVM: self.locationVM, showGraph: .course)
                                            .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                        Spacer()
                                    }
                                    
                                    Text("Speed: \(CalculationAPI.shared.calculateSpeed(ms: self.locationVM.coreLocationArray.last?.speed ?? 0.0, to: "\(SettingsAPI.shared.fetchSpeedSetting())"), specifier: "%.2f")\(SettingsAPI.shared.fetchSpeedSetting())")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showSpeed.toggle() }) {
                                            Image("GraphButton")
                                                .foregroundColor(.white)
                                                .offset(x: -10)
                                            }.accessibility(identifier: "Toggle Speed Graph"), alignment: .trailing)
                                    
                                    if self.showSpeed == true {
                                        Spacer()
                                        LineGraphSubView(locationVM: self.locationVM, showGraph: .speed)
                                            .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                        Spacer()
                                    }
                                }
                                .frame(height: 50, alignment: .center)
                                .offset(x: 5)
                                Spacer()
                                MapKitView(latitude: self.locationVM.coreLocationArray.last?.latitude ?? 37.3323314100, longitude: self.locationVM.coreLocationArray.last?.longitude ?? -122.0312186000)
                                    .frame(width: g.size.width - 10, height: g.size.width - 10, alignment: .center)
                                    .cornerRadius(10)
                            }
                            .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                            
                            
                            // MARK: - LocationToolBarViewModel()
                            LocationToolBarView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification, notificationDuration: self.$notificationDuration)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    .navigationBarTitle("Location", displayMode: .inline)
                    .navigationBarHidden(true)
                }
            }
            .navigationBarTitle("Location", displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
    }
}


// MARK: - Preview
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                LocationView()
                    .colorScheme(scheme)
            }
        }
    }
}

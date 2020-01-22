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
                                
                                LineGraphImplementation(locationVM: self.locationVM)
                                    .frame(width: g.size.width, height: 400, alignment: .center)
                                
                                
                                Spacer()
                                Group{
                                    Text("Latitude: \(self.locationVM.coreLocationArray.last?.latitude ?? 0.0, specifier: "%.10f")° ± \(self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m")
                                        .modifier(ButtonModifier())
                                    Text("Longitude: \(self.locationVM.coreLocationArray.last?.longitude ?? 0.0, specifier: "%.10f")° ± \(self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m")
                                        .modifier(ButtonModifier())
                                    Text("Altitude: \(self.locationVM.coreLocationArray.last?.altitude ?? 0.0, specifier: "%.2f") ± \(self.locationVM.coreLocationArray.last?.verticalAccuracy ?? 0.0, specifier: "%.2f")m")
                                        .modifier(ButtonModifier())
                                    Text("Direction: \(self.locationVM.coreLocationArray.last?.course ?? 0.0, specifier: "%.2f")°")
                                        .modifier(ButtonModifier())
                                    Text("Speed: \(CalculationAPI.shared.calculateSpeed(ms: self.locationVM.coreLocationArray.last?.speed ?? 0.0, to: "\(SettingsAPI.shared.fetchSpeedSetting())"), specifier: "%.2f")\(SettingsAPI.shared.fetchSpeedSetting())")
                                        .modifier(ButtonModifier())
                                }
                                .frame(height: 50, alignment: .center)
                                .offset(x: 5)
                                Spacer()
                                MapKitView(latitude: self.locationVM.coreLocationArray.last?.latitude ?? 37.3323314100, longitude: self.locationVM.coreLocationArray.last?.longitude ?? -122.0312186000)
                                    .frame(width: g.size.width - 10, height: g.size.width - 10, alignment: .center)
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

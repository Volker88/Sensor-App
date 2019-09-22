//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI
import Combine


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
                                Spacer()
                                Group{
                                    ButtonView(type: .latitude, text: "Latitude:", locationVM: self.locationVM)
                                        .frame(height: 50, alignment: .center)
                                    Spacer()
                                    ButtonView(type: .longitude, text: "Longitude:", locationVM: self.locationVM)
                                        .frame(height: 50, alignment: .center)
                                    Spacer()
                                    ButtonView(type: .altitude, text: "Altitude:", locationVM: self.locationVM)
                                        .frame(height: 50, alignment: .center)
                                    Spacer()
                                    ButtonView(type: .course, text: "Direction:", locationVM: self.locationVM)
                                        .frame(height: 50, alignment: .center)
                                    Spacer()
                                    ButtonView(type: .speed, text: "Speed:", locationVM: self.locationVM)
                                        .frame(height: 50, alignment: .center)
                                }
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
                    //.background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
                }
            }
            .navigationBarTitle("Location", displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            
            
            // MARK: - NotificationViewModel()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
    }
}


// MARK: - Preview
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                LocationView().previewDevice("iPhone 11 Pro")
            }
            NavigationView {
                LocationView().previewDevice("iPhone 11 Pro")
                    .environment(\.colorScheme, .dark)
            }
            //LocationView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //LocationView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}

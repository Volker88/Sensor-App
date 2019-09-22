//
//  AltitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AltitudeView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State / @ObservedObject
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency: Float = SettingsAPI.shared.fetchFrequency() // Default Frequency
    
    // Notification Variables
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = NotificationAPI.shared.fetchNotificationAnimationSettings().duration
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating motion
        motionVM.altitudeUpdateStart()
    }
    
    func onDisappear() {
        CoreMotionAPI.shared.motionUpdateStart()
        motionVM.coreMotionArray.removeAll()
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
                        VStack{
                            ScrollView(.vertical) {
                                Spacer()
                                VStack{
                                    Group{
                                        ButtonView(type: .pressureValue, text: "Pressure:", motionVM: self.motionVM)
                                            .frame(height: 50, alignment: .center)
                                        Spacer()
                                        ButtonView(type: .relativeAltitudeValue, text: "Altitude change:", motionVM: self.motionVM)
                                            .frame(height: 50, alignment: .center)
                                    }
                                    Spacer()
                                    
                                    
                                    // MARK: - ListView
                                    MotionListView(type: .altitude, motionVM: self.motionVM)
                                        .frame(minHeight: 250, maxHeight: .infinity)
                                }
                            }
                            .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                            
                            
                            // MARK: - MotionToolBarViewModel()
                            MotionToolBarView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification, notificationDuration: self.$notificationDuration, motionVM: self.motionVM)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }
                .navigationBarTitle(Text("Altitude"), displayMode: .inline)
                .navigationBarHidden(true)
                //.background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
            }
            .navigationBarTitle("Altitude", displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            
            
            // MARK: - NotificationViewModel()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
    }
}

// MARK: - Preview
struct AltitudeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView{
                AltitudeView().previewDevice("iPhone 11 Pro")
            }
            NavigationView{
                AltitudeView().previewDevice("iPhone 11 Pro")
                    .environment(\.colorScheme, .dark)
            }
            //AltitudeView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //AltitudeView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
            
        }
    }
}

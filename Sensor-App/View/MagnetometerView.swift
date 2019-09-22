//
//  MagnetometerView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct MagnetometerView: View {
    
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
        motionVM.motionUpdateStart()
    }
    
    func onDisappear() {
        CoreMotionAPI.shared.motionUpdateStop()
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
                    GeometryReader { geometry in
                        VStack{
                            ScrollView(.vertical) {
                                Spacer()
                                VStack{
                                    Group{
                                        ButtonView(type: .magnetometerXAxis, text: "X-Axis:", motionVM: self.motionVM)
                                            .frame(height: 50, alignment: .center)
                                        Spacer()
                                        ButtonView(type: .magnetometerYAxis, text: "Y-Axis:", motionVM: self.motionVM)
                                            .frame(height: 50, alignment: .center)
                                        Spacer()
                                        ButtonView(type: .magnetometerZAxis, text: "Z-Axis:", motionVM: self.motionVM)
                                            .frame(height: 50, alignment: .center)
                                    }
                                    
                                    
                                    // MARK: - ListView
                                    MotionListView(type: .magnetometer, motionVM: self.motionVM)
                                        .frame(minHeight: 250, maxHeight: .infinity)
                                    Spacer()
                                    
                                    
                                    // MARK: - RefreshRateViewModel()
                                    RefreshRateView()
                                        .frame(height: CGFloat(165))
                                    Spacer()
                                }
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height - 50 + geometry.safeAreaInsets.bottom)
                            
                            
                            // MARK: - MotionToolBarViewModel()
                            MotionToolBarView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification, notificationDuration: self.$notificationDuration, motionVM: self.motionVM)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }
                .navigationBarTitle(Text("Magnetometer"), displayMode: .inline)
                .navigationBarHidden(true)
                //.background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
            }
            .navigationBarTitle("Magnetometer", displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            
            // MARK: - NotificationViewModel()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
    }
}

// MARK: - Preview
struct MagnetometerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                MagnetometerView().previewDevice("iPhone 11 Pro")
            }
            NavigationView {
                MagnetometerView().previewDevice("iPhone 11 Pro")
                    .environment(\.colorScheme, .dark)
            }
            //MagnetometerView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //MagnetometerView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}
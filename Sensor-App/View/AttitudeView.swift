//
//  AttitudeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AttitudeView: View {
    
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
        CoreLocationAPI.shared.stopUpdatingGPS()
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
                                        Text("Roll: \((self.motionVM.coreMotionArray.last?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                                        .modifier(ButtonModifier())
                                        Text("Pitch: \((self.motionVM.coreMotionArray.last?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                                        .modifier(ButtonModifier())
                                        Text("Yaw: \((self.motionVM.coreMotionArray.last?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                                        .modifier(ButtonModifier())
                                        Text("Heading: \(self.motionVM.coreMotionArray.last?.attitudeHeading ?? 0.0, specifier: "%.5f")°")
                                        .modifier(ButtonModifier())
                                    }
                                    .frame(height: 50, alignment: .center)
                                    
                                    
                                    // MARK: - ListView
                                    MotionListView(type: .attitude, motionVM: self.motionVM)
                                        .frame(minHeight: 250, maxHeight: .infinity)
                                    
                                    
                                    // MARK: - RefreshRateViewModel()
                                    RefreshRateView()
                                        .frame(height: CGFloat(165))
                                }
                            }
                            .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                            
                            
                            // MARK: - MotionToolBarViewModel()
                            MotionToolBarView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification, notificationDuration: self.$notificationDuration, motionVM: self.motionVM)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }
                .navigationBarTitle(Text("Attitude"), displayMode: .inline)
                .navigationBarHidden(true)
            }
            .navigationBarTitle("Attitude", displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            
            
            // MARK: - NotificationViewModel()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
    }
}

// MARK: - Preview
struct AttitudeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AttitudeView().previewDevice("iPhone 11 Pro")
            }
            NavigationView {
                AttitudeView().previewDevice("iPhone 11 Pro")
                    .environment(\.colorScheme, .dark)
            }
            //AttitudeView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //AttitudeView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}

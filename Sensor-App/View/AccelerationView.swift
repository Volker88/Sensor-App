//
//  AccelerationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct AccelerationView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State / @ObservedObject
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency: Float = SettingsAPI.shared.fetchFrequency() // Default Frequency
    
    // Show Graph
    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false
    
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
                    GeometryReader { g in
                        VStack{
                            ScrollView(.vertical) {
                                Spacer()
                                VStack{
                                    Group{
                                        Text("X-Axis: \(self.motionVM.coreMotionArray.last?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2")
                                            .modifier(ButtonModifier())
                                            .overlay(Button(action: { self.showXAxis.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }, alignment: .trailing)
                                        
                                        if self.showXAxis == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .accelerationXAxis)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                        
                                        Text("Y-Axis: \(self.motionVM.coreMotionArray.last?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2")
                                            .modifier(ButtonModifier())
                                            .overlay(Button(action: { self.showYAxis.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }, alignment: .trailing)
                                        
                                        if self.showYAxis == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .accelerationYAxis)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                        
                                        Text("Z-Axis: \(self.motionVM.coreMotionArray.last?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2")
                                            .modifier(ButtonModifier())
                                            .overlay(Button(action: { self.showZAxis.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }, alignment: .trailing)
                                        
                                        if self.showZAxis == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .accelerationZAxis)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 50, alignment: .center)
                                    
                                    
                                    // MARK: - MotionListView()
                                    MotionListView(type: .acceleration, motionVM: self.motionVM)
                                        .frame(minHeight: 250, maxHeight: .infinity)
                                    
                                    
                                    // MARK: - RefreshRateView()
                                    RefreshRateView()
                                        .frame(width: g.size.width, height: 170, alignment: .center)
                                }
                            }
                            .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                            .offset(x: 5)
                            
                            
                            // MARK: - MotionToolBarView()
                            MotionToolBarView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification, notificationDuration: self.$notificationDuration, motionVM: self.motionVM)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    .navigationBarTitle(Text("Acceleration"), displayMode: .inline)
                    .navigationBarHidden(true)
                }
            }
            .navigationBarTitle("Acceleration", displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
    }
}


// MARK: - Preview
struct AccelerationView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AccelerationView()
                    .colorScheme(scheme)
            }
        }
    }
}

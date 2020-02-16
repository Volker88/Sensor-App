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
    @State private var frequency = SettingsAPI.shared.fetchUserSettings().frequencySetting // Default Frequency
    @State private var showSettings = false
    @State private var toolBarButtonType: ToolBarButtonType = .play
    
    // Show Graph
    @State private var showRoll = false
    @State private var showPitch = false
    @State private var showYaw = false
    @State private var showHeading = false
    
    // Notification Variables
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = NotificationAPI.shared.fetchNotificationAnimationSettings().duration
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    func toolBarButtonTapped() {
        var messageType: NotificationTypes?
        
        switch toolBarButtonType {
            case .play:
                motionVM.motionUpdateStart()
                messageType = .played
            case .pause:
                CoreMotionAPI.shared.motionUpdateStop()
                messageType = .paused
            case .delete:
                self.motionVM.coreMotionArray.removeAll()
                self.motionVM.altitudeArray.removeAll()
                messageType = .deleted
            case .settings:
                showSettings.toggle()
                messageType = nil
        }
        
        if messageType != nil {
            NotificationAPI.shared.toggleNotification(type: messageType!, duration: self.notificationDuration) { (message, show) in
                self.notificationMessage = message
                self.showNotification = show
            }
        }
    }
    
    
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
                                        Text("Roll: \((self.motionVM.coreMotionArray.last?.attitudeRoll ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showRoll.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }.accessibility(identifier: "Toggle Roll Graph"), alignment: .trailing)
                                        
                                        if self.showRoll == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudeRoll)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                        
                                        Text("Pitch: \((self.motionVM.coreMotionArray.last?.attitudePitch ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showPitch.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }.accessibility(identifier: "Toggle Pitch Graph"), alignment: .trailing)
                                        
                                        if self.showPitch == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudePitch)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                        
                                        Text("Yaw: \((self.motionVM.coreMotionArray.last?.attitudeYaw ?? 0.0) * 180 / .pi, specifier: "%.5f")°")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showYaw.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }.accessibility(identifier: "Toggle Yaw Graph"), alignment: .trailing)
                                        
                                        if self.showYaw == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudeYaw)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                        
                                        Text("Heading: \(self.motionVM.coreMotionArray.last?.attitudeHeading ?? 0.0, specifier: "%.5f")°")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showHeading.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }.accessibility(identifier: "Toggle Heading Graph"), alignment: .trailing)
                                        
                                        if self.showHeading == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .attitudeHeading)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 50, alignment: .center)
                                    
                                    
                                    // MARK: - MotionListView()
                                    MotionListView(type: .attitude, motionVM: self.motionVM)
                                        .frame(minHeight: 250, maxHeight: .infinity)
                                    
                                    
                                    // MARK: - RefreshRateViewModel()
                                    RefreshRateView()
                                        .frame(width: g.size.width, height: 170, alignment: .center)
                                }
                            }
                            .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                            .offset(x: 5)
                            
                            
                            // MARK: - MotionToolBarView()
                            ToolBarView(toolBarButtonType: self.$toolBarButtonType, toolBarFunctionClosure: self.toolBarButtonTapped)
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
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}


// MARK: - Preview
struct AttitudeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AttitudeView()
                    .colorScheme(scheme)
            }
        }
    }
}

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
    @State private var showSettings = false
    @State private var toolBarButtonType: ToolBarButtonType = .play
    @State private var motionIsUpdating = true
    
    // Show Graph
    @State private var showPressure = false
    @State private var showRelativeAltidudeChange = false
    
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
                motionVM.altitudeUpdateStart()
                motionIsUpdating = true
                messageType = .played
            case .pause:
                CoreMotionAPI.shared.motionUpdateStop()
                motionIsUpdating = false
                messageType = .paused
            case .delete:
                self.motionVM.coreMotionArray.removeAll()
                self.motionVM.altitudeArray.removeAll()
                if motionIsUpdating == true {
                    CoreMotionAPI.shared.motionUpdateStop()
                    motionVM.altitudeUpdateStart()
                }
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
        motionVM.altitudeUpdateStart()
    }
    
    func onDisappear() {
        CoreMotionAPI.shared.motionUpdateStop()
        motionVM.altitudeArray.removeAll()
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
                                        Text("Pressure: \(CalculationAPI.shared.calculatePressure(pressure: self.motionVM.altitudeArray.last?.pressureValue ?? 0.0, to: SettingsAPI.shared.fetchPressureSetting()), specifier: "%.5f") \(SettingsAPI.shared.fetchPressureSetting())")
                                            .modifier(ButtonModifier())
                                            .overlay(Button(action: { self.showPressure.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }.accessibility(identifier: "Toggle Pressure Graph"), alignment: .trailing)
                                        
                                        if self.showPressure == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .pressureValue)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                        
                                        Text("Altitude change: \(CalculationAPI.shared.calculateHeight(height: self.motionVM.altitudeArray.last?.relativeAltitudeValue ?? 0.0, to: SettingsAPI.shared.fetchHeightSetting()), specifier: "%.5f") \(SettingsAPI.shared.fetchHeightSetting())")
                                            .modifier(ButtonModifier())
                                            .overlay(Button(action: { self.showRelativeAltidudeChange.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }.accessibility(identifier: "Toggle Altitude Graph"), alignment: .trailing)
                                        
                                        if self.showRelativeAltidudeChange == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .relativeAltitudeValue)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 50, alignment: .center)
                                    
                                    
                                    // MARK: - MotionListView()
                                    MotionListView(type: .altitude, motionVM: self.motionVM)
                                        .frame(minHeight: 250, maxHeight: .infinity)
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
                .navigationBarTitle(Text("Altitude"), displayMode: .inline)
                .navigationBarHidden(true)
            }
            .navigationBarTitle("Altitude", displayMode: .inline)
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
struct AltitudeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                AltitudeView()
                    .colorScheme(scheme)
            }
        }
    }
}

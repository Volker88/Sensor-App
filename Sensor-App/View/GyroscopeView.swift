//
//  GyroscopeView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct GyroscopeView: View {
    
    // MARK: - Initialize Classes
    let locationAPI = CoreLocationAPI()
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    let notificationAPI = NotificationAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0
    @State private var showSettings = false
    @State private var toolBarButtonType: ToolBarButtonType = .play
    
    // Show Graph
    @State private var showXAxis = false
    @State private var showYAxis = false
    @State private var showZAxis = false
    
    // Notification Variables
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Initializer
    init() {
        frequency = settings.fetchUserSettings().frequencySetting
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }
    
    
    // MARK: - Methods
    func toolBarButtonTapped() {
        var messageType: NotificationTypes?
        
        switch toolBarButtonType {
            case .play:
                motionVM.motionUpdateStart()
                messageType = .played
            case .pause:
                motionVM.stopMotionUpdates()
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
            notificationAPI.toggleNotification(type: messageType!, duration: self.notificationDuration) { (message, show) in
                self.notificationMessage = message
                self.showNotification = show
            }
        }
    }
    
    func updateSensorInterval() {
        motionVM.sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating motion
        motionVM.motionUpdateStart()
    }
    
    func onDisappear() {
        motionVM.stopMotionUpdates()
        motionVM.coreMotionArray.removeAll()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return ZStack {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: settings.backgroundColor), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    GeometryReader { g in
                        VStack{
                            ScrollView(.vertical) {
                                Spacer()
                                VStack{
                                    Group{
                                        Text("X-Axis: \(self.motionVM.coreMotionArray.last?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showXAxis.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }.accessibility(identifier: "Toggle X-Axis Graph"), alignment: .trailing)
                                        
                                        if self.showXAxis == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .gyroXAxis)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                        
                                        Text("Y-Axis: \(self.motionVM.coreMotionArray.last?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showYAxis.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }.accessibility(identifier: "Toggle Y-Axis Graph"), alignment: .trailing)
                                        
                                        if self.showYAxis == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .gyroYAxis)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                        
                                        Text("Z-Axis: \(self.motionVM.coreMotionArray.last?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s")
                                        .modifier(ButtonModifier())
                                        .overlay(Button(action: { self.showZAxis.toggle() }) {
                                                Image("GraphButton")
                                                    .foregroundColor(.white)
                                                    .offset(x: -10)
                                            }.accessibility(identifier: "Toggle Z-Axis Graph"), alignment: .trailing)
                                        
                                        if self.showZAxis == true {
                                            Spacer()
                                            LineGraphSubView(motionVM: self.motionVM, showGraph: .gyroZAxis)
                                                .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                            Spacer()
                                        }
                                    }
                                    .frame(height: 50, alignment: .center)
                                    
                                    
                                    // MARK: - MotionListView()
                                    MotionListView(type: .gyroscope, motionVM: self.motionVM)
                                        .frame(minHeight: 250, maxHeight: .infinity)
                                    
                                    
                                    // MARK: - RefreshRateViewModel()
                                    RefreshRateView(updateSensorInterval: { self.updateSensorInterval() })
                                        .frame(width: g.size.width, height: 170, alignment: .center)
                                }
                            }
                            .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                            .offset(x: 5)
                            
                            
                            // MARK: - MotionToolBarViewModel()
                            ToolBarView(toolBarButtonType: self.$toolBarButtonType, toolBarFunctionClosure: self.toolBarButtonTapped)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }
                .navigationBarTitle(Text("Gyroscope"), displayMode: .inline)
                .navigationBarHidden(true)
            }
            .navigationBarTitle("Gyroscope", displayMode: .inline)
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
struct GyroscopeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                GyroscopeView()
                    .colorScheme(scheme)
            }
        }
    }
}

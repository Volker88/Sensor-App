//
//  GravityView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct GravityView: View {
    
    // MARK: - Initialize Classes
    let locationAPI = CoreLocationAPI()
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    let notificationAPI = NotificationAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0
    @State private var showSettings = false
    
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
    func toolBarButtonTapped(button: ToolBarButtonType) {
        var messageType: NotificationTypes?
        
        switch button {
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
                motionVM.stopMotionUpdates()
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
            LinearGradient(gradient: Gradient(colors: settings.backgroundColor), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Color("ToolbarBackgroundColor")
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .edgesIgnoringSafeArea(.all)
            
            GeometryReader { g in
                VStack{
                    ScrollView(.vertical) {
                        Spacer()
                        VStack{
                            Group{
                                Text("X-Axis: \(self.motionVM.coreMotionArray.last?.gravityXAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - X-Axis")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showXAxis.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle X-Axis Graph")
                                    }, alignment: .trailing)
                                
                                if self.showXAxis == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .gravityXAxis)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Y-Axis: \(self.motionVM.coreMotionArray.last?.gravityYAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Y-Axis")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showYAxis.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Y-Axis Graph")
                                    }, alignment: .trailing)
                                
                                if self.showYAxis == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .gravityYAxis)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Z-Axis: \(self.motionVM.coreMotionArray.last?.gravityZAxis ?? 0.0, specifier: "%.5f") g (9,81 m/s^2)", comment: "GravityView - Z-Axis")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showZAxis.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Z-Axis Graph")
                                    }, alignment: .trailing)
                                
                                if self.showZAxis == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .gravityZAxis)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .frame(height: 50, alignment: .center)
                            
                            
                            // MARK: - MotionListView()
                            MotionListView(type: .gravity, motionVM: self.motionVM)
                                .frame(minHeight: 250, maxHeight: .infinity)
                            
                            
                            // MARK: - RefreshRateView()
                            RefreshRateView(updateSensorInterval: { self.updateSensorInterval() })
                                .frame(width: g.size.width, height: 170, alignment: .center)
                            Spacer(minLength: 20)
                        }
                    }
                    .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                    .offset(x: 5)
                    
                    
                    // MARK: - MotionToolBarView()
                    ToolBarView(toolBarFunctionClosure: self.toolBarButtonTapped(button:))
                }
            }
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
        }
        .navigationBarTitle("\(NSLocalizedString("Gravity", comment: "NavigationBar Title - Gravity"))", displayMode: .inline)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .sheet(isPresented: $showSettings) { SettingsView() }
    }
}


// MARK: - Preview
struct GravityView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                GravityView()
                    .colorScheme(scheme)
            }
        }
    }
}

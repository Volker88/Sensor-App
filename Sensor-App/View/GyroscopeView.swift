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
    let exportAPI = ExportAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0
    @State private var sideBarOpen: Bool = false
    @State private var showShareSheet = false
    @State private var filesToShare = [Any]()
    
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
            case .share:
                shareCSV()
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
    
    func shareCSV() {
        motionVM.stopMotionUpdates()
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Gyroscope") + "\n"
        
        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.gyroXAxis.localizedDecimal());\($0.gyroYAxis.localizedDecimal());\($0.gyroZAxis.localizedDecimal())\n"
        }
        filesToShare = exportAPI.getFile(exportText: csvText, filename: "gyroscope")
        self.showShareSheet.toggle()
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
    
    
    // MARK: - Content
    #warning("Can not call button on high frequency")
    var sideBarButton: some View {
        Button(action: {
            sideBarOpen.toggle()
            if sideBarOpen {
                motionVM.stopMotionUpdates()
            } else {
                motionVM.motionUpdateStart()
            }
        }) {
            Image(systemName: "sidebar.left")
        }
    }
    
    
    // MARK: - Body - View
    @ViewBuilder
    var body: some View {
        
        // MARK: - Return View
        ZStack {
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
                                Text("X-Axis: \(self.motionVM.coreMotionArray.last?.gyroXAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyrsocopeView - X-Axis")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showXAxis.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle X-Axis Graph")
                                    }, alignment: .trailing)
                                
                                if self.showXAxis == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .gyroXAxis)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Y-Axis: \(self.motionVM.coreMotionArray.last?.gyroYAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyrsocopeView - Y-Axis")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showYAxis.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Y-Axis Graph")
                                    }, alignment: .trailing)
                                
                                if self.showYAxis == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .gyroYAxis)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Z-Axis: \(self.motionVM.coreMotionArray.last?.gyroZAxis ?? 0.0, specifier: "%.5f") rad/s", comment: "GyrsocopeView - Z-Axis")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showZAxis.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Z-Axis Graph")
                                    }, alignment: .trailing)
                                
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
                            Spacer(minLength: 20)
                        }
                    }
                    .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                    .offset(x: 5)
                }
            }
            .customToolBar(toolBarFunctionClosure: self.toolBarButtonTapped(button:))
            
            
            // MARK: - SidebarMenu
            SidebarMenu(sidebarOpen: $sideBarOpen)
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)  
        }
        .navigationBarItems(leading: sideBarButton)
        .navigationBarTitle("\(NSLocalizedString("Gyroscope", comment: "NavigationBar Title - Gyroscope"))", displayMode: .inline)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .sheet(isPresented: $showShareSheet) { ShareSheet(activityItems: self.filesToShare) }
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

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
    let locationAPI = CoreLocationAPI()
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    let notificationAPI = NotificationAPI()
    let exportAPI = ExportAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var motionVM = CoreMotionViewModel()
    @State private var frequency = 1.0
    @State private var sideBarOpen: Bool = false
    @State private var motionIsUpdating = true
    @State private var showShareSheet = false
    @State private var filesToShare = [Any]()
    
    // Show Graph
    @State private var showPressure = false
    @State private var showRelativeAltidudeChange = false
    
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
                motionVM.altitudeUpdateStart()
                motionIsUpdating = true
                messageType = .played
            case .pause:
                motionVM.stopMotionUpdates()
                motionIsUpdating = false
                messageType = .paused
            case .share:
                shareCSV()
            case .delete:
                self.motionVM.coreMotionArray.removeAll()
                self.motionVM.altitudeArray.removeAll()
                if motionIsUpdating == true {
                    motionVM.stopMotionUpdates()
                    motionVM.altitudeUpdateStart()
                }
                messageType = .deleted
        }
        
        if messageType != nil {
            notificationAPI.toggleNotification(type: messageType!, duration: self.notificationDuration) { (message, show) in
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
        motionVM.stopMotionUpdates()
        motionVM.altitudeArray.removeAll()
    }
    
    func shareCSV() {
        motionVM.stopMotionUpdates()
        var csvText = NSLocalizedString("ID;Time;Pressure;Altitude change", comment: "Export CSV Headline - altitude") + "\n"
        
        _ = motionVM.altitudeArray.map {
            csvText += "\($0.counter);\($0.timestamp);\(self.calculationAPI.calculatePressure(pressure: $0.pressureValue, to: self.settings.fetchUserSettings().pressureSetting).localizedDecimal());\(self.calculationAPI.calculateHeight(height: $0.relativeAltitudeValue, to: self.settings.fetchUserSettings().altitudeHeightSetting).localizedDecimal())\n"
        }
        filesToShare = exportAPI.getFile(exportText: csvText, filename: "altitude")
        self.showShareSheet.toggle()
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
                                Text("Pressure: \(self.calculationAPI.calculatePressure(pressure: self.motionVM.altitudeArray.last?.pressureValue ?? 0.0, to: self.settings.fetchUserSettings().pressureSetting), specifier: "%.5f") \(self.settings.fetchUserSettings().pressureSetting)", comment: "AltitudeView - Pressure")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showPressure.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Pressure Graph")
                                    }, alignment: .trailing)
                                
                                if self.showPressure == true {
                                    Spacer()
                                    LineGraphSubView(motionVM: self.motionVM, showGraph: .pressureValue)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Altitude change: \(self.calculationAPI.calculateHeight(height: self.motionVM.altitudeArray.last?.relativeAltitudeValue ?? 0.0, to: self.settings.fetchUserSettings().altitudeHeightSetting), specifier: "%.5f") \(self.settings.fetchUserSettings().altitudeHeightSetting)", comment: "AltitudeView - Altitude")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showRelativeAltidudeChange.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Altitude Graph")
                                    }, alignment: .trailing)
                                
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
        .navigationBarTitle("\(NSLocalizedString("Altitude", comment: "NavigationBar Title - Altitude"))", displayMode: .inline)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .sheet(isPresented: $showShareSheet) { ShareSheet(activityItems: self.filesToShare) }
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

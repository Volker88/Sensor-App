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
                motionVM.coreMotionArray.removeAll()
                motionVM.altitudeArray.removeAll()
                messageType = .deleted
            case .share:
                shareCSV()
        }
        
        if messageType != nil {
            notificationAPI.toggleNotification(type: messageType!, duration: notificationDuration) { (message, show) in
                notificationMessage = message
                showNotification = show
            }
        }
    }
    
    func updateSensorInterval() {
        motionVM.sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }
    
    func shareCSV() {
        motionVM.stopMotionUpdates()
        var csvText = NSLocalizedString("ID;Time;X-Axis;Y-Axis;Z-Axis", comment: "Export CSV Headline - Acceleration") + "\n"
        
        _ = motionVM.coreMotionArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.accelerationXAxis.localizedDecimal());\($0.accelerationYAxis.localizedDecimal());\($0.accelerationZAxis.localizedDecimal())\n"
        }
        filesToShare = exportAPI.getFile(exportText: csvText, filename: "acceleration")
        showShareSheet.toggle()
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
            GeometryReader { g in
                ScrollView {
                    List {
                        Section(header: Text("Acceleration", comment: "AccelerationView - Section Header")) {
                            DisclosureGroup(
                                isExpanded: $showXAxis,
                                content: {
                                    LineGraphSubView(motionVM: motionVM, showGraph: .accelerationXAxis)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("X-Axis: \(motionVM.coreMotionArray.last?.accelerationXAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - X-Axis")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle X-Axis Graph")
                            
                            DisclosureGroup(
                                isExpanded: $showYAxis,
                                content: {
                                    LineGraphSubView(motionVM: motionVM, showGraph: .accelerationXAxis)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Y-Axis: \(motionVM.coreMotionArray.last?.accelerationYAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Y-Axis")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Y-Axis Graph")
                            
                            DisclosureGroup(
                                isExpanded: $showZAxis,
                                content: {
                                    LineGraphSubView(motionVM: motionVM, showGraph: .accelerationZAxis)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Z-Axis: \(motionVM.coreMotionArray.last?.accelerationZAxis ?? 0.0, specifier: "%.5f") m/s^2", comment: "AccelerationView - Z-Axis")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Z-Axis Graph")
                        }
                        
                        Section(header: Text("Refresh Rate", comment: "AccelerationView - Section Header")) {
                            RefreshRateView2(refreshRate: $frequency, updateSensorInterval: { updateSensorInterval() }, show: "header")
                            RefreshRateView2(refreshRate: $frequency, updateSensorInterval: { updateSensorInterval() }, show: "slider")
                        }
                        
                        Section(header: Text("List", comment: "AccelerationView - Section Header")) {
                            ForEach(motionVM.coreMotionArray.reversed().prefix(5), id: \.counter) { index in
                                HStack{
                                    Text("ID:\(motionVM.coreMotionArray[index.counter - 1].counter)", comment: "MotionListView - ID")
                                        .foregroundColor(Color("ListTextColor"))
                                    Spacer()
                                    Text("X:\(motionVM.coreMotionArray[index.counter - 1].accelerationXAxis, specifier: "%.5f")", comment: "MotionListView - X")
                                        .foregroundColor(Color("ListTextColor"))
                                    Spacer()
                                    Text("Y:\(motionVM.coreMotionArray[index.counter - 1].accelerationYAxis, specifier: "%.5f")", comment: "MotionListView - Y")
                                        .foregroundColor(Color("ListTextColor"))
                                    Spacer()
                                    Text("Z:\(motionVM.coreMotionArray[index.counter - 1].accelerationZAxis, specifier: "%.5f")", comment: "MotionListView - Z")
                                        .foregroundColor(Color("ListTextColor"))
                                }
                                .font(.footnote)
                            }
                            .id(UUID())
                        }
                    }
                    .frame(minWidth: 0, idealWidth: g.size.width, maxWidth: .infinity, minHeight: 0, idealHeight: g.size.height, maxHeight: .infinity, alignment: .leading)
                }
                .listStyle(GroupedListStyle())
            }
            .customToolBar(toolBarFunctionClosure: toolBarButtonTapped(button:))
            
            
            // MARK: - SidebarMenu
            SidebarMenu(sidebarOpen: $sideBarOpen)
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationBarItems(leading: sideBarButton)
        .navigationBarTitle("\(NSLocalizedString("Acceleration", comment: "NavigationBar Title - Acceleration"))", displayMode: .inline)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .sheet(isPresented: $showShareSheet) { ShareSheet(activityItems: filesToShare) }
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

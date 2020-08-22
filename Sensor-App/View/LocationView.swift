//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI
//import StoreKit


// MARK: - Struct
struct LocationView: View {
    
    // MARK: - Initialize Classes
    let locationAPI = CoreLocationAPI()
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    let notificationAPI = NotificationAPI()
    let exportAPI = ExportAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var locationVM = CoreLocationViewModel()
    @State private var sideBarOpen: Bool = false
    @State private var showShareSheet = false
    @State private var filesToShare = [Any]()
    
    // Show Graph
    @State private var showLatitude = false
    @State private var showLongitude = false
    @State private var showAltitude = false
    @State private var showDirection = false
    @State private var showSpeed = false
    
    // Notification Variables
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Initializer
    init() {
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }
    
    
    // MARK: - Methods
    func toolBarButtonTapped(button: ToolBarButtonType) {
        var messageType: NotificationTypes?
        
        switch button {
            case .play:
                locationVM.startLocationUpdates()
                messageType = .played
            case .pause:
                locationVM.stopLocationUpdates()
                messageType = .paused
            case .delete:
                locationVM.coreLocationArray.removeAll()
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
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        locationVM.startLocationUpdates()
    }
    
    func onDisappear() {
        locationVM.stopLocationUpdates()
        locationVM.coreLocationArray.removeAll()
        #warning("requestReview() deprecated")
        //SKStoreReviewController.requestReview()
    }
    
    func shareCSV() {
        var csvText = NSLocalizedString("ID;Time;Longitude;Latitude;Altitude;Speed;Course", comment: "Export CSV Headline - Location") + "\n"
        
        _ = locationVM.coreLocationArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.longitude.localizedDecimal());\($0.latitude.localizedDecimal());\($0.altitude.localizedDecimal());\($0.speed.localizedDecimal());\($0.course.localizedDecimal())\n"
        }
        filesToShare = exportAPI.getFile(exportText: csvText, filename: "location")
        showShareSheet.toggle()
    }
    
    
    // MARK: - Content
    var sideBarButton: some View {
        Button(action: {
            sideBarOpen.toggle()
            if sideBarOpen {
                locationVM.stopLocationUpdates()
            } else {
                locationVM.startLocationUpdates()
            }
        }) {
            Image(systemName: "sidebar.left")
                .accessibility(label: Text("Toggle Sidebar", comment: "Toggle Sidebar"))
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
                        Section(header: Text("Location", comment: "LocationView - Section Header")) {
                            DisclosureGroup(
                                isExpanded: $showLatitude,
                                content: {
                                    LineGraphSubView(locationVM: locationVM, showGraph: .latitude)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Latitude: \(locationVM.coreLocationArray.last?.latitude ?? 0.0, specifier: "%.6f")° ± \(locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Latitude")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Latitude Graph")
                            
                            DisclosureGroup(
                                isExpanded: $showLongitude,
                                content: {
                                    LineGraphSubView(locationVM: locationVM, showGraph: .longitude)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Longitude: \(locationVM.coreLocationArray.last?.longitude ?? 0.0, specifier: "%.6f")° ± \(locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Longitude")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Longitude Graph")
                            
                            DisclosureGroup(
                                isExpanded: $showAltitude,
                                content: {
                                    LineGraphSubView(locationVM: locationVM, showGraph: .altitude)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Altitude: \(locationVM.coreLocationArray.last?.altitude ?? 0.0, specifier: "%.2f") ± \(locationVM.coreLocationArray.last?.verticalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Altitude")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Altitude Graph")
                            
                            DisclosureGroup(
                                isExpanded: $showDirection,
                                content: {
                                    LineGraphSubView(locationVM: locationVM, showGraph: .course)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text("Direction: \(locationVM.coreLocationArray.last?.course ?? 0.0, specifier: "%.2f")°", comment: "LocationView - Direction")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Direction Graph")

                            DisclosureGroup(
                                isExpanded: $showSpeed,
                                content: {
                                    LineGraphSubView(locationVM: locationVM, showGraph: .speed)
                                        .frame(height: 100, alignment: .leading)
                                },
                                label: {
                                    Text(verbatim: "\(NSLocalizedString("Speed:", comment: "LocationView - Speed")) \(calculationAPI.calculateSpeed(ms: locationVM.coreLocationArray.last?.speed ?? 0.0, to: "\(settings.fetchUserSettings().GPSSpeedSetting)")) \(settings.fetchUserSettings().GPSSpeedSetting)")
                                })
                                .disclosureGroupModifier(accessibility: "Toggle Speed Graph")
                        }

                        Section(header: Text("Map", comment: "LocationView - Section Header")) {
                            MapView(region: $locationVM.region)
                                .frame(minWidth: 0, idealWidth: g.size.width, maxWidth: .infinity, minHeight: 0, idealHeight: g.size.height, maxHeight: .infinity, alignment: .center)
                                .cornerRadius(10)
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
        .navigationBarTitle("\(NSLocalizedString("Location", comment: "NavigationBar Title - Location"))", displayMode: .inline)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .sheet(isPresented: $showShareSheet) { ShareSheet(activityItems: filesToShare) }
    }
}


// MARK: - Preview
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                LocationView()
                    .colorScheme(scheme)
            }
        }
    }
}

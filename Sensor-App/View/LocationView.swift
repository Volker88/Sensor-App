//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI
import StoreKit


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
                self.locationVM.coreLocationArray.removeAll()
                messageType = .deleted
            case .share:
                shareCSV()
            default:
                print("nil")
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
        locationVM.startLocationUpdates()
    }
    
    func onDisappear() {
        locationVM.stopLocationUpdates()
        locationVM.coreLocationArray.removeAll()
        SKStoreReviewController.requestReview() // FIXME: - depreceated
    }
    
    func shareCSV() {
        var csvText = NSLocalizedString("ID;Time;Longitude;Latitude;Altitude;Speed;Course", comment: "Export CSV Headline - Location") + "\n"
        
        _ = locationVM.coreLocationArray.map {
            csvText += "\($0.counter);\($0.timestamp);\($0.longitude.localizedDecimal());\($0.latitude.localizedDecimal());\($0.altitude.localizedDecimal());\($0.speed.localizedDecimal());\($0.course.localizedDecimal())\n"
        }
        filesToShare = exportAPI.getFile(exportText: csvText, filename: "location")
        self.showShareSheet.toggle()
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
                    VStack {
                        ScrollView {
                            Spacer()
                            Group{
                                Text("Latitude: \(self.locationVM.coreLocationArray.last?.latitude ?? 0.0, specifier: "%.6f")° ± \(self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Latitude")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showLatitude.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Latitude Graph")
                                    }, alignment: .trailing)
                                
                                if self.showLatitude == true {
                                    Spacer()
                                    LineGraphSubView(locationVM: self.locationVM, showGraph: .latitude)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Longitude: \(self.locationVM.coreLocationArray.last?.longitude ?? 0.0, specifier: "%.6f")° ± \(self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Longitude")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showLongitude.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Longitude Graph")
                                    }, alignment: .trailing)
                                
                                if self.showLongitude == true {
                                    Spacer()
                                    LineGraphSubView(locationVM: self.locationVM, showGraph: .longitude)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Altitude: \(self.locationVM.coreLocationArray.last?.altitude ?? 0.0, specifier: "%.2f") ± \(self.locationVM.coreLocationArray.last?.verticalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Altitude")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showAltitude.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Altitude Graph")
                                    }, alignment: .trailing)
                                
                                if self.showAltitude == true {
                                    Spacer()
                                    LineGraphSubView(locationVM: self.locationVM, showGraph: .altitude)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                
                                Text("Direction: \(self.locationVM.coreLocationArray.last?.course ?? 0.0, specifier: "%.2f")°", comment: "LocationView - Direction")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showDirection.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Direction Graph")
                                    }, alignment: .trailing)
                                
                                if self.showDirection == true {
                                    Spacer()
                                    LineGraphSubView(locationVM: self.locationVM, showGraph: .course)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                                Text(verbatim: "\(NSLocalizedString("Speed:", comment: "LocationView - Speed")) \(self.calculationAPI.calculateSpeed(ms: self.locationVM.coreLocationArray.last?.speed ?? 0.0, to: "\(self.settings.fetchUserSettings().GPSSpeedSetting)")) \(self.settings.fetchUserSettings().GPSSpeedSetting)")
                                    .buttonModifier()
                                    .overlay(Button(action: { self.showSpeed.toggle() }) {
                                        Image("GraphButton")
                                            .graphButtonModifier(accessibility: "Toggle Speed Graph")
                                    }, alignment: .trailing)
                                
                                if self.showSpeed == true {
                                    Spacer()
                                    LineGraphSubView(locationVM: self.locationVM, showGraph: .speed)
                                        .frame(width: g.size.width - 25, height: 100, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .frame(height: 50, alignment: .center)
                            .offset(x: 5)
                            Spacer()
                            //MapKitView(latitude: self.locationVM.coreLocationArray.last?.latitude ?? 37.3323314100, longitude: self.locationVM.coreLocationArray.last?.longitude ?? -122.0312186000)
                            MapView(region: $locationVM.region)
                                .frame(width: g.size.width - 10, height: g.size.height - 60, alignment: .center)
                                .cornerRadius(10)
                            Spacer(minLength: 20)
                        }
                        .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                    }
                }
                .customToolBar(toolBarFunctionClosure: self.toolBarButtonTapped(button:))
                
                
                // MARK: - SidebarMenu
                SidebarMenu(sidebarOpen: $sideBarOpen)
                
                
                // MARK: - NotificationView()
                NotificationView(notificationMessage: self.$notificationMessage, showNotification: self.$showNotification)
            }
            .navigationBarItems(leading: sideBarButton)
            .navigationBarTitle("\(NSLocalizedString("Location", comment: "NavigationBar Title - Location"))", displayMode: .inline)
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
            .sheet(isPresented: $showShareSheet) { ShareSheet(activityItems: self.filesToShare) }
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

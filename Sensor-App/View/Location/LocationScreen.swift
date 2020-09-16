//
//  LocationScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 24.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct LocationScreen: View {
    
    // MARK: - Initialize Classes
    let notificationAPI = NotificationAPI()
    let locationView = LocationView()
    
    // MARK: - @State / @ObservedObject / @Binding
    @State private var sideBarOpen: Bool = false
    
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
                locationView.locationVM.startLocationUpdates()
                messageType = .played
            case .pause:
                locationView.locationVM.stopLocationUpdates()
                messageType = .paused
            case .delete:
                locationView.locationVM.coreLocationArray.removeAll()
                messageType = .deleted
                Log.shared.add(.coreLocation, .default, "Deleted Location Data")
        }
        
        if messageType != nil {
            notificationAPI.toggleNotification(type: messageType!, duration: notificationDuration) { (message, show) in
                notificationMessage = message
                showNotification = show
            }
        }
    }
    
    
    // MARK: - Content
    var sideBarButton: some View {
        Button(action: {
            sideBarOpen.toggle()
            if sideBarOpen {
                locationView.locationVM.stopLocationUpdates()
            } else {
                locationView.locationVM.startLocationUpdates()
            }
        }) {
            Image(systemName: "sidebar.left")
        }
    }
    
    var content: some View {
        ZStack {
            locationView
                .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                .toolbar {
                    CustomToolbar(toolBarFunctionClosure: toolBarButtonTapped(button:))
                }
            
            
            // MARK: - SidebarMenu
            SidebarMenu(sidebarOpen: $sideBarOpen)
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationBarTitle("\(NSLocalizedString("Location", comment: "NavigationBar Title - Location"))", displayMode: .inline)
    }
    
    
    // MARK: - Body - View
    @ViewBuilder
    var body: some View {
        
        // MARK: - Return View
        if UIDevice.current.userInterfaceIdiom == .phone {
            content
                .navigationBarItems(leading: sideBarButton)
        } else {
            content
        }
    }
}


// MARK: - Preview
struct LocationScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                LocationScreen()
                    .colorScheme(scheme)
            }
        }
    }
}

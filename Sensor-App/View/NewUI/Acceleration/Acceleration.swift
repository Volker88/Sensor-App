//
//  Acceleration.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct Acceleration: View {
    
    
    // MARK: - Initialize Classes
    let locationAPI = CoreLocationAPI()
    let notificationAPI = NotificationAPI()
    let accelerationView = AccelerationView()
    
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
                accelerationView.motionVM.motionUpdateStart()
                messageType = .played
            case .pause:
                accelerationView.motionVM.stopMotionUpdates()
                messageType = .paused
            case .delete:
                accelerationView.motionVM.coreMotionArray.removeAll()
                accelerationView.motionVM.altitudeArray.removeAll()
                messageType = .deleted
            case .share:
                accelerationView.shareCSV()
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
                accelerationView.motionVM.stopMotionUpdates()
            } else {
                accelerationView.motionVM.motionUpdateStart()
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
            accelerationView
                .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                .customToolBar(toolBarFunctionClosure: toolBarButtonTapped(button:))
            
            
            // MARK: - SidebarMenu
            SidebarMenu(sidebarOpen: $sideBarOpen)
            
            
            // MARK: - NotificationView()
            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationBarItems(leading: sideBarButton)
        .navigationBarTitle("\(NSLocalizedString("Acceleration", comment: "NavigationBar Title - Acceleration"))", displayMode: .inline)
    }
}


// MARK: - Preview
struct Acceleration_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                Acceleration()
                    .colorScheme(scheme)
            }
        }
    }
}

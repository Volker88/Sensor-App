//
//  AltitudeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI
import OSLog

struct AltitudeScreen: View {
    let notificationAPI = NotificationAPI()

    @Environment(MotionManager.self) var motionManager

    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0

    init() {
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }

    var body: some View {
        ZStack {
            AltitudeView()
                .toolbar {
                    CustomToolbar(toolBarFunctionClosure: toolBarButtonTapped(button:))
                }

            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationTitle(NSLocalizedString("Altitude", comment: "NavigationBar Title - Altitude"))
        .navigationDestination(for: Route.self, destination: { route in
            switch route {
                case .altitudeList:
                    AltitudeList()
                default:
                    EmptyView()

            }
        })
        .onAppear {
            motionManager.startAltitudeUpdates()
        }
    }

    func toolBarButtonTapped(button: ToolBarButtonType) {
        var messageType: NotificationTypes?

        switch button {
            case .play:
                motionManager.startAltitudeUpdates()
                messageType = .played
            case .pause:
                motionManager.stopMotionUpdates()
                messageType = .paused
            case .delete:
                motionManager.resetMotionUpdates()
                messageType = .deleted
                Logger.coreLocation.debug("Deleted Motion Data")
        }

        if let messageType {
            notificationAPI.toggleNotification(type: messageType, duration: notificationDuration) { (message, show) in
                notificationMessage = message
                showNotification = show
            }
        }
    }
}

struct AltitudeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AltitudeScreen()
        }
    }
}

//
//  MagnetometerScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI
import OSLog

struct MagnetometerScreen: View {
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
            MagnetometerView()
                .toolbar {
                    CustomToolbar(toolBarFunctionClosure: toolBarButtonTapped(button:))
                }

            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationTitle(NSLocalizedString("Magnetometer", comment: "NavigationBar Title - Magnetometer"))
        .navigationDestination(for: Route.self, destination: { route in
            switch route {
                case .magnetometerList:
                    MagnetometerList()
                default:
                    EmptyView()

            }
        })
        .onAppear {
            motionManager.startMotionUpdates()
        }
    }

    func toolBarButtonTapped(button: ToolBarButtonType) {
        var messageType: NotificationTypes?

        switch button {
            case .play:
                motionManager.startMotionUpdates()
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

struct MagnetometerScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MagnetometerScreen()
        }
    }
}

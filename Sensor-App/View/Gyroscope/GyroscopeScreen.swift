//
//  GyroscopeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI
import OSLog

struct GyroscopeScreen: View {
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
            GyroscopeView()
                .toolbar {
                    CustomToolbar(toolBarFunctionClosure: toolBarButtonTapped(button:))
                }

            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationTitle(NSLocalizedString("Gyroscope", comment: "NavigationBar Title - Gyroscope"))
        .navigationDestination(for: Route.self, destination: { route in
            switch route {
                case .gyroscopeList:
                    GyroscopeList()
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

struct GyroscopeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GyroscopeScreen()
        }
    }
}

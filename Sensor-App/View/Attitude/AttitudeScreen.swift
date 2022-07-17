//
//  AttitudeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AttitudeScreen: View {
    let notificationAPI = NotificationAPI()
    let attitudeView = AttitudeView()

    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0

    init() {
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }

    var body: some View {
        ZStack {
            attitudeView
                .toolbar {
                    CustomToolbar(toolBarFunctionClosure: toolBarButtonTapped(button:))
                }

            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationTitle(NSLocalizedString("Attitude", comment: "NavigationBar Title - Attitude"))
    }

    func toolBarButtonTapped(button: ToolBarButtonType) {
        var messageType: NotificationTypes?

        switch button {
            case .play:
                attitudeView.motionVM.motionUpdateStart()
                messageType = .played
            case .pause:
                attitudeView.motionVM.stopMotionUpdates()
                messageType = .paused
            case .delete:
                attitudeView.motionVM.coreMotionArray.removeAll()
                attitudeView.motionVM.altitudeArray.removeAll()
                messageType = .deleted
                Log.shared.add(.coreLocation, .default, "Deleted Motion Data")
        }

        if messageType != nil {
            notificationAPI.toggleNotification(type: messageType!, duration: notificationDuration) { (message, show) in
                notificationMessage = message
                showNotification = show
            }
        }
    }
}

struct AttitudeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AttitudeScreen()
        }
    }
}

//
//  AltitudeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AltitudeScreen: View {
    let notificationAPI = NotificationAPI()
    let altitudeView = AltitudeView()

    @EnvironmentObject var motionVM: CoreMotionViewModel
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0

    init() {
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }

    var body: some View {
        ZStack {
            altitudeView
                .toolbar {
                    CustomToolbar(toolBarFunctionClosure: toolBarButtonTapped(button:))
                }

            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationTitle(NSLocalizedString("Altitude", comment: "NavigationBar Title - Altitude"))
    }

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

struct AltitudeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AltitudeScreen()
        }
    }
}

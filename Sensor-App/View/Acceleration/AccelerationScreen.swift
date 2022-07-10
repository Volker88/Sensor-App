//
//  AccelerationScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct AccelerationScreen: View {
    let notificationAPI = NotificationAPI()
    let accelerationView = AccelerationView()

    @State private var sideBarOpen: Bool = false
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0

    init() {
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }

    var body: some View {
        ZStack {
            accelerationView
//                .frame(
//                    minWidth: 0,
//                    idealWidth: 100,
//                    maxWidth: .infinity,
//                    minHeight: 0,
//                    idealHeight: 100,
//                    maxHeight: .infinity,
//                    alignment: .center
//                )
                .toolbar {
                    CustomToolbar(toolBarFunctionClosure: toolBarButtonTapped(button:))
                }

            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationBarTitle("\(NSLocalizedString("Acceleration", comment: "NavigationBar Title - Acceleration"))", displayMode: .inline) // swiftlint:disable:this line_length
    }

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

struct AccelerationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccelerationScreen()
        }
    }
}

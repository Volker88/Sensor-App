//
//  GyroscopeScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct GyroscopeScreen: View {
    let notificationAPI = NotificationAPI()
    let gyroscopeView = GyroscopeView()

    @State private var sideBarOpen: Bool = false
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0

    init() {
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }

    var body: some View {
        ZStack {
            gyroscopeView
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
        .navigationBarTitle("\(NSLocalizedString("Gyroscope", comment: "NavigationBar Title - Gyroscope"))", displayMode: .inline) // swiftlint:disable:this line_length
    }

    func toolBarButtonTapped(button: ToolBarButtonType) {
        var messageType: NotificationTypes?

        switch button {
            case .play:
                gyroscopeView.motionVM.motionUpdateStart()
                messageType = .played
            case .pause:
                gyroscopeView.motionVM.stopMotionUpdates()
                messageType = .paused
            case .delete:
                gyroscopeView.motionVM.coreMotionArray.removeAll()
                gyroscopeView.motionVM.altitudeArray.removeAll()
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

struct GyroscopeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GyroscopeScreen()
        }
    }
}

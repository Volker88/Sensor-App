//
//  GravityScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 23.08.20.
//

import SwiftUI

struct GravityScreen: View {
    let notificationAPI = NotificationAPI()
    let gravityView = GravityView()

    @State private var sideBarOpen: Bool = false
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0

    init() {
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }

    var body: some View {
        ZStack {
            gravityView
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
        .navigationBarTitle("\(NSLocalizedString("Gravity", comment: "NavigationBar Title - Gravity"))", displayMode: .inline) // swiftlint:disable:this line_length
    }

    func toolBarButtonTapped(button: ToolBarButtonType) {
        var messageType: NotificationTypes?

        switch button {
            case .play:
                gravityView.motionVM.motionUpdateStart()
                messageType = .played
            case .pause:
                gravityView.motionVM.stopMotionUpdates()
                messageType = .paused
            case .delete:
                gravityView.motionVM.coreMotionArray.removeAll()
                gravityView.motionVM.altitudeArray.removeAll()
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

struct GravityScreen_Previews: PreviewProvider {
    static var previews: some View {
            NavigationView {
                GravityScreen()
            }
    }
}

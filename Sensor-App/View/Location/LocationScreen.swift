//
//  LocationScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 24.08.20.
//

import SwiftUI
import StoreKit

struct LocationScreen: View {

    @Environment(\.requestReview) var requestReview

    let notificationAPI = NotificationAPI()
    let locationView = LocationView()

    @State private var sideBarOpen: Bool = false
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0

    init() {
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }

    var body: some View {
        ZStack {
            locationView
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
        .navigationBarTitle("\(NSLocalizedString("Location", comment: "NavigationBar Title - Location"))", displayMode: .inline) // swiftlint:disable:this line_length
        .onDisappear {
            #if RELEASE
            requestReview()
            #endif
        }
    }

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
}

struct LocationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationScreen()
        }
    }
}

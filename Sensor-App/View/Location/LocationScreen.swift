//
//  LocationScreen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 24.08.20.
//

import SwiftUI
import StoreKit
import OSLog

struct LocationScreen: View {
    @Environment(\.requestReview) var requestReview
    @Environment(LocationManager.self) var locationManager

    let notificationAPI = NotificationAPI()

    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0

    init() {
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }

    var body: some View {
        ZStack {
            LocationView()
                .toolbar {
                    CustomToolbar(toolBarFunctionClosure: toolBarButtonTapped(button:))
                }

            NotificationView(notificationMessage: $notificationMessage, showNotification: $showNotification)
        }
        .navigationTitle(NSLocalizedString("Location", comment: "NavigationBar Title - Location"))
        .navigationDestination(for: Route.self, destination: { route in
            switch route {
                case .location:
                    MapView()
                default:
                    MapView()
            }
        })
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
                locationManager.startLocationUpdates()
                messageType = .played
            case .pause:
                locationManager.stopLocationUpdates()
                messageType = .paused
            case .delete:
                locationManager.resetLocationUpdates()
                messageType = .deleted
                Logger.coreLocation.debug("Deleted Location Data")
        }

        if let messageType {
            notificationAPI.toggleNotification(type: messageType, duration: notificationDuration) { (message, show) in
                notificationMessage = message
                showNotification = show
            }
        }
    }
}

struct LocationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LocationScreen()
        }
    }
}

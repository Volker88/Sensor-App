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
    let locationView: LocationView

    @StateObject private var locationVM: CoreLocationViewModel
    @State private var showNotification = false
    @State private var notificationMessage = ""
    @State private var notificationDuration = 2.0

    init() {
        let locationVM = CoreLocationViewModel()
        _locationVM = StateObject(wrappedValue: locationVM)
        locationView = LocationView(locationVM: locationVM)
        notificationDuration = notificationAPI.fetchNotificationAnimationSettings().duration
    }

    var body: some View {
        ZStack {
            locationView
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
                locationVM.startLocationUpdates()
                messageType = .played
            case .pause:
                locationVM.stopLocationUpdates()
                messageType = .paused
            case .delete:
                locationVM.coreLocationArray.removeAll()
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
        NavigationStack {
            LocationScreen()
        }
    }
}

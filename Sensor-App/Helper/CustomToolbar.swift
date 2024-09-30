//
//  CustomToolbar.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.08.20.
//

import SwiftUI

struct CustomToolbar: ToolbarContent {

    @Environment(\.showNotification) private var showNotification
    @Environment(LocationManager.self) private var locationManager
    @Environment(MotionManager.self) private var motionManager

    var body: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) { Spacer() }

        ToolbarItem(placement: .bottomBar) {
            Button(action: {
                showNotification("Play")
                locationManager.startLocationUpdates()
                motionManager.startMotionUpdates()
                motionManager.startAltitudeUpdates()
            }) {
                Image(systemName: "play.circle")
                    .accessibility(label: Text("Play", comment: "CustomToolbar - Play Button"))
                    .accessibility(identifier: "Play")
            }
        }

        ToolbarItem(placement: .bottomBar) { Spacer() }

        ToolbarItem(placement: .bottomBar) {
            Button(action: {
                showNotification("Paused")
                locationManager.stopLocationUpdates()
                motionManager.stopMotionUpdates()
            }) {
                Image(systemName: "pause.circle")
                    .accessibility(label: Text("Pause", comment: "CustomToolbar - Pause Button"))
                    .accessibility(identifier: "Pause")
            }

        }

        ToolbarItem(placement: .bottomBar) { Spacer() }

        ToolbarItem(placement: .bottomBar) {
            Button(action: {
                showNotification("Successfully deleted")
                locationManager.resetLocationUpdates()
                motionManager.resetMotionUpdates()
            }) {
                Image(systemName: "trash.circle")
                    .accessibility(label: Text("Delete", comment: "CustomToolbar - Delete Button"))
                    .accessibility(identifier: "Delete")
            }
        }

        ToolbarItem(placement: .bottomBar) { Spacer() }
    }
}

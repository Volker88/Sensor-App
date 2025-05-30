//
//  CustomToolbar.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.08.20.
//

import Sensor_App_Framework
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
            }
            .accessibilityLabel(Text("Play", comment: "Play Button to start sensor updates"))
            .accessibilityIdentifier(UIIdentifiers.Toolbar.playButton)
        }

        ToolbarItem(placement: .bottomBar) { Spacer() }

        ToolbarItem(placement: .bottomBar) {
            Button(action: {
                showNotification("Paused")
                locationManager.stopLocationUpdates()
                motionManager.stopMotionUpdates()
            }) {
                Image(systemName: "pause.circle")
            }
            .accessibilityLabel(Text("Pause", comment: "Pause Button to stop sensor updates"))
            .accessibilityIdentifier(UIIdentifiers.Toolbar.pauseButton)
        }

        ToolbarItem(placement: .bottomBar) { Spacer() }

        ToolbarItem(placement: .bottomBar) {
            Button(action: {
                showNotification("Successfully deleted")
                locationManager.resetLocationUpdates()
                motionManager.resetMotionUpdates()
            }) {
                Image(systemName: "trash.circle")
            }
            .accessibilityLabel(Text("Delete", comment: "Delete Button to delete all sensor updates"))
            .accessibilityIdentifier(UIIdentifiers.Toolbar.deleteButton)
        }

        ToolbarItem(placement: .bottomBar) { Spacer() }
    }
}

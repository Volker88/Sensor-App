//
//  CustomControlsView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import Sensor_App_Framework
import SwiftUI

struct CustomControlsView: View {

    @Environment(\.showNotification) private var showNotification
    @Environment(LocationManager.self) private var locationManager
    @Environment(MotionManager.self) private var motionManager

    @State private var expandControl = false

    // MARK: - Body
    var body: some View {
        HStack(alignment: .bottom) {

            Spacer()

            VStack(spacing: 20) {
                if expandControl {
                    if !locationManager.updatesStarted && !motionManager.updatesStarted {
                        Button(action: {
                            showNotification("Play")
                            locationManager.startLocationUpdates()
                            motionManager.startMotionUpdates()
                            motionManager.startAltitudeUpdates()
                        }) {
                            Image(systemName: "play.circle")
                                .foregroundStyle(.green)
                        }
                        .accessibilityLabel(Text("Play"))
                        .accessibilityIdentifier(UIIdentifiers.CustomControlsView.playButton)
                    } else {
                        Button(action: {
                            showNotification("Paused")
                            locationManager.stopLocationUpdates()
                            motionManager.stopMotionUpdates()
                        }) {
                            Image(systemName: "pause.circle")
                                .foregroundStyle(.yellow)
                        }
                        .accessibilityLabel(Text("Pause"))
                        .accessibilityIdentifier(UIIdentifiers.CustomControlsView.pauseButton)
                    }

                    Button(action: {
                        showNotification("Successfully deleted")
                        locationManager.resetLocationUpdates()
                        motionManager.resetMotionUpdates()
                    }) {
                        Image(systemName: "trash.circle")
                            .tint(.red)
                    }
                    .accessibilityLabel(Text("Delete"))
                    .accessibilityIdentifier(UIIdentifiers.CustomControlsView.deleteButton)

                }

                Button {
                    expandControl.toggle()
                } label: {
                    Image(systemName: expandControl ? "multiply" : "plus")
                }
                .accessibilityIdentifier(UIIdentifiers.CustomControlsView.expandButton)
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }

            }
            .font(.largeTitle)
            .padding(10)
            .glassEffect()
            .padding(.bottom, 15)

        }
        .padding(.trailing, 15)
    }
}

// MARK: - Preview
#Preview("CustomControlsView - English", traits: .navEmbedded) {
    VStack {
        Spacer()
        CustomControlsView()
    }
    .environment(LocationManager())
    .environment(MotionManager())
}

#Preview("CustomControlsView - German", traits: .navEmbedded) {
    VStack {
        Spacer()
        CustomControlsView()
    }
    .previewLocalization(.german)
    .environment(LocationManager())
    .environment(MotionManager())
}

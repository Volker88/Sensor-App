//
//  Sidebar.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.08.20.
//

import Sensor_App_Framework
import SwiftUI

struct Sidebar: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(AppState.self) private var appState

    var list: some View {
        List(selection: Bindable(appState).selectedScreen) {
            if sizeClass == .regular {
                NavigationLink(value: Screen.homeScreen) {
                    Label {
                        Text("Home", comment: "Navigation Button")
                    } icon: {
                        Image(systemName: "house")
                    }
                }
                .accessibilityIdentifier(UIIdentifiers.Sidebar.homeButton)
            }

            NavigationLink(value: Screen.location) {
                Label {
                    Text("Location", comment: "Navigation Button")
                } icon: {
                    Image(systemName: "location")
                }
            }
            .accessibilityIdentifier(UIIdentifiers.Sidebar.locationButton)

            NavigationLink(value: Screen.acceleration) {
                Label {
                    Text("Acceleration", comment: "Navigation Button")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
            }
            .accessibilityIdentifier(UIIdentifiers.Sidebar.accelerationButton)

            NavigationLink(value: Screen.gravity) {
                Label {
                    Text("Gravity", comment: "Navigation Button")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
            }
            .accessibilityIdentifier(UIIdentifiers.Sidebar.gravityButton)

            NavigationLink(value: Screen.gyroscope) {
                Label {
                    Text("Gyroscope", comment: "Navigation Button")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
            }
            .accessibilityIdentifier(UIIdentifiers.Sidebar.gyroscopeButton)

            NavigationLink(value: Screen.magnetometer) {
                Label {
                    Text("Magnetometer", comment: "Navigation Button")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
            }
            .accessibilityIdentifier(UIIdentifiers.Sidebar.magnetometerButton)

            NavigationLink(value: Screen.attitude) {
                Label {
                    Text("Attitude", comment: "Navigation Button")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
            }
            .accessibilityIdentifier(UIIdentifiers.Sidebar.attitudeButton)

            NavigationLink(value: Screen.altitude) {
                Label {
                    Text("Altitude", comment: "Navigation Button")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
            }
            .accessibilityIdentifier(UIIdentifiers.Sidebar.altitudeButton)

            NavigationLink(value: Screen.settings) {
                Label {
                    Text("Settings", comment: "Navigation Button")
                } icon: {
                    Image(systemName: "gear")
                }
            }
            .accessibilityIdentifier(UIIdentifiers.Sidebar.settingsButton)
        }
        .listStyle(.sidebar)
        .accessibilityIdentifier(UIIdentifiers.Sidebar.collectionView)
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            if sizeClass == .regular {
                list
            } else {
                list
                    .navigationTitle(Text("Home", comment: "NavigationBar Title - Home Screen"))
            }
        }
    }
}

// MARK: - Preview
#Preview("Sidebar - English", traits: .navEmbedded) {
    Sidebar()
}

#Preview("Sidebar - German", traits: .navEmbedded) {
    Sidebar()
        .previewLocalization(.german)
}

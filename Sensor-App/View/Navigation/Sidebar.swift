//
//  Sidebar.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.08.20.
//

import SwiftUI

struct Sidebar: View {

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(AppState.self) private var appState

    var list: some View {
        List(selection: Bindable(appState).selectedScreen) {
            if sizeClass == .regular {
                NavigationLink(value: Screen.homeScreen) {
                    Label(NSLocalizedString("Home", comment: "Sidebbar - Location"), systemImage: "house")
                        .accessibility(identifier: "Home")
                }
            }

            NavigationLink(value: Screen.location) {
                Label(NSLocalizedString("Location", comment: "Sidebbar - Location"), systemImage: "location")
                    .accessibility(identifier: "Location")
            }

            NavigationLink(value: Screen.acceleration) {
                Label(NSLocalizedString("Acceleration", comment: "Sidebbar - Acceleration"), systemImage: "globe")
                    .accessibility(identifier: "Acceleration")
            }

            NavigationLink(value: Screen.gravity) {
                Label(NSLocalizedString("Gravity", comment: "Sidebbar - Gravity"), systemImage: "globe")
                    .accessibility(identifier: "Gravity")
            }

            NavigationLink(value: Screen.gyroscope) {
                Label(NSLocalizedString("Gyroscope", comment: "Sidebbar - Gyroscope"), systemImage: "globe")
                    .accessibility(identifier: "Gyroscope")
            }

            NavigationLink(value: Screen.magnetometer) {
                Label(NSLocalizedString("Magnetometer", comment: "Sidebbar - Magnetometer"), systemImage: "globe")
                    .accessibility(identifier: "Magnetometer")
            }

            NavigationLink(value: Screen.attitude) {
                Label(NSLocalizedString("Attitude", comment: "Sidebbar - Attitude"), systemImage: "globe")
                    .accessibility(identifier: "Attitude")
            }

            NavigationLink(value: Screen.altitude) {
                Label(NSLocalizedString("Altitude", comment: "Sidebbar - Altitude"), systemImage: "globe")
                    .accessibility(identifier: "Altitude")
            }

            NavigationLink(value: Screen.settings) {
                Label(NSLocalizedString("Settings", comment: "Sidebbar - Settings"), systemImage: "gear")
                    .accessibility(identifier: "Settings")
            }
        }
        .listStyle(.sidebar)
        .accessibility(identifier: "Sidebar")
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            if sizeClass == .regular {
                list
            } else {
                list
                    .navigationTitle("Home")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    Sidebar()
        .environment(AppState())
        .previewNavigationStackWrapper()
}

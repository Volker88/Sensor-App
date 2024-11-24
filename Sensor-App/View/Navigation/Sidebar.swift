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
                    Label {
                        Text("Home", comment: "")
                    } icon: {
                        Image(systemName: "house")
                    }
                    .accessibility(identifier: "Home")
                }
            }

            NavigationLink(value: Screen.location) {
                Label {
                    Text("Location", comment: "")
                } icon: {
                    Image(systemName: "location")
                }
                .accessibility(identifier: "Location")
            }

            NavigationLink(value: Screen.acceleration) {
                Label {
                    Text("Acceleration", comment: "")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
                .accessibility(identifier: "Acceleration")
            }

            NavigationLink(value: Screen.gravity) {
                Label {
                    Text("Gravity", comment: "")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
                .accessibility(identifier: "Gravity")
            }

            NavigationLink(value: Screen.gyroscope) {
                Label {
                    Text("Gyroscope", comment: "")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
                .accessibility(identifier: "Gyroscope")
            }

            NavigationLink(value: Screen.magnetometer) {
                Label {
                    Text("Magnetometer", comment: "")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
                .accessibility(identifier: "Magnetometer")
            }

            NavigationLink(value: Screen.attitude) {
                Label {
                    Text("Attitude", comment: "")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
                .accessibility(identifier: "Attitude")
            }

            NavigationLink(value: Screen.altitude) {
                Label {
                    Text("Altitude", comment: "")
                } icon: {
                    Image(systemName: "lines.measurement.horizontal")
                }
                .accessibility(identifier: "Altitude")
            }

            NavigationLink(value: Screen.settings) {
                Label {
                    Text("Settings", comment: "")
                } icon: {
                    Image(systemName: "gear")
                }
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

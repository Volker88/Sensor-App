//
//  ContentView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.08.20.
//

// MARK: - Import
import SwiftUI

// MARK: - Struct / Class Definition
struct ContentView: View {

    // MARK: - Initialize Classes

    // MARK: - Environment Object

    // MARK: - @State / @ObservedObject / @Binding
    @State private var sideBarOpen: Bool = false
    @State private var showSettings = false

    // MARK: - Define Constants / Variables

    // MARK: - Initializer

    // MARK: - Methods

    // MARK: - Content
    var sideBarButton: some View {
        Button(action: {
            sideBarOpen.toggle()
        }) {
            Image(systemName: "line.horizontal.3")
        }
    }

    var content: some View {
        List {
            Group {
                NavigationLink(destination: LocationScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Location", comment: "Sidebbar - Location"), systemImage: "location")
                        .accessibility(identifier: "Location")
                }
                NavigationLink(destination: AccelerationScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Acceleration", comment: "Sidebbar - Acceleration"), systemImage: "globe")
                        .accessibility(identifier: "Acceleration")
                }
                NavigationLink(destination: GravityScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Gravity", comment: "Sidebbar - Gravity"), systemImage: "globe")
                        .accessibility(identifier: "Gravity")
                }
                NavigationLink(destination: GyroscopeScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Gyroscope", comment: "Sidebbar - Gyroscope"), systemImage: "globe")
                        .accessibility(identifier: "Gyroscope")
                }
            }

            Group {
                NavigationLink(destination: MagnetometerScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Magnetometer", comment: "Sidebbar - Magnetometer"), systemImage: "globe")
                        .accessibility(identifier: "Magnetometer")
                }
                NavigationLink(destination: AttitudeScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Attitude", comment: "Sidebbar - Attitude"), systemImage: "globe")
                        .accessibility(identifier: "Attitude")
                }
                NavigationLink(destination: AltitudeScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Altitude", comment: "Sidebbar - Altitude"), systemImage: "globe")
                        .accessibility(identifier: "Altitude")
                }
                if UIDevice.current.userInterfaceIdiom == .phone {
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Label(NSLocalizedString("Settings", comment: "Sidebbar - Settings"), systemImage: "gear")
                            .accessibility(identifier: "Settings")
                    }
                }
            }
        }
        .accessibilityIdentifier("Navigation List")
        .listStyle(InsetGroupedListStyle())
        .sheet(isPresented: $showSettings) { SettingsScreen() }
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            // MARK: - Return View
            if UIDevice.current.userInterfaceIdiom == .phone {
                ZStack {
                    content
                        .navigationBarItems(leading: sideBarButton)
                        .navigationBarTitle("\(NSLocalizedString("Home", comment: "HomeView - NavigationBar Title"))", displayMode: .automatic) //swiftlint:disable:this line_length

                    // MARK: - SidebarMenu
                    SidebarMenu(sidebarOpen: $sideBarOpen)
                }
            } else {
                if geometry.size.height > geometry.size.width {
                    content
                        .navigationBarTitle("\(NSLocalizedString("Home", comment: "HomeView - NavigationBar Title"))", displayMode: .automatic) //swiftlint:disable:this line_length
                } else {
                    Text("")
                        .navigationBarTitle("\(NSLocalizedString("Home", comment: "HomeView - NavigationBar Title"))", displayMode: .automatic) //swiftlint:disable:this line_length
                }

            }
        }
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            ContentView()
                .colorScheme(scheme)
        }
    }
}

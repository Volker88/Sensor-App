//
//  ContentView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import Sensor_App_Framework
import SwiftUI

struct ContentView: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(MotionManager.self) private var motionManager
    @Environment(LocationManager.self) private var locationManager
    @Environment(AppState.self) private var appState

    @AppStorage("TabCustomizations")
    private var customization: TabViewCustomization

    private var isCompact: Bool {
        horizontalSizeClass == .compact || UIDevice.current.userInterfaceIdiom == .phone
    }

    // MARK: - Body
    var body: some View {
        TabView(selection: Bindable(appState).selectedTab) {
            if isCompact {
                Tab(
                    RootTab.position.localizedString,
                    systemImage: RootTab.position.symbolImage,
                    value: RootTab.position
                ) {
                    PositionScreen()
                }
                .customizationID(RootTab.position.stringValue)
                .accessibilityIdentifier(UIIdentifiers.ContentView.positionTab)
            } else {
                TabSection(RootTab.position.localizedString) {
                    Tab(
                        RootTab.location.localizedString,
                        systemImage: RootTab.location.symbolImage,
                        value: RootTab.location
                    ) {
                        NavigationStack(path: Bindable(appState).positionStack) {
                            LocationScreen()
                                .navigationDestination(for: PositionStack.self) { $0 }
                        }
                    }
                    .customizationID(RootTab.location.stringValue)
                    .accessibilityIdentifier(UIIdentifiers.ContentView.locationTab)

                    Tab(
                        RootTab.altitude.localizedString,
                        systemImage: RootTab.altitude.symbolImage,
                        value: RootTab.altitude
                    ) {
                        NavigationStack(path: Bindable(appState).positionStack) {
                            AltitudeScreen()
                                .navigationDestination(for: PositionStack.self) { $0 }
                        }
                    }
                    .customizationID(RootTab.altitude.stringValue)
                    .accessibilityIdentifier(UIIdentifiers.ContentView.altitudeTab)
                }
                .customizationID(RootTab.position.stringValue + ".section")
            }

            if isCompact {
                Tab(
                    RootTab.motion.localizedString,
                    systemImage: RootTab.motion.symbolImage,
                    value: RootTab.motion
                ) {
                    MotionScreen()
                }
                .customizationID(RootTab.motion.stringValue)
                .accessibilityIdentifier(UIIdentifiers.ContentView.motionTab)
            } else {
                TabSection(RootTab.motion.localizedString) {
                    Tab(
                        RootTab.acceleration.localizedString,
                        systemImage: RootTab.acceleration.symbolImage,
                        value: RootTab.acceleration
                    ) {
                        NavigationStack(path: Bindable(appState).motionStack) {
                            AccelerationScreen()
                                .navigationDestination(for: MotionStack.self) { $0 }
                        }
                    }
                    .customizationID(RootTab.acceleration.stringValue)
                    .accessibilityIdentifier(UIIdentifiers.ContentView.accelerationTab)

                    Tab(
                        RootTab.gravity.localizedString,
                        systemImage: RootTab.gravity.symbolImage,
                        value: RootTab.gravity
                    ) {
                        NavigationStack(path: Bindable(appState).motionStack) {
                            GravityScreen()
                                .navigationDestination(for: MotionStack.self) { $0 }
                        }
                    }
                    .customizationID(RootTab.gravity.stringValue)
                    .accessibilityIdentifier(UIIdentifiers.ContentView.gravityTab)

                    Tab(
                        RootTab.gyroscope.localizedString,
                        systemImage: RootTab.gyroscope.symbolImage,
                        value: RootTab.gyroscope
                    ) {
                        NavigationStack(path: Bindable(appState).motionStack) {
                            GyroscopeScreen()
                                .navigationDestination(for: MotionStack.self) { $0 }
                        }
                    }
                    .customizationID(RootTab.gyroscope.stringValue)
                    .accessibilityIdentifier(UIIdentifiers.ContentView.gyroscopeTab)

                    Tab(
                        RootTab.attitude.localizedString,
                        systemImage: RootTab.attitude.symbolImage,
                        value: RootTab.attitude
                    ) {
                        NavigationStack(path: Bindable(appState).motionStack) {
                            AttitudeScreen()
                                .navigationDestination(for: MotionStack.self) { $0 }
                        }
                    }
                    .customizationID(RootTab.attitude.stringValue)
                    .accessibilityIdentifier(UIIdentifiers.ContentView.attitudeTab)
                }
                .customizationID(RootTab.motion.stringValue + ".section")
            }

            Tab(
                RootTab.magnetometer.localizedString,
                systemImage: RootTab.magnetometer.symbolImage,
                value: RootTab.magnetometer
            ) {
                NavigationStack(path: Bindable(appState).magnetometerStack) {
                    MagnetometerScreen()
                        .navigationDestination(for: MagnetometerStack.self) { $0 }
                }
            }
            .customizationID(RootTab.magnetometer.stringValue)
            .accessibilityIdentifier(UIIdentifiers.ContentView.magnetometerTab)

            Tab(
                RootTab.settings.localizedString,
                systemImage: RootTab.settings.symbolImage,
                value: RootTab.settings
            ) {
                NavigationStack {
                    SettingsScreen()
                }
            }
            .customizationID(RootTab.settings.stringValue)
            .accessibilityIdentifier(UIIdentifiers.ContentView.settingsTab)
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($customization)
        .onAppear(perform: onAppear)
        .onChange(of: horizontalSizeClass) { appState.onSizeClassChange() }
        .onChange(of: appState.appIntentTab) { appState.appIntentDrivenNavigation(horizontalSizeClass) }
        .onChange(of: appState.selectedTab) { onChangeOfSelectedTab() }
    }

    // MARK: - Methods
    private func onAppear() {
        if isCompact {
            appState.selectedTab = .position
        } else {
            appState.selectedTab = .location
        }
    }

    private func onChangeOfSelectedTab() {
        motionManager.stopMotionUpdates()
        locationManager.stopLocationUpdates()
        appState.resetStack()
        appState.appIntentTab = nil
    }
}

// MARK: - Preview
#Preview("ContentView - English") {
    ContentView()
        .environment(AppState())
        .environment(MotionManager())
        .environment(LocationManager())
}

#Preview("ContentView - German") {
    ContentView()
        .previewLocalization(.german)
        .environment(AppState())
        .environment(MotionManager())
        .environment(LocationManager())
}

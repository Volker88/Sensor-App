//
//  DetailColumn.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import SwiftUI

struct DetailColumn: View {

    @Environment(AppState.self) private var appState

    // MARK: - Body
    var body: some View {
        switch appState.selectedScreen ?? .homeScreen {
            case .homeScreen:
                HomeScreen()
            case .location:
                LocationScreen()
            case .acceleration:
                AccelerationScreen()
            case .gravity:
                GravityScreen()
            case .gyroscope:
                GyroscopeScreen()
            case .magnetometer:
                MagnetometerScreen()
            case .attitude:
                AttitudeScreen()
            case .altitude:
                AltitudeScreen()
            case .settings:
                SettingsScreen()
        }
    }
}

// MARK: - Preview
#Preview("DetailColumn - English", traits: .navEmbedded) {
    ContentView()
}

#Preview("DetailColumn - German", traits: .navEmbedded) {
    ContentView()
        .previewLocalization(.german)
}

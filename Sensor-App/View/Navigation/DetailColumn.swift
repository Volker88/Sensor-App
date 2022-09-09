//
//  DetailColumn.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 08.07.22.
//

import SwiftUI

struct DetailColumn: View {
    @EnvironmentObject private var appState: AppState

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

struct DetailColumn_Previews: PreviewProvider {
    static var previews: some View {
        DetailColumn()
    }
}

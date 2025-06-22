//
//  SensorAppShortcuts.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 21.06.25.
//

import AppIntents
import SwiftUI

nonisolated struct SensorAppShortchuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {

        // MARK: - Position Shortcuts
        AppShortcut(
            intent: OpenLocationIntent(),
            phrases: [
                "Open \(.applicationName) Location",
                "Open Location with \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Location", table: "AppIntents"),
            systemImageName: "location"
        )

        AppShortcut(
            intent: OpenAltitudeIntent(),
            phrases: [
                "Open \(.applicationName) Altitude",
                "Open Altitude with \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Altitude", table: "AppIntents"),
            systemImageName: "arrow.up.right.circle"
        )

        // MARK: - Motion Shortcuts
        AppShortcut(
            intent: OpenAccelerationIntent(),
            phrases: [
                "Open \(.applicationName) Acceleration",
                "Open Acceleration with \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Acceleration", table: "AppIntents"),
            systemImageName: "speedometer"
        )

        AppShortcut(
            intent: OpenGravityIntent(),
            phrases: [
                "Open \(.applicationName) Gravity",
                "Open Gravity with \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Gravity", table: "AppIntents"),
            systemImageName: "arrow.down.circle"
        )

        AppShortcut(
            intent: OpenGyroscopeIntent(),
            phrases: [
                "Open \(.applicationName) Gyroscope",
                "Open Gyroscope with \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Gyroscope", table: "AppIntents"),
            systemImageName: "gyroscope"
        )

        AppShortcut(
            intent: OpenAttitudeIntent(),
            phrases: [
                "Open \(.applicationName) Attitude",
                "Open Attitude with \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Attitude", table: "AppIntents"),
            systemImageName: "view.3d"
        )

        // MARK: - Magnetometer Shortcuts
        AppShortcut(
            intent: OpenMagnetometerIntent(),
            phrases: [
                "Open \(.applicationName) Magnetometer",
                "Open Magnetometer with \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Magnetometer", table: "AppIntents"),
            systemImageName: "wave.3.right"
        )
    }
}

//
//  NavigationOption.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 26.06.25.
//

import AppIntents
import SwiftUI

enum NavigationOption: String, AppEnum {
    case location
    case altitude
    case acceleration
    case gravity
    case gyroscope
    case attitude
    case magnetometer
    case settings

    static let typeDisplayRepresentation = TypeDisplayRepresentation(
        name: LocalizedStringResource("Navigation Option", table: "AppIntents")
    )

    static let caseDisplayRepresentations = [
        NavigationOption.location: DisplayRepresentation(
            title: LocalizedStringResource("Location", table: "AppIntents"),
            subtitle: LocalizedStringResource("View location data", table: "AppIntents"),
            image: .init(systemName: "location")
        ),
        NavigationOption.altitude: DisplayRepresentation(
            title: LocalizedStringResource("Altitude", table: "AppIntents"),
            subtitle: LocalizedStringResource("View altitude data", table: "AppIntents"),
            image: .init(systemName: "mountain.2")
        ),
        NavigationOption.acceleration: DisplayRepresentation(
            title: LocalizedStringResource("Acceleration", table: "AppIntents"),
            subtitle: LocalizedStringResource("View acceleration data", table: "AppIntents"),
            image: .init(systemName: "bolt.fill")
        ),
        NavigationOption.gravity: DisplayRepresentation(
            title: LocalizedStringResource("Gravity", table: "AppIntents"),
            subtitle: LocalizedStringResource("View gravity data", table: "AppIntents"),
            image: .init(systemName: "arrow.down")
        ),
        NavigationOption.gyroscope: DisplayRepresentation(
            title: LocalizedStringResource("Gyroscope", table: "AppIntents"),
            subtitle: LocalizedStringResource("View gyroscope data", table: "AppIntents"),
            image: .init(systemName: "gyroscope")
        ),
        NavigationOption.attitude: DisplayRepresentation(
            title: LocalizedStringResource("Attitude", table: "AppIntents"),
            subtitle: LocalizedStringResource("View attitude data", table: "AppIntents"),
            image: .init(systemName: "dial.medium")
        ),
        NavigationOption.magnetometer: DisplayRepresentation(
            title: LocalizedStringResource("Magnetometer", table: "AppIntents"),
            subtitle: LocalizedStringResource("View magnetometer data", table: "AppIntents"),
            image: .init(systemName: "wave.3.right")
        ),
        NavigationOption.settings: DisplayRepresentation(
            title: LocalizedStringResource("Settings", table: "AppIntents"),
            subtitle: LocalizedStringResource("Open settings", table: "AppIntents"),
            image: .init(systemName: "gear")
        )
    ]
}

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
        name: LocalizedStringResource("Navigation Option")
    )

    static let caseDisplayRepresentations = [
        NavigationOption.location: DisplayRepresentation(
            title: LocalizedStringResource("Location"),
            subtitle: LocalizedStringResource("View location data"),
            image: .init(systemName: "location")
        ),
        NavigationOption.altitude: DisplayRepresentation(
            title: LocalizedStringResource("Altitude"),
            subtitle: LocalizedStringResource("View altitude data"),
            image: .init(systemName: "mountain.2")
        ),
        NavigationOption.acceleration: DisplayRepresentation(
            title: LocalizedStringResource("Acceleration"),
            subtitle: LocalizedStringResource("View acceleration data"),
            image: .init(systemName: "bolt.fill")
        ),
        NavigationOption.gravity: DisplayRepresentation(
            title: LocalizedStringResource("Gravity"),
            subtitle: LocalizedStringResource("View gravity data"),
            image: .init(systemName: "arrow.down")
        ),
        NavigationOption.gyroscope: DisplayRepresentation(
            title: LocalizedStringResource("Gyroscope"),
            subtitle: LocalizedStringResource("View gyroscope data"),
            image: .init(systemName: "gyroscope")
        ),
        NavigationOption.attitude: DisplayRepresentation(
            title: LocalizedStringResource("Attitude"),
            subtitle: LocalizedStringResource("View attitude data"),
            image: .init(systemName: "dial.medium")
        ),
        NavigationOption.magnetometer: DisplayRepresentation(
            title: LocalizedStringResource("Magnetometer"),
            subtitle: LocalizedStringResource("View magnetometer data"),
            image: .init(systemName: "wave.3.right")
        ),
        NavigationOption.settings: DisplayRepresentation(
            title: LocalizedStringResource("Settings"),
            subtitle: LocalizedStringResource("Open settings"),
            image: .init(systemName: "gear")
        )
    ]
}

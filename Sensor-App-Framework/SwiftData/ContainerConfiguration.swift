//
//  ContainerConfiguration.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

// Read from Info.plist keys that expand from xcconfig build settings.
// "APP_GROUP_ID" stores "group.$(APP_GROUP_ID)$(APP_GROUP_ID_SUFFIX)" — fully resolved at build time
// via Debug/Release xcconfig (suffix is ".dev" for debug, empty for release).
// "CLOUDKIT_CONTAINER_ID" stores "$(CLOUDKIT_CONTAINER_ID)".

/// Resolves the App Group identifier and CloudKit container identifier that
/// the SwiftData store is configured with.
///
/// Values are read from `Info.plist` keys that are injected at build time from
/// the active `.xcconfig` file, so Debug and Release builds automatically use
/// separate containers without any code changes.
nonisolated enum ContainerConfiguration {

    /// The fully-qualified App Group identifier (e.g.
    /// `group.com.example.SensorApp`).
    ///
    /// Terminates with a `fatalError` if the key is absent from `Info.plist`,
    /// which indicates a misconfigured xcconfig.
    static var appGroupID: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "APP_GROUP_ID") as? String else {
            fatalError("APP_GROUP_ID not found in Info.plist — check xcconfig configuration")
        }
        return value
    }

    /// The fully-qualified CloudKit container identifier (e.g.
    /// `iCloud.com.example.SensorApp`).
    ///
    /// Terminates with a `fatalError` if the key is absent from `Info.plist`,
    /// which indicates a misconfigured xcconfig.
    static var cloudKitContainerID: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "CLOUDKIT_CONTAINER_ID") as? String else {
            fatalError("CLOUDKIT_CONTAINER_ID not found in Info.plist — check xcconfig configuration")
        }
        return value
    }
}
